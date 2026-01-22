const functions = require("firebase-functions");
const admin = require("firebase-admin");
// To avoid deployment errors, do not call admin.initializeApp() in your code

exports.deletarPDF = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    if (!context.auth.uid) return;

    const { contratoId } = data;

    try {
      const bucket = admin.storage().bucket();

      const pdfContrato = bucket.file(`contratos/${contratoId}.pdf`);

      const [exists] = await pdfContrato.exists();

      if (!exists) {
        throw new functions.https.HttpsError(
          "not-found",
          "Arquivo não existe.",
        );
      }

      // Se o arquivo existir, deleta o PDF
      await pdfContrato.delete();
    } catch (error) {
      // Se ocorrer um erro, retorne um erro HTTP interno
      console.warn("Stack", error.stack);
      throw new functions.https.HttpsError("internal", error.message);
    }
  });
