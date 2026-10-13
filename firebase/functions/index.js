const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const functionsV1 = require("firebase-functions/v1");
const admin = require("firebase-admin");
const { PDFDocument, rgb, StandardFonts } = require("pdf-lib");
const axios = require("axios");
const FormData = require("form-data");
const fetch = require("node-fetch");
const { randomUUID } = require("crypto");
const { preencherContrato2026, LAYOUT_2026 } = require("./contrato_pdf_layout");
const {
  carimbarAssinaturas,
  carimbarFoto,
  escreverRastro,
} = require("./pdf_pos_assinatura");
const {
  exigirUsuario,
  exigirAdmin,
  exigirAcessoContrato,
  tokenAutentique,
  falhaInterna,
} = require("./acesso");

admin.initializeApp();

// Set global options for V2 functions
setGlobalOptions({ region: "southamerica-east1" });

// V1 Trigger (Auth) - Kept as V1 because V2 Auth triggers are different/blocking
/*
exports.onUserDeleted = functionsV1
  .region("southamerica-east1")
  .runWith({ memory: "256MB", timeoutSeconds: 60 })
  .auth.user()
  .onDelete(async (user) => {
    let firestore = admin.firestore();
    // Example logic
    console.log(`User ${user.uid} deleted.`);
  });
*/


// V2 HTTPS Functions

function fotoPermitida(url) {
  try {
    const parsed = new URL(String(url));
    return (
      parsed.protocol === "https:" &&
      (parsed.hostname === "firebasestorage.googleapis.com" ||
        parsed.hostname === "storage.googleapis.com")
    );
  } catch (error) {
    return false;
  }
}

async function urlAssinadaDoPdf(pdfContrato) {
  const novoToken = randomUUID();
  await pdfContrato.setMetadata({
    contentType: "application/pdf",
    metadata: { firebaseStorageDownloadTokens: novoToken },
  });
  const bucketName = pdfContrato.bucket.name;
  const caminho = encodeURIComponent(pdfContrato.name);
  const signedUrl =
    `https://firebasestorage.googleapis.com/v0/b/${bucketName}/o/${caminho}?alt=media&token=${novoToken}`;
  const expires = Date.now() + 1000 * 60 * 60 * 24 * 2;
  return { signedUrl, expires };
}

exports.deletarPDF = onCall({
  memory: "256MiB",
  timeoutSeconds: 60
}, async (request) => {
  const { auth, data } = request;
  await exigirUsuario(auth);

  const { contratoId } = data || {};
  if (!contratoId) throw new HttpsError("invalid-argument", "contratoId é obrigatório.");

  try {
    const contratoRef = admin.firestore().collection("contrato").doc(contratoId);
    const contratoDoc = await contratoRef.get();
    await exigirAcessoContrato(auth, contratoDoc);

    const bucket = admin.storage().bucket();
    const pdfContrato = bucket.file(`contratos/${contratoId}.pdf`);
    const [exists] = await pdfContrato.exists();

    if (exists) {
      await pdfContrato.delete();
    }
    return { success: true };
  } catch (error) {
    falhaInterna(error, "Falha ao excluir o PDF.");
  }
});

exports.criarPDF = onCall({
  memory: "512MiB",
  timeoutSeconds: 120
}, async (request) => {
  const { auth, data } = request;
  if (!auth || !auth.uid) throw new HttpsError("unauthenticated", "Usuário não autenticado.");

  const { contratoId } = data || {};
  if (!contratoId) throw new HttpsError("invalid-argument", "contratoId é obrigatório.");

  try {
    const contratoRef = admin.firestore().collection("contrato").doc(contratoId);
    const contratoDoc = await contratoRef.get();

    if (!contratoDoc.exists) throw new HttpsError("not-found", "Contrato não encontrado.");
    await exigirAcessoContrato(auth, contratoDoc);

    const info = contratoDoc.data();
    const bucket = admin.storage().bucket();

    // Nome do arquivo modelo
    const PDF_MODELO_NOME = "Contrato 2026.pdf";
    const pdfBasePath = `contrato_modelo/${PDF_MODELO_NOME}`;

    const [exists] = await bucket.file(pdfBasePath).exists();
    if (!exists) {
      console.error(`Template não encontrado: ${pdfBasePath}`);
      try {
        const [files] = await bucket.getFiles({ prefix: 'contrato_modelo/' });
        const fileNames = files.map(f => f.name).join(', ');
        throw new HttpsError("not-found", `Modelo ${PDF_MODELO_NOME} não encontrado em ${pdfBasePath}. Arquivos disponíveis: ${fileNames || 'Nenhum'}`);
      } catch (listError) {
        if (listError.code === 'not-found' || listError instanceof HttpsError) {
          throw listError;
        }
        throw new HttpsError("not-found", `Modelo de contrato não encontrado no Storage: ${pdfBasePath}`);
      }
    }

    const [pdfBytes] = await bucket.file(pdfBasePath).download();
    const pdfDoc = await PDFDocument.load(pdfBytes);
    const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
    const firstPage = pdfDoc.getPages()[0];

    const foto = LAYOUT_2026.foto;
    if (info.fotoCliente && fotoPermitida(info.fotoCliente)) {
      try {
        const imgResponse = await axios.get(info.fotoCliente, {
          responseType: "arraybuffer",
          timeout: 8000,
          maxRedirects: 0,
        });
        const imgBuffer = imgResponse.data;
        const ct = imgResponse.headers["content-type"] || "";
        let image;

        if (ct.includes("png") || info.fotoCliente.toLowerCase().endsWith(".png")) {
          image = await pdfDoc.embedPng(imgBuffer);
        } else if (ct.includes("jpeg") || ct.includes("jpg") || /\.(jpg|jpeg)$/i.test(info.fotoCliente)) {
          image = await pdfDoc.embedJpg(imgBuffer);
        }

        if (image) {
          firstPage.drawImage(image, foto);
        }
      } catch (e) {
        console.warn("Erro ao processar imagem (ignorado):", e.message);
      }
    }

    const color = rgb(0, 0, 0);
    const draw = (text, x, y) => {
      if (text !== undefined && text !== null && text !== "") {
        firstPage.drawText(String(text), { x, y, size: 10, font, color });
      }
    };
    preencherContrato2026(draw, info);

    const modifiedPdfBytes = await pdfDoc.save();
    const pdfStoragePath = `contratos/${contratoId}.pdf`;
    const pdfContrato = bucket.file(pdfStoragePath);

    await pdfContrato.save(Buffer.from(modifiedPdfBytes), {
      contentType: "application/pdf",
      metadata: { contentType: "application/pdf" },
    });

    const { signedUrl, expires } = await urlAssinadaDoPdf(pdfContrato);
    await contratoRef.update({
      pdf: `gs://${bucket.name}/${pdfStoragePath}`,
      signedUrl,
      signedEm: admin.firestore.Timestamp.fromMillis(expires),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, signedUrl, message: "PDF criado com sucesso!" };
  } catch (error) {
    falhaInterna(error, "Falha ao criar PDF.");
  }
});

exports.atualizarToken = onCall({
  memory: "256MiB",
  timeoutSeconds: 60
}, async (request) => {
  const { auth, data } = request;
  await exigirUsuario(auth);

  const { contratoId } = data || {};
  if (!contratoId) throw new HttpsError("invalid-argument", "contratoId é obrigatório.");

  try {
    const contratoRef = admin.firestore().collection("contrato").doc(contratoId);
    const contratoDoc = await contratoRef.get();
    await exigirAcessoContrato(auth, contratoDoc);

    const bucket = admin.storage().bucket();
    const pdfContrato = bucket.file(`contratos/${contratoId}.pdf`);
    const [exists] = await pdfContrato.exists();

    if (!exists) {
      throw new HttpsError("not-found", "Arquivo não existe.");
    }

    const { signedUrl, expires } = await urlAssinadaDoPdf(pdfContrato);
    await contratoRef.update({
      signedUrl,
      signedEm: admin.firestore.Timestamp.fromMillis(expires),
    });

    return signedUrl;
  } catch (error) {
    falhaInterna(error, "Falha ao renovar o link do PDF.");
  }
});

// Dummy functions
exports.escreverPDF = onCall({
  memory: "256MiB",
  timeoutSeconds: 60
}, async (request) => {
  return { success: true, message: "Função obsoleta (integrada ao criarPDF)" };
});

async function pdfDoContrato(auth, contratoId) {
  if (!contratoId) {
    throw new HttpsError("invalid-argument", "contratoId é obrigatório.");
  }
  const contratoRef = admin.firestore().collection("contrato").doc(contratoId);
  const contratoDoc = await contratoRef.get();
  await exigirAcessoContrato(auth, contratoDoc);
  const pdfContrato = admin.storage().bucket().file(`contratos/${contratoId}.pdf`);
  const [exists] = await pdfContrato.exists();
  if (!exists) {
    throw new HttpsError("not-found", "Arquivo PDF não encontrado.");
  }
  const [bytes] = await pdfContrato.download();
  const pdfDoc = await PDFDocument.load(bytes);
  return { contratoDoc, pdfContrato, pdfDoc };
}

exports.assinarContrato = onCall({
  memory: "512MiB",
  timeoutSeconds: 120,
}, async (request) => {
  const { auth, data } = request;
  try {
    const { contratoDoc, pdfContrato, pdfDoc } = await pdfDoContrato(
      auth,
      data && data.contratoId,
    );
    await carimbarAssinaturas(pdfDoc, contratoDoc.data());
    await pdfContrato.save(Buffer.from(await pdfDoc.save()));
    return { success: true };
  } catch (error) {
    falhaInterna(error, "Falha ao carimbar a assinatura.");
  }
});

exports.fotoCliente = onCall({
  memory: "512MiB",
  timeoutSeconds: 120,
}, async (request) => {
  const { auth, data } = request;
  try {
    const { contratoDoc, pdfContrato, pdfDoc } = await pdfDoContrato(
      auth,
      data && data.contratoId,
    );
    await carimbarFoto(pdfDoc, contratoDoc.data());
    await pdfContrato.save(Buffer.from(await pdfDoc.save()));
    return { success: true };
  } catch (error) {
    falhaInterna(error, "Falha ao inserir a foto no PDF.");
  }
});

exports.escreveIp = onCall({
  memory: "512MiB",
  timeoutSeconds: 120,
}, async (request) => {
  const { auth, data } = request;
  try {
    const { contratoDoc, pdfContrato, pdfDoc } = await pdfDoContrato(
      auth,
      data && data.contratoId,
    );
    await escreverRastro(pdfDoc, contratoDoc.data());
    await pdfContrato.save(Buffer.from(await pdfDoc.save()));
    return { success: true };
  } catch (error) {
    falhaInterna(error, "Falha ao registrar o rastro no PDF.");
  }
});

exports.enviarContratoAutentique = onCall({
  memory: "512MiB",
  timeoutSeconds: 120
}, async (request) => {
  const { auth, data } = request;
  if (!auth || !auth.uid) throw new HttpsError("unauthenticated", "Usuário não autenticado.");

  const { contratoId, emailAluno, whatsappAluno } = data || {};
  if (!contratoId) throw new HttpsError("invalid-argument", "contratoId é obrigatório.");

  const emailClean = emailAluno ? emailAluno.trim() : "";
  const whatsappClean = whatsappAluno ? whatsappAluno.trim() : "";

  try {
    const contratoRef = admin.firestore().collection("contrato").doc(contratoId);
    const contratoDoc = await contratoRef.get();

    if (!contratoDoc.exists) throw new HttpsError("not-found", "Contrato não encontrado.");
    await exigirAcessoContrato(auth, contratoDoc);

    const info = contratoDoc.data();
    const bucket = admin.storage().bucket();
    const pdfStoragePath = `contratos/${contratoId}.pdf`;
    const file = bucket.file(pdfStoragePath);

    const [exists] = await file.exists();
    if (!exists) throw new HttpsError("not-found", "Arquivo PDF do contrato não encontrado.");

    const [fileBuffer] = await file.download();

    const token = await tokenAutentique();

    const url = "https://api.autentique.com.br/v2/graphql";

    // Sanitizar telefone para formato +55...
    let phone = null;

    // Prioriza o whatsapp passado explicitamente, senão usa do cadastro
    const phoneSource = whatsappClean || info.alunoTelefone || info.telefones;

    if (phoneSource) {
      // Remove tudo que não é dígito
      let nums = phoneSource.replace(/\D/g, "");

      // Se o usuário digitou com 55 na frente (ex: 5511999999999), remove o 55 duplicado se tiver
      if (nums.startsWith("55") && nums.length > 11) {
        // Já tem DDI
      } else {
        // Adiciona DDI Brasil
        nums = "55" + nums;
      }

      // Validação básica: DDI (2) + DDD (2) + Numero (8 ou 9) = 12 ou 13 dígitos
      if (nums.length >= 12 && nums.length <= 13) {
        phone = `+${nums}`;
      }
    }

    if (!emailClean && !phone) {
      throw new HttpsError("invalid-argument", "É necessário informar ao menos um meio de contato (Email ou WhatsApp).");
    }



    // Função auxiliar para criar o payload
    const createPayload = (usePhone) => {
      const signer = {
        action: "SIGN",
      };

      if (usePhone && phone) {
        // Se usar WhatsApp, envia APENAS o telefone
        signer.phone = phone;
        signer.delivery_method = "DELIVERY_METHOD_WHATSAPP";
      } else if (emailClean) {
        // Se NÃO usar WhatsApp (ou fallback), envia o E-mail se existir
        signer.email = emailClean;
      }

      const signers = [signer];

      return {
        query: `
          mutation CreateDocument($document: DocumentInput!, $signers: [SignerInput!]!, $file: Upload!) {
            createDocument(document: $document, signers: $signers, file: $file) {
              id
              name
              created_at
              signatures {
                public_id
                name
                email
                created_at
                action { name }
                link { short_link }
              }
            }
          }
        `,
        variables: {
          document: {
            name: `Contrato - ${info.aluno || "Aluno"}`,
            qualified: false,
            message: `Olá, segue o contrato para assinatura digital via Autentique.`,
            ignore_cpf: false, // Exige CPF do signatário
            configs: {
              signature_appearance: "ELETRONIC"
            }
          },
          signers,
          file: null,
        },
      };
    };

    const map = {
      0: ["variables.file"],
    };

    const summarizeAttempt = (deliveryMethod, response, result) => ({
      deliveryMethod,
      httpStatus: response.status,
      ok: response.ok && !result.errors,
      errors: result.errors || null,
      document: result?.data?.createDocument
        ? {
            id: result.data.createDocument.id || null,
            name: result.data.createDocument.name || null,
            createdAt: result.data.createDocument.created_at || null,
            signatures: (result.data.createDocument.signatures || []).map((signature) => ({
              publicId: signature.public_id || null,
              name: signature.name || null,
              email: signature.email || null,
              createdAt: signature.created_at || null,
              shortLink: signature.link?.short_link || null,
            })),
          }
        : null,
    });

    const executeAutentiqueRequest = async (usePhone) => {
      const attemptDeliveryMethod = usePhone && phone ? "whatsapp" : "email";
      const operations = createPayload(usePhone);
      const formData = new FormData();
      formData.append("operations", JSON.stringify(operations));
      formData.append("map", JSON.stringify(map));
      formData.append("0", fileBuffer, {
        filename: "contrato.pdf",
        contentType: "application/pdf",
      });

      const response = await fetch(url, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`,
          ...formData.getHeaders(),
        },
        body: formData,
      });

      const result = await response.json();
      attempts.push(summarizeAttempt(attemptDeliveryMethod, response, result));
      return result;
    };

    // TENTATIVA 1: Com WhatsApp (se disponível)
    const requestedDeliveryMethod = phone ? "whatsapp" : "email";
    let deliveryMethodUsed = requestedDeliveryMethod;
    let fallbackUsed = false;
    const attempts = [];

    let result = await executeAutentiqueRequest(true);

    // SE FALHAR E TIVER WHATSAPP: Tenta novamente SEM WhatsApp (Fallback)
    // Apenas se tivermos email para fallback
    if (result.errors && phone && emailClean) {
      console.warn("Falha no envio com WhatsApp. Tentando apenas email...", JSON.stringify(result.errors));
      deliveryMethodUsed = "email";
      fallbackUsed = true;

      result = await executeAutentiqueRequest(false);
    }

    if (result.errors) {
      console.error("Autentique API Errors (Final):", JSON.stringify(result.errors));
      throw new HttpsError(
        "internal",
        `Erro na API Autentique: ${result.errors[0].message}`,
        {
          source: "autentique",
          requestedDeliveryMethod,
          deliveryMethodUsed,
          fallbackUsed,
        },
      );
    }

    await contratoRef.update({
      autentiqueId: result.data.createDocument.id,
      autentiqueStatus: "enviado",
      emailAluno: emailClean,
    });

    return {
      success: true,
      autentiqueId: result.data.createDocument.id,
      requestedDeliveryMethod,
      deliveryMethodUsed,
      fallbackUsed,
      emailAluno: emailClean || null,
      whatsappAluno: phone,
      attempts,
      apiResponse: attempts[attempts.length - 1] || null,
    };

  } catch (error) {
    console.error("Erro ao enviar para Autentique:", error);
    if (error instanceof HttpsError) {
      throw error;
    }

    falhaInterna(error, "Falha ao enviar contrato.");
  }
});

exports.gerenciarUsuario = onCall({
  memory: "256MiB",
  timeoutSeconds: 60,
}, async (request) => {
  const { auth, data } = request;
  await exigirAdmin(auth);

  const { uid, displayName, email, password } = data || {};
  const emailLimpo = email ? String(email).trim() : "";
  const senha = password ? String(password) : "";

  if (emailLimpo && !/^[\w.-]+@([\w-]+\.)+[\w-]{2,}$/.test(emailLimpo)) {
    throw new HttpsError("invalid-argument", "E-mail inválido.");
  }
  if (senha && senha.length < 8) {
    throw new HttpsError("invalid-argument", "A senha precisa ter pelo menos 8 caracteres.");
  }

  try {
    if (uid) {
      const updateUserObject = {};
      if (emailLimpo) updateUserObject.email = emailLimpo;
      if (senha) updateUserObject.password = senha;
      if (Object.keys(updateUserObject).length > 0) {
        await admin.auth().updateUser(uid, updateUserObject);
      }

      const userDocUpdate = {};
      if (displayName) userDocUpdate.display_name = String(displayName).slice(0, 120);
      if (emailLimpo) userDocUpdate.email = emailLimpo;
      if (Object.keys(userDocUpdate).length > 0) {
        await admin.firestore().collection("user").doc(uid).update(userDocUpdate);
      }
      console.info("Usuário atualizado", { actor: auth.uid, alvo: uid });
      return { success: true };
    }

    if (!emailLimpo || !senha) {
      throw new HttpsError("invalid-argument", "E-mail e senha são obrigatórios.");
    }

    const user = await admin.auth().createUser({
      email: emailLimpo,
      password: senha,
      displayName: displayName ? String(displayName).slice(0, 120) : undefined,
    });
    await admin.firestore().collection("user").doc(user.uid).set({
      uid: user.uid,
      email: user.email,
      display_name: displayName ? String(displayName).slice(0, 120) : "",
      created_time: admin.firestore.FieldValue.serverTimestamp(),
      isAdmin: false,
    });
    console.info("Usuário criado", { actor: auth.uid, alvo: user.uid });
    return { success: true, uid: user.uid };
  } catch (error) {
    falhaInterna(error, "Falha ao gerenciar o usuário.");
  }
});

exports.reservarNumeroContrato = onCall({
  memory: "256MiB",
  timeoutSeconds: 30,
}, async (request) => {
  const { auth } = request;
  await exigirUsuario(auth);

  const ref = admin.firestore().doc("config/contador");
  try {
    const existente = await ref.get();
    if (!existente.exists) {
      const countSnap = await admin.firestore().collection("contrato").count().get();
      try {
        await ref.create({ numero: countSnap.data().count });
      } catch (error) {
        if (error.code !== 6 && error.code !== "already-exists") throw error;
      }
    }

    const numero = await admin.firestore().runTransaction(async (tx) => {
      const snap = await tx.get(ref);
      const atual = snap.exists ? Number(snap.data().numero) || 0 : 0;
      const proximo = atual + 1;
      tx.set(ref, { numero: proximo }, { merge: true });
      return proximo;
    });
    return { numero };
  } catch (error) {
    falhaInterna(error, "Falha ao reservar o número do contrato.");
  }
});
