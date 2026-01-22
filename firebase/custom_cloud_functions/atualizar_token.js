const functions = require("firebase-functions");
const admin = require("firebase-admin");

// To avoid deployment errors, do not call admin.initializeApp() in your code

exports.atualizarToken = functions
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

      const [signedUrl] = await pdfContrato.getSignedUrl({
        action: "read",

        expires: new Date("01-01-2500"),
      });

      await contratoRef.update({ signedUrl });

      return signedUrl;
    } catch (error) {
      // Se ocorrer um erro, retorne um erro HTTP interno

      console.warn("Stack", error.stack);

      throw new functions.https.HttpsError("internal", error.message);
    }
  });
