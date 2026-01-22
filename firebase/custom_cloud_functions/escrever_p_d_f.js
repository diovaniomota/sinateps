const functions = require("firebase-functions");
const admin = require("firebase-admin");
// To avoid deployment errors, do not call admin.initializeApp() in your code

// Importar a biblioteca PDF-lib para manipulação de PDFs

const { PDFDocument } = require("pdf-lib");

exports.escreverPDF = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    if (!context.auth.uid) return;

    const { contratoId } = data;

    try {
      const contratoRef = admin
        .firestore()
        .collection("contrato")
        .doc(contratoId);

      const contratoDoc = await contratoRef.get();

      if (!contratoDoc.exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "Contrato não encontrado.",
        );
      }

      const bucket = admin.storage().bucket();

      const pdfContrato = bucket.file(`contratos/${contratoId}.pdf`);

      const [exists] = await pdfContrato.exists();

      if (!exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "Arquivo não existe.",
        );
      }

      const info = contratoDoc.data();

      const [existingPdfBytes] = await pdfContrato.download();

      const pdfDoc = await PDFDocument.load(existingPdfBytes);

      escreverNoPDF(pdfDoc, info);

      const modifiedPdfBytes = await pdfDoc.save();

      await pdfContrato.save(modifiedPdfBytes);
    } catch (error) {
      console.warn("Stack", error.stack);

      throw new functions.https.HttpsError("internal", error.message);
    }
  });

function escreverNoPDF(pdfDoc, info) {
  const [firstPage] = pdfDoc.getPages();

  const size = 10;

  // 1. CONTRATANTE - Primeira página

  firstPage.drawText(`${info.contratante}`, { x: 138, y: 666, size });

  firstPage.drawText(`${info.documento}`, { x: 85, y: 650, size });

  firstPage.drawText(`${info.rg}`, { x: 327, y: 650, size });

  if (info.dn) {
    const [day, month, year] = info.dn.split("/");

    if (day) firstPage.drawText(`${day}`, { x: 470, y: 650, size });

    //470

    if (month) firstPage.drawText(`${month}`, { x: 490, y: 650, size });

    if (year) firstPage.drawText(`${year}`, { x: 510, y: 650, size });
  }

  firstPage.drawText(`${info.filiacao}`, { x: 100, y: 640, size });

  firstPage.drawText(`${info.naturalidade}`, { x: 425, y: 640, size });

  if (info.sexo === "M") {
    firstPage.drawText("X", { x: 126, y: 627, size });
  } else if (info.sexo === "F") {
    firstPage.drawText("X", { x: 178.5, y: 627, size });
  }

  firstPage.drawText(`${info.endereco}`, { x: 190, y: 619.5, size });

  firstPage.drawText(`${info.numero}`, { x: 505, y: 619.5, size });

  firstPage.drawText(`${info.bairro}`, { x: 90, y: 607.4, size });

  firstPage.drawText(`${info.cidade}`, { x: 95, y: 596.8, size });

  firstPage.drawText(`${info.cep}`, { x: 350, y: 596.8, size });

  firstPage.drawText(`${info.uf}`, { x: 470, y: 596.8, size });

  firstPage.drawText(`${info.telefones}`, { x: 103, y: 587, size });

  // 2. USUARIO - Primeira página

  firstPage.drawText(`${info.aluno}`, { x: 125, y: 554.5, size });

  if (info.alunoDN) {
    const [day, month, year] = info.alunoDN.split("/");

    if (day) firstPage.drawText(`${day}`, { x: 458, y: 554.5, size });

    if (month) firstPage.drawText(`${month}`, { x: 477, y: 554.5, size });

    if (year) firstPage.drawText(`${year}`, { x: 500, y: 554.5, size });
  }

  firstPage.drawText(`${info.alunoDocumento}`, { x: 110, y: 542, size });

  firstPage.drawText(`${info.alunoNaturalidade}`, { x: 450, y: 542, size });

  firstPage.drawText(`${info.alunoTelefone}`, { x: 95, y: 532, size });

  firstPage.drawText(`${info.opcaoCurso}`, { x: 150, y: 497, size });

  if (info.opcaoCurso === "4") {
    firstPage.drawText(`${info.outro}`, { x: 260, y: 480, size });
  }

  firstPage.drawText(`${info.indicacao}`, { x: 115, y: 465, size });

  // I. DAS DISPOSIÇÕES INICIAIS

  if (info.horas) {
    firstPage.drawText(`${info.horas}`, { x: 485, y: 383, size });
  }

  if (info.inicioPrevisto) {
    const [day, month] = info.inicioPrevisto.split("/");

    if (day) firstPage.drawText(`${day}`, { x: 270, y: 371, size });

    if (month) firstPage.drawText(`${month}`, { x: 290, y: 371, size });
  }

  firstPage.drawText(`${info.contratada}`, { x: 440, y: 371, size });

  // PAGAMENTO - Ajustes conforme o print fornecido

  if (info.opcaoCurso === "3") {
    switch (info.pagamento) {
      case "18":
        firstPage.drawText("X", { x: 74.5, y: 380, size }); // 18x

        break;

      case "12":
        firstPage.drawText("X", { x: 74.5, y: 260, size }); // 12x

        break;

      case "0":
        firstPage.drawText("X", { x: 74.5, y: 349, size }); // À vista

        break;

      case "8":
        firstPage.drawText("X", { x: 291, y: 280, size }); // 8x

        break;

      case "5":
        firstPage.drawText("X", { x: 291, y: 364, size }); // 5x

        break;

      case "3":
        firstPage.drawText("X", { x: 291, y: 300, size }); // 3x

        break;
    }
  } else {
    switch (info.pagamento) {
      case "36":
        firstPage.drawText("X", { x: 95.5, y: 314, size }); // 36x

        break;

      case "24":
        firstPage.drawText("X", { x: 95.5, y: 300, size }); // 24x

        break;

      case "18":
        firstPage.drawText("X", { x: 95.5, y: 286, size }); // 18x

        break;

      case "14":
        firstPage.drawText("X", { x: 290, y: 314, size }); // 14x

        break;

      case "8":
        firstPage.drawText("X", { x: 290, y: 300, size }); // 8x

        break;

      case "3":
        firstPage.drawText("X", { x: 290, y: 286, size }); // 3x

        break;

      case "12":
        firstPage.drawText("X", { x: 290, y: 273, size }); // 12x

        break;
    }
  }

  // Primeira parcela e desconto

  if (info.primeiraParcela) {
    const [day, month, year] = info.primeiraParcela.split("/");

    if (day) firstPage.drawText(`${day}`, { x: 184, y: 250, size });

    if (month) firstPage.drawText(`${month}`, { x: 209, y: 250, size });

    if (year) firstPage.drawText(`${year}`, { x: 232, y: 250, size });
  }

  firstPage.drawText(`${info.descontoRS}`, { x: 287, y: 235, size });

  const [day, month, year] = info.criado_str.split("/");

  firstPage.drawText(`${day}`, { x: 120, y: 174, size });

  firstPage.drawText(`${month}`, { x: 190, y: 174, size });

  firstPage.drawText(`${year}`, { x: 268, y: 174, size });
}

// GERAÇÃO DO CONTRATO - Terceira página
