const functions = require("firebase-functions");

const admin = require("firebase-admin");

// To avoid deployment errors, do not call admin.initializeApp() in your code

exports.gerenciarUsuario = functions
  .region("southamerica-east1")
  .https.onCall(async (data, context) => {
    // Verifica a autenticação do contexto; se o usuário não estiver autenticado, retorna

    if (!context.auth.uid) return;

    // Obtém informações do usuário (UID, nome, e-mail, senha) dos dados enviados

    const { uid, displayName, email, password } = data;

    try {
      // Se o UID já existir (ou seja, o usuário já existe), atualize suas informações

      if (uid !== null) {
        // Crie um objeto para atualizar as informações no Firebase Authentication

        const updateUserObject = {};

        // Se um novo e-mail for fornecido, atualize o e-mail

        if (email) updateUserObject.email = email;

        // Se uma nova senha for fornecida, atualize a senha

        if (password) updateUserObject.password = password;

        // Atualize as informações do usuário no Firebase Authentication

        await admin.auth().updateUser(uid, updateUserObject);

        // Crie um objeto para atualizar o documento do usuário no Firestore

        const userDocUpdate = {};

        // Se um novo nome for fornecido, atualize o nome no Firestore

        if (displayName) userDocUpdate.display_name = displayName;

        // Se um novo e-mail for fornecido, atualize o e-mail no Firestore

        if (email) userDocUpdate.email = email;

        // Obtém uma referência ao documento do usuário no Firestore

        const userRef = admin.firestore().collection("user").doc(uid);

        // Atualize o documento do usuário no Firestore com as informações atualizadas

        await userRef.update(userDocUpdate);
      } else {
        // Se o UID não existir (ou seja, o usuário não existe), crie um novo usuário

        const user = await admin.auth().createUser({ email, password });

        // Crie um documento para o usuário no Firestore com as informações do novo usuário

        const userDoc = {
          uid: user.uid,

          email: user.email,

          display_name: displayName,

          created_time: admin.firestore.FieldValue.serverTimestamp(),
        };

        // Obtém uma referência ao documento do usuário no Firestore

        const userRef = admin.firestore().collection("user").doc(user.uid);

        // Defina o documento do usuário no Firestore

        await userRef.set(userDoc);
      }
    } catch (error) {
      // Se ocorrer um erro, retorne um erro HTTP interno

      console.warn("Stack", error.stack);

      throw new functions.https.HttpsError("internal", error.message);
    }
  });
