Se não chegou no WhatsApp, mas não deu erro no app, significa que a **primeira tentativa falhou** (provavelmente a Autentique rejeitou o formato ou a conta não tem créditos/permissão de WhatsApp) e o sistema ativou o **fallback para e-mail** com sucesso.

Para que funcione no WhatsApp, precisamos garantir que o formato do número esteja **exatamente** como a API espera. A documentação da Autentique exige o formato internacional sem formatação visual (ex: `+5511999999999`).

Vou revisar a lógica de formatação do telefone e adicionar um log para que possamos ver o que está acontecendo nas próximas tentativas.

**Ação:**
1.  Revisar a formatação do telefone em `firebase/functions/index.js` para garantir compatibilidade total (remover espaços, traços, parênteses e garantir o `+55`).
2.  Verificar se o parâmetro `delivery_method` está correto (`DELIVERY_METHOD_WHATSAPP`).

Se a conta da Autentique for do plano gratuito (Free), o envio por WhatsApp **não é permitido**. Nesse caso, a API rejeita e o meu fallback envia por e-mail. Se for este o caso, não há o que fazer via código, pois é uma limitação do plano.

Vou ajustar a formatação para ser o mais permissiva possível.