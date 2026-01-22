// ====== Firebase Functions v2 (Gen2) ======

const { setGlobalOptions } = require("firebase-functions/v2");

const { onCall } = require("firebase-functions/v2/https");

const admin = require("firebase-admin");

const { PDFDocument, rgb } = require("pdf-lib");

const axios = require("axios");

if (!admin.apps.length) admin.initializeApp();

// Região: América do Sul (São Paulo)

setGlobalOptions({
  region: "southamerica-east1",

  memory: "256MiB",

  timeoutSeconds: 120,

  maxInstances: 10,
});

exports.criarPDF = onCall(async (request) => {
  const { data, auth } = request;

  if (!auth || !auth.uid) throw new Error("Usuário não autenticado.");

  const { contratoId } = data || {};

  if (!contratoId) throw new Error("contratoId é obrigatório.");

  try {
    const contratoRef = admin
      .firestore()
      .collection("contrato")
      .doc(contratoId);

    const contratoDoc = await contratoRef.get();

    if (!contratoDoc.exists) throw new Error("Contrato não encontrado.");

    const info = contratoDoc.data();

    const bucket = admin.storage().bucket();

    const PDF_MODELO_NOME =
      info.opcaoCurso === "3"
        ? "contrato novo 2024.pdf"
        : "contrato novo 2024.pdf";

    const pdfBasePath = `contrato_modelo/${PDF_MODELO_NOME}`;

    const [exists] = await bucket.file(pdfBasePath).exists();

    if (!exists) throw new Error(`Arquivo base não existe: ${pdfBasePath}`);

    const pdfStoragePath = `contratos/${contratoId}.pdf`;

    const pdfContrato = bucket.file(pdfStoragePath);

    const [pdfBytes] = await bucket.file(pdfBasePath).download();

    const pdfDoc = await PDFDocument.load(pdfBytes);

    const firstPage = pdfDoc.getPages()[0];

    if (info.fotoCliente) {
      try {
        const imgResponse = await axios.get(info.fotoCliente, {
          responseType: "arraybuffer",
        });

        const imgBuffer = imgResponse.data;

        const ct = imgResponse.headers["content-type"] || "";

        let image;

        if (
          ct.includes("png") ||
          info.fotoCliente.toLowerCase().endsWith(".png")
        ) {
          image = await pdfDoc.embedPng(imgBuffer);
        } else if (
          ct.includes("jpeg") ||
          ct.includes("jpg") ||
          /\.(jpg|jpeg)$/i.test(info.fotoCliente)
        ) {
          image = await pdfDoc.embedJpg(imgBuffer);
        } else {
          console.warn("Formato de imagem não suportado, tentando PNG...");

          image = await pdfDoc.embedPng(imgBuffer);
        }

        firstPage.drawImage(image, { x: 50, y: 500, width: 100, height: 100 });
      } catch (e) {
        console.error("Erro ao processar imagem:", e);
      }
    }

    // --- PREENCHIMENTO DOS DADOS ---
    const fontSize = 10;
    const color = rgb(0, 0, 0);

    // Função auxiliar para desenhar texto
    const draw = (text, x, y) => {
      if (text) {
        firstPage.drawText(String(text), { x, y, size: fontSize, color });
      }
    };

    // Coordenadas aproximadas (AJUSTAR CONFORME O PDF)
    // Contratante
    draw(info.contratante, 100, 680); 
    draw(info.documento, 100, 665); // CPF
    draw(info.rg, 350, 665); // RG
    draw(info.dn, 500, 665); // DN
    draw(info.filiacao, 100, 650); 
    draw(info.naturalidade, 450, 650);
    draw(info.endereco, 100, 620); // Residente
    draw(info.numero, 500, 620); // Nº
    draw(info.bairro, 100, 605);
    draw(info.cidade, 100, 590);
    draw(info.cep, 350, 590);
    draw(info.uf, 500, 590);
    draw(info.telefones, 100, 575);

    // Aluno
    draw(info.aluno, 100, 540);
    draw(info.alunoDN, 500, 540);
    draw(info.alunoDocumento, 100, 525); // CPF ou RG
    draw(info.alunoNaturalidade, 350, 525);
    draw(info.alunoTelefone, 100, 510);

    // Curso
    if (info.opcaoCurso === '1') draw('X', 50, 480); // Aux. Adm e Com
    if (info.opcaoCurso === '2') draw('X', 50, 465); // Aux. Vet
    if (info.opcaoCurso === '3') draw('X', 250, 480); // Assist. Jur
    if (info.opcaoCurso === '4') {
        draw('X', 250, 465); // Outro
        draw(info.outro, 300, 465);
    }
    
    draw(info.indicacao, 100, 440); // Indicação de

    // Pagamento
    // Ajustar conforme layout da tabela
    // Exemplo genérico:
    // draw(info.primeiraParcela, 200, 300);
    // draw(info.descontoRS, 400, 300);

    // Data final
    const today = new Date();
    draw('Capinzal/SC', 100, 200);
    draw(today.getDate(), 200, 200);
    draw(today.toLocaleString('default', { month: 'long' }), 250, 200);
    draw(today.getFullYear(), 350, 200);
    
    if (info.idCliente) {
      firstPage.drawText(`ID Cliente: ${info.idCliente}`, {
        x: 50,
        y: 450,
        size: 12,
        color: rgb(0, 0, 0),
      });
    }

    const modifiedPdfBytes = await pdfDoc.save();

    await pdfContrato.save(Buffer.from(modifiedPdfBytes), {
      contentType: "application/pdf",

      metadata: { contentType: "application/pdf" },
    });

    const [signedUrl] = await pdfContrato.getSignedUrl({
      action: "read",

      expires: "2500-01-01",
    });

    await contratoRef.update({
      pdf: `gs://${bucket.name}/${pdfStoragePath}`,

      signedUrl,

      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    return { success: true, signedUrl, message: "PDF criado com sucesso!" };
  } catch (error) {
    console.error("Erro ao criar PDF:", error);

    throw new Error(error.message || "Falha ao criar PDF");
  }
});
