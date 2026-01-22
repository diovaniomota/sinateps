Entendido. Vou reverter a configuração para assinatura simples (`qualified: false`), como estava anteriormente.

Isso é útil quando não se deseja exigir validações avançadas (como certificado ICP-Brasil) do signatário, tornando o processo mais simples e rápido.

**Ação:**

1. Editar `firebase/functions/index.js` para retornar `qualified: false`.
2. Fazer o deploy da função.

