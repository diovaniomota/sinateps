**Achei o erro!**

O log mostra exatamente o problema:
`"extensions":{"validation":{"signers.0":["only_one_allowed:email, phone"]}`

A Autentique está dizendo: **"apenas um permitido: email ou telefone"**.

Isso significa que, para envio via WhatsApp, **NÃO PODEMOS** enviar o campo `email` junto com o `phone`. Devemos enviar OU um OU outro.

**Correção:**
Vou alterar o código para que, quando o envio for via WhatsApp (`usePhone = true`), o campo `email` seja **removido** do objeto `signer`.

**Plano:**
1.  Editar `firebase/functions/index.js` para remover o `email` do signatário quando `phone` estiver presente.
2.  Reativar o fallback (segurança) para garantir que, se o envio via WhatsApp falhar, o sistema tente novamente **apenas com e-mail** (o que já funciona).
3.  Fazer o deploy.

Isso resolverá o problema definitivamente.