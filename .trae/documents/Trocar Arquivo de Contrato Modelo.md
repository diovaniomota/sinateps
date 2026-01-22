Perfeito! O novo arquivo chama-se **"Contrato 2026.pdf"**.

Vou atualizar o código para que o sistema passe a usar este novo arquivo em vez do antigo ("contrato novo 2024.pdf").

**Importante:** Se o layout (posições dos campos) mudou, os dados podem aparecer desalinhados. Vamos atualizar o nome primeiro e, se necessário, ajustamos as posições depois.

**Plano:**
1.  Editar `firebase/functions/index.js` para atualizar a constante `PDF_MODELO_NOME` para `"Contrato 2026.pdf"`.
2.  Fazer o deploy da função.