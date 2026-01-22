const functions = require("firebase-functions");
const admin = require("firebase-admin");
// To avoid deployment errors, do not call admin.initializeApp() in your code

// Importar a biblioteca PDF-lib para manipulação de PDFs

const { PDFDocument } = require("pdf-lib");

exports.escreveIp = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    // Verifica se o usuário está autenticado

    if (!context.auth) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "O usuário deve estar autenticado.",
      );
    }

    const { contratoId } = data;

    try {
      // Referência ao documento do Firestore

      const contratoRef = admin
        .firestore()
        .collection("contrato")
        .doc(contratoId);

      const contratoDoc = await contratoRef.get();

      // Verifica se o contrato existe

      if (!contratoDoc.exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "Contrato não encontrado.",
        );
      }

      // Referência ao arquivo PDF no Firebase Storage

      const bucket = admin.storage().bucket();

      const pdfContrato = bucket.file(`contratos/${contratoId}.pdf`);

      // Verifica se o PDF existe

      const [exists] = await pdfContrato.exists();

      if (!exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "Arquivo PDF não existe.",
        );
      }

      // Obtenção dos dados do contrato

      const info = contratoDoc.data();

      // Faz download do arquivo PDF existente

      const [existingPdfBytes] = await pdfContrato.download();

      // Carrega o PDF usando a biblioteca PDF-lib

      const pdfDoc = await PDFDocument.load(existingPdfBytes);

      // Função para inserir dados no PDF

      escreverNoPDF(pdfDoc, info);

      // Salva as modificações no PDF

      const modifiedPdfBytes = await pdfDoc.save();

      // Sobrescreve o arquivo PDF existente no Storage

      await pdfContrato.save(modifiedPdfBytes);
    } catch (error) {
      console.error("Erro ao manipular o PDF ou contrato:", error);

      throw new functions.https.HttpsError("internal", error.message);
    }
  });

// Função para escrever no PDF

function escreverNoPDF(pdfDoc, info) {
  // Obtém as páginas do PDF

  const pages = pdfDoc.getPages();

  const size = 10;

  // Garante que o PDF tenha ao menos 3 páginas

  while (pages.length < 3) {
    pdfDoc.addPage();
  }

  // Acessa a terceira página do PDF

  const thirdPage = pages[2];

  // Adiciona informações na terceira página

  thirdPage.drawText(`${info.urlLink}`, { x: 35, y: 670, size });

  thirdPage.drawText(`${info.contratante}`, { x: 35, y: 550, size });

  thirdPage.drawText(`${info.telefones}`, { x: 35, y: 538, size });

  thirdPage.drawText(`${info.dtCriacao}`, { x: 35, y: 383, size });

  thirdPage.drawText(`${info.criado_por}`, { x: 35, y: 373, size });

  thirdPage.drawText(`Criou o envelope no dia: ${info.dtCriacao}`, {
    x: 35,
    y: 363,
    size,
  });

  thirdPage.drawText(`${info.contratante}`, { x: 35, y: 343, size });

  thirdPage.drawText(
    `Assinou e fotografou o rosto - Telefone:${info.telefones}`,
    { x: 35, y: 333, size },
  );

  thirdPage.drawText(`${info.ipCliente}`, { x: 35, y: 323, size });

  thirdPage.drawText(`- Geolocalização: ${info.geolocalizacao}`, {
    x: 129,
    y: 323,
    size,
  });

  thirdPage.drawText(
    `Documento de identificação informado: ${info.documento}`,
    { x: 35, y: 313, size },
  );

  thirdPage.drawText(`no dia: ${info.dtAssinado}`, { x: 283, y: 313, size });
}
