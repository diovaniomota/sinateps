const { onCall } = require("firebase-functions/v2/https");
const admin = require("firebase-admin");
const { setGlobalOptions } = require("firebase-functions/v2");

if (!admin.apps.length) admin.initializeApp();

setGlobalOptions({
  region: "southamerica-east1",
  memory: "256MiB",
  timeoutSeconds: 120,
  maxInstances: 10,
});

exports.enviarContratoAutentique = onCall(async (request) => {
  const { data, auth } = request;

  if (!auth || !auth.uid) {
    throw new Error("Usuário não autenticado.");
  }

  const { contratoId, emailAluno } = data || {};

  if (!contratoId) {
    throw new Error("contratoId é obrigatório.");
  }
  
  if (!emailAluno) {
    throw new Error("Email do aluno é obrigatório.");
  }

  try {
    const contratoRef = admin.firestore().collection("contrato").doc(contratoId);
    const contratoDoc = await contratoRef.get();

    if (!contratoDoc.exists) {
      throw new Error("Contrato não encontrado.");
    }

    const info = contratoDoc.data();
    const bucket = admin.storage().bucket();
    const pdfStoragePath = `contratos/${contratoId}.pdf`;
    const file = bucket.file(pdfStoragePath);

    const [exists] = await file.exists();
    if (!exists) {
      throw new Error("Arquivo PDF do contrato não encontrado.");
    }

    const [fileBuffer] = await file.download();

    // Autentique API configuration
    const token = "d6f1b4406a7ac821b66eaa48f1cdb28363b1d461fd245e4dfeacb86a328223ab"; // Provided by user. Recommended: process.env.AUTENTIQUE_TOKEN
    const url = "https://api.autentique.com.br/v2/graphql";

    const operations = {
      query: `
        mutation CreateDocument($document: DocumentInput!, $signers: [SignerInput!]!, $file: Upload!) {
          createDocument(document: $document, signers: $signers, file: $file) {
            id
            name
            created_at
            signatures {
              public_id
              name
              email
              action { name }
              link { short_link }
            }
          }
        }
      `,
      variables: {
        document: {
          name: `Contrato - ${info.aluno || "Aluno"}`,
        },
        signers: [
          {
            email: emailAluno,
            action: "SIGN",
            positions: [{ x: "50", y: "80", z: 1 }], // Optional: positioning
          },
        ],
        file: null,
      },
    };

    const map = {
      0: ["variables.file"],
    };

    const formData = new FormData();
    formData.append("operations", JSON.stringify(operations));
    formData.append("map", JSON.stringify(map));
    
    // Create a Blob-like object for the file (Node.js FormData)
    const fileBlob = new Blob([fileBuffer], { type: "application/pdf" });
    formData.append("0", fileBlob, "contrato.pdf");

    const response = await fetch(url, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${token}`,
      },
      body: formData,
    });

    const result = await response.json();

    if (result.errors) {
      console.error("Autentique API Errors:", JSON.stringify(result.errors));
      throw new Error(`Erro na API Autentique: ${result.errors[0].message}`);
    }

    // Update contract with Autentique ID
    await contratoRef.update({
      autentiqueId: result.data.createDocument.id,
      autentiqueStatus: "enviado",
      emailAluno: emailAluno,
    });

    return {
      success: true,
      autentiqueId: result.data.createDocument.id,
    };

  } catch (error) {
    console.error("Erro ao enviar para Autentique:", error);
    throw new Error(`Falha ao enviar contrato: ${error.message}`);
  }
});
