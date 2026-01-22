Entendido. Vou ativar a assinatura qualificada (`qualified: true`) no payload da Autentique.

A assinatura qualificada geralmente exige certificado digital (ICP-Brasil) ou validações mais rigorosas, dependendo da configuração da conta na Autentique. Como você solicitou, farei a alteração.

**Ação:**
1.  Editar `firebase/functions/index.js` para alterar `qualified: false` para `qualified: true`.
2.  Fazer o deploy da função atualizada.

Isso elevará o nível de validade jurídica da assinatura solicitada.