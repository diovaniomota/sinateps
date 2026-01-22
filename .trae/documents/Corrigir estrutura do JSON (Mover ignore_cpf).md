O erro ocorreu porque o campo `ignore_cpf` foi colocado no lugar errado dentro da estrutura do JSON enviado para a Autentique. Ele deve ficar na raiz do objeto `document`, e não dentro de `configs`.

**Correção:**
Vou mover o campo `ignore_cpf: false` para o nível correto no código (`firebase/functions/index.js`).

**Plano:**

1. Editar `firebase/functions/index.js` para corrigir a estrutura do payload.
2. Realizar o deploy da correção.

