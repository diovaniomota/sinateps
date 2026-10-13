const { HttpsError } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");

async function exigirUsuario(auth) {
  if (!auth || !auth.uid) {
    throw new HttpsError("unauthenticated", "Usuário não autenticado.");
  }
  return auth.uid;
}

async function usuarioEhAdmin(uid, token) {
  if (token && token.admin === true) return true;
  const userDoc = await admin.firestore().collection("user").doc(uid).get();
  return userDoc.exists && userDoc.data().isAdmin === true;
}

async function exigirAdmin(auth) {
  const uid = await exigirUsuario(auth);
  if (await usuarioEhAdmin(uid, auth.token)) return uid;
  throw new HttpsError(
    "permission-denied",
    "Apenas um administrador pode fazer isso.",
  );
}

async function exigirAcessoContrato(auth, contratoDoc) {
  const uid = await exigirUsuario(auth);
  if (!contratoDoc.exists) {
    throw new HttpsError("not-found", "Contrato não encontrado.");
  }
  if (await usuarioEhAdmin(uid, auth.token)) return uid;

  const criador = contratoDoc.data().criador;
  const criadorId = criador && criador.id ? criador.id : null;
  if (criadorId !== uid) {
    throw new HttpsError("permission-denied", "Sem permissão para este contrato.");
  }
  return uid;
}

async function tokenAutentique() {
  const doAmbiente = process.env.AUTENTIQUE_TOKEN;
  if (doAmbiente && String(doAmbiente).trim()) {
    return String(doAmbiente).trim();
  }

  const doc = await admin.firestore().doc("config/autentique").get();
  const token = doc.exists ? doc.data().token : null;
  if (token && String(token).trim()) {
    return String(token).trim();
  }

  throw new HttpsError(
    "failed-precondition",
    "Token da Autentique ausente. Defina AUTENTIQUE_TOKEN ou o documento config/autentique.",
  );
}

function falhaInterna(error, mensagem) {
  console.error(mensagem, error);
  if (error instanceof HttpsError) throw error;
  throw new HttpsError("internal", mensagem);
}

module.exports = {
  exigirUsuario,
  exigirAdmin,
  exigirAcessoContrato,
  tokenAutentique,
  falhaInterna,
};
