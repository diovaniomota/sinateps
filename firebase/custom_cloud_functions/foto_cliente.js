const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { PDFDocument, degrees } = require("pdf-lib");

const fetch = require("node-fetch"); // Certifique-se de ter a biblioteca instalada: npm install node-fetch

exports.fotoCliente = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    if (!context.auth || !context.auth.uid) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Usuário não autenticado.",
      );
    }

    const { contratoId } = data;

    try {
      // Referência ao documento do contrato no Firestore

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

      // Referência ao bucket do Firebase Storage

      const bucket = admin.storage().bucket();

      const pdfContrato = bucket.file(`contratos/${contratoId}.pdf`);

      // Verifica se o PDF existe no Storage

      const [exists] = await pdfContrato.exists();

      if (!exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "Arquivo PDF não encontrado.",
        );
      }

      const info = contratoDoc.data();

      // Baixa o PDF existente
      const [existingPdfBytes] = await pdfContrato.download();
      const pdfDoc = await PDFDocument.load(existingPdfBytes);

      // Chama a função para adicionar a foto do cliente e o QR Code ao PDF
      await modificarPDF(pdfDoc, info);

      // Salva o PDF modificado de volta ao bucket
      const modifiedPdfBytes = await pdfDoc.save();
      await pdfContrato.save(Buffer.from(modifiedPdfBytes));
    } catch (error) {
      // Tratamento de erros
      console.warn("Stack", error.stack);
      throw new functions.https.HttpsError("internal", error.message);
    }
  });

// Função auxiliar para inserir imagens no PDF
async function modificarPDF(pdfDoc, info) {
  const pages = pdfDoc.getPages();
  const thirdPage = pages[2]; // Referencia a terceira página

  if (thirdPage) {
    // Lógica para inserir foto do cliente, se disponível
    if (info.fotoCliente) {
      console.log("URL da fotoCliente:", info.fotoCliente);
      try {
        const imgResponse = await fetch(info.fotoCliente);
        if (!imgResponse.ok) {
          throw new Error("Erro ao carregar imagem do cliente.");
        }

        const contentType = imgResponse.headers.get("content-type");
        const imgBuffer = await imgResponse.arrayBuffer();

        let img;
        if (contentType === "image/png") {
          img = await pdfDoc.embedPng(imgBuffer);
        } else if (
          contentType === "image/jpeg" ||
          contentType === "image/jpg"
        ) {
          img = await pdfDoc.embedJpg(imgBuffer);
        } else {
          throw new Error(
            "Formato de imagem não suportado. Apenas PNG e JPEG são aceitos.",
          );
        }

        // Ajusta o tamanho e posição da imagem na terceira página
        const imgDims = img.scale(0.2); // Escala a imagem em 30%

        // Posicionamento da imagem
        thirdPage.drawImage(img, {
          x: 500, // Ajuste conforme necessário
          y: 520, // Ajuste conforme necessário
          width: imgDims.width,
          height: imgDims.height,
        });
      } catch (error) {
        console.warn("Erro ao processar a foto do cliente:", error.message);
      }
    }

    // Lógica para inserir QR Code, se disponível
    if (info.qrCode) {
      console.log("URL do qrCode:", info.qrCode);
      try {
        const qrResponse = await fetch(info.qrCode);
        if (!qrResponse.ok) {
          throw new Error("Erro ao carregar o QR Code.");
        }

        const qrBuffer = await qrResponse.arrayBuffer();
        const qrImage = await pdfDoc.embedPng(qrBuffer);

        const qrDims = qrImage.scale(0.5); // Escala o QR Code em 30%

        // Posicionamento do QR Code
        thirdPage.drawImage(qrImage, {
          x: 500, // Ajuste conforme necessário
          y: 650, // Ajuste conforme necessário
          width: qrDims.width,
          height: qrDims.height,
        });
      } catch (error) {
        console.warn("Erro ao processar o QR Code:", error.message);
      }
    }
  } else {
    console.warn("Terceira página não encontrada.");
  }
}
