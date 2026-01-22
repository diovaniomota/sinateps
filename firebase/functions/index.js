const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const functionsV1 = require("firebase-functions/v1");
const admin = require("firebase-admin");
const { PDFDocument, rgb, StandardFonts } = require("pdf-lib");
const axios = require("axios");
const FormData = require("form-data");
const fetch = require("node-fetch");
const { randomUUID } = require("crypto");

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

exports.deletarPDF = onCall({
  memory: "256MiB",
  timeoutSeconds: 60
}, async (request) => {
  const { auth, data } = request;
  if (!auth || !auth.uid) return;

  const { contratoId } = data || {};
  if (!contratoId) throw new HttpsError("invalid-argument", "contratoId é obrigatório.");

  try {
    const bucket = admin.storage().bucket();
    const pdfContrato = bucket.file(`contratos/${contratoId}.pdf`);
    const [exists] = await pdfContrato.exists();

    if (exists) {
      await pdfContrato.delete();
    }
    return { success: true };
  } catch (error) {
    console.error("Erro ao deletar PDF:", error);
    throw new HttpsError("internal", error.message);
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

    // Obter dimensões da página
    const { width, height } = firstPage.getSize();
    console.log(`PDF Page Size: ${width} x ${height}`);

    // --- MODO CALIBRAÇÃO ---
    // Ativa se o campo "calibrar" estiver presente nos dados
    const CALIBRATION_MODE = info.calibrar === true || info.calibrar === "true";

    if (CALIBRATION_MODE) {
      const calibColor = rgb(1, 0, 0); // Vermelho para calibração
      const calibFont = font;

      // Desenhar linhas horizontais a cada 50 pixels com labels Y
      for (let y = 0; y <= height; y += 50) {
        // Linha horizontal
        firstPage.drawLine({
          start: { x: 0, y: y },
          end: { x: width, y: y },
          thickness: 0.5,
          color: rgb(0.8, 0.8, 0.8),
        });
        // Label Y
        firstPage.drawText(`Y=${y}`, { x: 5, y: y + 2, size: 7, font: calibFont, color: calibColor });
      }

      // Desenhar linhas verticais a cada 100 pixels com labels X
      for (let x = 0; x <= width; x += 100) {
        firstPage.drawLine({
          start: { x: x, y: 0 },
          end: { x: x, y: height },
          thickness: 0.5,
          color: rgb(0.8, 0.8, 0.8),
        });
        firstPage.drawText(`X=${x}`, { x: x + 2, y: 5, size: 7, font: calibFont, color: calibColor });
      }

      // Marcar pontos importantes com labels
      const markers = [
        { x: 50, y: 700, label: "TOPO" },
        { x: 50, y: 600, label: "CONTRATANTE" },
        { x: 50, y: 500, label: "ALUNO" },
        { x: 50, y: 400, label: "CURSO" },
        { x: 50, y: 300, label: "PAGAMENTO" },
        { x: 50, y: 200, label: "PARCELA" },
        { x: 50, y: 100, label: "RODAPE" },
      ];

      markers.forEach(m => {
        firstPage.drawCircle({ x: m.x, y: m.y, size: 5, color: calibColor });
        firstPage.drawText(`${m.label} (${m.x},${m.y})`, { x: m.x + 10, y: m.y, size: 8, font: calibFont, color: calibColor });
      });
    }

    // --- FOTO CLIENTE (Opcional) ---
    if (info.fotoCliente) {
      try {
        const imgResponse = await axios.get(info.fotoCliente, { responseType: "arraybuffer" });
        const imgBuffer = imgResponse.data;
        const ct = imgResponse.headers["content-type"] || "";
        let image;

        if (ct.includes("png") || info.fotoCliente.toLowerCase().endsWith(".png")) {
          image = await pdfDoc.embedPng(imgBuffer);
        } else if (ct.includes("jpeg") || ct.includes("jpg") || /\.(jpg|jpeg)$/i.test(info.fotoCliente)) {
          image = await pdfDoc.embedJpg(imgBuffer);
        }

        if (image) {
          firstPage.drawImage(image, { x: 50, y: 500, width: 100, height: 100 });
        }
      } catch (e) {
        console.warn("Erro ao processar imagem (ignorado):", e.message);
      }
    }

    // --- PREENCHIMENTO DOS DADOS ---
    const fontSize = 10;
    const color = rgb(0, 0, 0);

    const draw = (text, x, y) => {
      if (text !== undefined && text !== null && text !== '') {
        firstPage.drawText(String(text), { x, y, size: fontSize, font, color });
      }
    };

    // ============================================
    // COORDENADAS CALIBRADAS - PDF: 612 x 1008
    // ============================================

    // === CONTRATANTE ===
    draw(info.contratante, 127, 761);  // Nome Contratante
    draw(info.documento, 59, 746);     // CPF
    draw(info.rg, 326, 747);           // RG
    if (info.dn) {
      const [d, m, y] = info.dn.split("/");
      if (d) draw(d, 491, 744);        // DN Dia
      if (m) draw(m, 513, 744);        // DN Mês
      if (y) draw(y, 538, 744);        // DN Ano
    }
    draw(info.filiacao, 77, 734);      // Filiação
    draw(info.naturalidade, 442, 735); // Naturalidade

    if (info.sexo === "M") {
      draw("X", 108, 720);             // Sexo M
    } else if (info.sexo === "F") {
      draw("X", 172, 721);             // Sexo F
    }

    draw(info.endereco, 176, 711);     // Endereço
    draw(info.numero, 527, 710);       // Número
    draw(info.bairro, 65, 700);        // Bairro
    draw(info.cidade, 71, 688);        // Cidade
    draw(info.cep, 357, 686);          // CEP
    draw(info.uf, 491, 686);           // UF
    draw(info.telefones, 81, 676);     // Telefones

    // === ALUNO ===
    draw(info.aluno, 103, 640);         // Nome Aluno
    draw(info.alunoDocumento, 89, 627); // CPF/RG Aluno
    if (info.alunoDN) {
      const [d, m, y] = info.alunoDN.split("/");
      if (d) draw(d, 474, 639);        // Aluno DN Dia
      if (m) draw(m, 500, 639);        // Aluno DN Mês
      if (y) draw(y, 526, 639);        // Aluno DN Ano
    }
    draw(info.alunoNaturalidade, 467, 627);  // Aluno Naturalidade
    draw(info.alunoTelefone, 70, 614); // Aluno Telefone

    // === OPÇÃO DE CURSO ===
    const opcaoCursoRaw = info.opcaoCurso !== undefined && info.opcaoCurso !== null ? String(info.opcaoCurso).trim() : "";
    const opcaoCursoKeyMatch = opcaoCursoRaw.match(/^[1-4]/);
    const opcaoCursoKey = opcaoCursoKeyMatch ? opcaoCursoKeyMatch[0] : opcaoCursoRaw;

    switch (opcaoCursoKey) {
      case "1": draw("X", 38, 562); break;   // Curso 1
      case "2": draw("X", 38, 552); break;   // Curso 2
      case "3": draw("X", 183, 561); break;   // Curso 3
      case "4": draw("X", 183, 552); break;   // Curso 4
    }

    if (opcaoCursoKey === "4" && info.outro) {
      draw(info.outro, 255, 555);  // Outro/Qual
    }

    draw(info.indicacao, 96, 538);  // Indicação

    // === DISPOSIÇÕES INICIAIS ===
    if (info.horas) {
      draw(info.horas, 510, 445);  // Carga Horária
    }

    if (info.inicioPrevisto) {
      const parts = info.inicioPrevisto.split("/");
      if (parts.length >= 1) draw(parts[0], 268, 434);  // Início Dia
      if (parts.length >= 2) draw(parts[1], 295, 434);  // Início Mês
    }
    draw(info.contratada, 456, 433);  // Contratada

    // === PAGAMENTO (Checkboxes) ===
    if (info.opcaoCurso === "3") {
      switch (info.pagamento) {
        case "18": draw("X", 76, 339); break;
        case "12": draw("X", 292, 341); break;
        case "8": draw("X", 292, 371); break;
        case "5": draw("X", 292, 354); break;
        case "3": draw("X", 292, 354); break;
        case "0": draw("X", 292, 341); break;
      }
    } else {
      switch (info.pagamento) {
        case "36": draw("X", 76, 371); break;   // 36x
        case "24": draw("X", 76, 356); break;   // 24x
        case "18": draw("X", 76, 339); break;   // 18x
        case "14": draw("X", 76, 323); break;   // 14x
        case "8": draw("X", 292, 371); break;   // 8x
        case "3": draw("X", 292, 354); break;   // 3x
        case "12": draw("X", 292, 341); break;   // À Vista
      }
    }

    // === PRIMEIRA PARCELA E DESCONTO ===
    if (info.primeiraParcela) {
      const [d, m, y] = info.primeiraParcela.split("/");
      if (d) draw(d, 184, 300);   // Parcela Dia
      if (m) draw(m, 210, 300);   // Parcela Mês
      if (y) draw(y, 228, 300);   // Parcela Ano
    }

    draw(info.descontoRS, 292, 281);  // Desconto R$

    // === DATA FINAL (RODAPÉ) ===
    const dataFinal = info.criado_str ? info.criado_str.split("/") : [];
    if (dataFinal.length === 3) {
      draw(dataFinal[0], 97, 210);    // Data Dia
      draw(dataFinal[1], 160, 210);    // Data Mês
      draw(dataFinal[2], 248, 211);   // Data Ano
    } else {
      const today = new Date();
      draw(String(today.getDate()), 97, 210);
      draw(String(today.getMonth() + 1), 160, 210);
      draw(String(today.getFullYear()), 248, 211);
    }

    const modifiedPdfBytes = await pdfDoc.save();
    const pdfStoragePath = `contratos/${contratoId}.pdf`;
    const pdfContrato = bucket.file(pdfStoragePath);

    await pdfContrato.save(Buffer.from(modifiedPdfBytes), {
      contentType: "application/pdf",
      metadata: { contentType: "application/pdf" },
    });

    const token = randomUUID();
    await pdfContrato.setMetadata({
      contentType: "application/pdf",
      metadata: { firebaseStorageDownloadTokens: token }
    });
    const signedUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(pdfStoragePath)}?alt=media&token=${token}`;

    await contratoRef.update({
      pdf: `gs://${bucket.name}/${pdfStoragePath}`,
      signedUrl,
      signedEm: admin.firestore.Timestamp.fromDate(new Date("2500-01-01")),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, signedUrl, message: "PDF criado com sucesso!" };
  } catch (error) {
    console.error("Erro CRITICO ao criar PDF:", error);
    throw new HttpsError("internal", error.message || "Falha ao criar PDF");
  }
});

exports.atualizarToken = onCall({
  memory: "256MiB",
  timeoutSeconds: 60
}, async (request) => {
  const { auth, data } = request;
  if (!auth || !auth.uid) return;

  const { contratoId } = data || {};
  if (!contratoId) throw new HttpsError("invalid-argument", "contratoId é obrigatório.");

  try {
    const contratoRef = admin.firestore().collection("contrato").doc(contratoId);
    const contratoDoc = await contratoRef.get();

    if (!contratoDoc.exists) {
      throw new HttpsError("not-found", "Contrato não encontrado.");
    }

    const bucket = admin.storage().bucket();
    const pdfContrato = bucket.file(`contratos/${contratoId}.pdf`);
    const [exists] = await pdfContrato.exists();

    if (!exists) {
      throw new HttpsError("not-found", "Arquivo não existe.");
    }

    const [metadata] = await pdfContrato.getMetadata();
    let token = metadata.metadata && metadata.metadata.firebaseStorageDownloadTokens;
    if (!token) {
      token = randomUUID();
      await pdfContrato.setMetadata({
        metadata: { firebaseStorageDownloadTokens: token }
      });
    } else {
      token = String(token).split(",")[0].trim();
    }
    const signedUrl = `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(`contratos/${contratoId}.pdf`)}?alt=media&token=${token}`;

    await contratoRef.update({
      signedUrl,
      signedEm: admin.firestore.Timestamp.fromDate(new Date("2500-01-01"))
    });

    return signedUrl;
  } catch (error) {
    console.warn("Stack", error.stack);
    throw new HttpsError("internal", error.message);
  }
});

// Dummy functions
exports.escreverPDF = onCall({
  memory: "256MiB",
  timeoutSeconds: 60
}, async (request) => {
  return { success: true, message: "Função obsoleta (integrada ao criarPDF)" };
});

exports.assinarContrato = onCall({
  memory: "256MiB",
  timeoutSeconds: 60
}, async (request) => {
  return { success: true, message: "Função obsoleta (assinatura via Autentique)" };
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

    const info = contratoDoc.data();
    const bucket = admin.storage().bucket();
    const pdfStoragePath = `contratos/${contratoId}.pdf`;
    const file = bucket.file(pdfStoragePath);

    const [exists] = await file.exists();
    if (!exists) throw new HttpsError("not-found", "Arquivo PDF do contrato não encontrado.");

    const [fileBuffer] = await file.download();

    const configRef = admin.firestore().doc("config/autentique");
    const doc = await configRef.get();

    let token;
    if (doc.exists && doc.data()?.token) {
      token = doc.data().token;
    } else {
      // Token de fallback (migração)
      token = "d6f1b4406a7ac821b66eaa48f1cdb28363b1d461fd245e4dfeacb86a328223ab";
      console.log("Migrando token Autentique para o Firestore...");
      try {
        await configRef.set({ token }, { merge: true });
      } catch (e) {
        console.warn("Falha ao salvar token no Firestore (ignorado):", e);
      }
    }

    if (!token) {
      throw new HttpsError("internal", "Configuração inválida: token Autentique ausente.");
    }

    const url = "https://api.autentique.com.br/v2/graphql";

    // Sanitizar telefone para formato +55...
    let phone = null;

    // Prioriza o whatsapp passado explicitamente, senão usa do cadastro
    const phoneSource = whatsappClean || info.telefones;

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

    console.log("Phone Source:", phoneSource);
    console.log("Phone Formatted:", phone);

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

      console.log(`Payload (usePhone=${usePhone}):`, JSON.stringify(signers));
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

    // TENTATIVA 1: Com WhatsApp (se disponível)
    let operations = createPayload(true);
    let formData = new FormData();
    formData.append("operations", JSON.stringify(operations));
    formData.append("map", JSON.stringify(map));
    formData.append("0", fileBuffer, { filename: "contrato.pdf", contentType: "application/pdf" });

    let response = await fetch(url, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
        ...formData.getHeaders(),
      },
      body: formData,
    });

    let result = await response.json();

    // SE FALHAR E TIVER WHATSAPP: Tenta novamente SEM WhatsApp (Fallback)
    // Apenas se tivermos email para fallback
    if (result.errors && phone && emailClean) {
      console.warn("Falha no envio com WhatsApp. Tentando apenas email...", JSON.stringify(result.errors));

      operations = createPayload(false); // Recria payload SEM telefone (apenas email)
      formData = new FormData();
      formData.append("operations", JSON.stringify(operations));
      formData.append("map", JSON.stringify(map));
      formData.append("0", fileBuffer, { filename: "contrato.pdf", contentType: "application/pdf" });

      response = await fetch(url, {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`,
          ...formData.getHeaders(),
        },
        body: formData,
      });

      result = await response.json();
    }

    if (result.errors) {
      console.error("Autentique API Errors (Final):", JSON.stringify(result.errors));
      // Retorna o erro detalhado para o frontend
      throw new HttpsError("internal", `Erro na API Autentique: ${result.errors[0].message}`);
    }

    await contratoRef.update({
      autentiqueId: result.data.createDocument.id,
      autentiqueStatus: "enviado",
      emailAluno: emailClean,
    });

    return {
      success: true,
      autentiqueId: result.data.createDocument.id,
    };

  } catch (error) {
    console.error("Erro ao enviar para Autentique:", error);
    throw new HttpsError("internal", `Falha ao enviar contrato: ${error.message}`);
  }
});
