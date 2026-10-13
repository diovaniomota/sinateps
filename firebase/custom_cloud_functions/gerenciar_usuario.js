const functions = require("firebase-functions");
const admin = require("firebase-admin");

exports.gerenciarUsuario = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    if (!context.auth || !context.auth.uid) {
      throw new functions.https.HttpsError(
        "unauthenticated",
        "Usuário não autenticado.",
      );
    }

    const actor = await admin.firestore().collection("user").doc(context.auth.uid).get();
    const adminClaim = context.auth.token && context.auth.token.admin === true;
    if (!adminClaim && !(actor.exists && actor.data().isAdmin === true)) {
      throw new functions.https.HttpsError(
        "permission-denied",
        "Apenas um administrador pode fazer isso.",
      );
    }

    const { uid, displayName, email, password } = data || {};
    const emailLimpo = email ? String(email).trim() : "";
    const senha = password ? String(password) : "";

    if (emailLimpo && !/^[\w.-]+@([\w-]+\.)+[\w-]{2,}$/.test(emailLimpo)) {
      throw new functions.https.HttpsError("invalid-argument", "E-mail inválido.");
    }
    if (senha && senha.length < 8) {
      throw new functions.https.HttpsError(
        "invalid-argument",
        "A senha precisa ter pelo menos 8 caracteres.",
      );
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
        return { success: true };
      }

      if (!emailLimpo || !senha) {
        throw new functions.https.HttpsError(
          "invalid-argument",
          "E-mail e senha são obrigatórios.",
        );
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
      return { success: true, uid: user.uid };
    } catch (error) {
      if (error instanceof functions.https.HttpsError) throw error;
      console.error("Falha ao gerenciar usuário", error);
      throw new functions.https.HttpsError(
        "internal",
        "Falha ao gerenciar o usuário.",
      );
    }
  });
