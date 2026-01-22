const functions = require("firebase-functions");
const admin = require("firebase-admin");
// To avoid deployment errors, do not call admin.initializeApp() in your code

const { PDFDocument, degrees } = require("pdf-lib");

exports.assinarContrato = functions
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

      await assinarNoPDF(pdfDoc, info);

      const modifiedPdfBytes = await pdfDoc.save();

      await pdfContrato.save(modifiedPdfBytes);
    } catch (error) {
      // Se ocorrer um erro, retorne um erro HTTP interno

      console.warn("Stack", error.stack);

      throw new functions.https.HttpsError("internal", error.message);
    }
  });

async function assinarNoPDF(pdfDoc, info) {
  const [firstPage, secondPage, thirdPage] = pdfDoc.getPages();

  if (info.assinatura) {
    // Baixa a imagem da URL

    const img = await fetch(info.assinatura);

    const buffer = await img.arrayBuffer();

    // Adiciona a imagem à primeira página do PDF

    const image = await pdfDoc.embedPng(buffer);

    firstPage.drawImage(image, {
      x: 395 + (image.height * 0.23) / 2, // Reduzido para 0.25

      y: 140, // Movido para baixo

      width: image.width * 0.25, // Reduzido para 0.25

      height: image.height * 0.25, // Reduzido para 0.25

      rotate: degrees(90),
    });

    secondPage.drawImage(image, {
      x: 390 + (image.height * 0.2) / 2, // Reduzido para 0.25

      y: 60, // Movido para baixo

      width: image.width * 0.25,

      height: image.height * 0.25,

      rotate: degrees(90),
    });

    // Adiciona a imagem à terceira página

    thirdPage.drawImage(image, {
      x: 300 + (image.height * 0.25) / 2, // Mesmo valor da segunda página

      y: 540, // Movido para baixo

      width: image.width * 0.25,

      height: image.height * 0.25,

      rotate: degrees(90),
    });
  }

  if (info.assTestemunha) {
    const img = await fetch(info.assTestemunha);

    const buffer = await img.arrayBuffer();

    const image = await pdfDoc.embedPng(buffer);

    firstPage.drawImage(image, {
      x: 430 + (image.height * 0.25) / 2, // Reduzido para 0.25

      y: 138.5,

      width: image.width * 0.25,

      height: image.height * 0.25,

      rotate: degrees(90),
    });

    secondPage.drawImage(image, {
      x: 385 + (image.height * 0.25) / 2,

      y: 45,

      width: image.width * 0.25,

      height: image.height * 0.25,

      rotate: degrees(90),
    });

    // Adiciona a imagem à terceira página

    thirdPage.drawImage(image, {
      x: 385 + (image.height * 0.25) / 2, // Mesmo valor da segunda página

      y: 45, // Movido para baixo

      width: image.width * 0.25,

      height: image.height * 0.25,

      rotate: degrees(90),
    });
  }
}
