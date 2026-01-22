O erro indica que o campo `verifications` não existe no tipo `SignerInput` da API GraphQL da Autentique que estamos usando. Isso acontece porque a Autentique tem versões diferentes da API e a estrutura para solicitar verificações mudou ou não está disponível dessa forma no endpoint atual.

Para resolver, preciso verificar a documentação correta ou ajustar a estrutura. Na API v2 padrão, as verificações geralmente são configuradas de outra forma ou exigem uma mutation diferente.

No entanto, para não bloquear o seu uso agora, a ação mais rápida é **reverter a tentativa de exigir Selfie/Documento via código** (já que a API rejeitou) e manter apenas a validação de CPF e WhatsApp que já estavam funcionando.

Se você realmente precisa da Selfie/Documento, isso geralmente é configurado **dentro do painel da Autentique** (em Configurações da Conta ou Modelo de Documento) para ser aplicado automaticamente a todos os signatários, ou requer o uso de uma mutation específica de "Identidade".

**Plano de Ação Imediata (Correção do Erro):**
1.  Remover o campo `verifications` do código `firebase/functions/index.js` para que o envio volte a funcionar (com CPF e WhatsApp).
2.  Manter o fallback de segurança (E-mail) ativo.

Vou fazer essa reversão para destravar o envio. Se quiser investigar a Selfie depois, podemos fazer com mais calma consultando o suporte da API deles.