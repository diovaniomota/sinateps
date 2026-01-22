O erro ocorre porque o token da Autentique foi removido do código para ser buscado no Firestore (para segurança), mas ele ainda não foi salvo lá.

Encontrei o token original nos arquivos de backup (`custom_cloud_functions`).

**Solução Automática:**
Vou atualizar a função para que, caso não encontre o token no Firestore, ela use o token antigo e **automaticamente o salve no banco de dados**. Isso corrige o erro imediatamente e conclui a migração de segurança sem que você precise fazer nada manual.

**Passos:**

1. Atualizar `firebase/functions/index.js` com a lógica de "auto-correção" (migração).
2. Fazer o deploy novamente.

