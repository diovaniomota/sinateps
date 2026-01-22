O "aceite de termo" na Autentique corresponde à **Assinatura Eletrônica** (padrão), em contraste com a **Assinatura Qualificada** (que exige certificado digital ICP-Brasil).

Analisei seu código atual em `firebase/functions/index.js` e notei que você está enviando `"qualified": true`. Isso força o uso de certificado digital, o que torna o processo mais rígido e complexo (o oposto de um simples "aceite").

Para configurar como "aceitação de termo" (apenas clicar para assinar/aceitar), precisamos fazer dois ajustes:
1.  Mudar `qualified` para `false` (ou remover, pois o padrão é false).
2.  Adicionar `configs` com `signature_appearance: "ELETRONIC"` para garantir que seja apenas um clique (sem exigir desenho de assinatura).

**Plano de Alteração:**

1.  **Arquivo**: `firebase/functions/index.js`
2.  **Ação**:
    *   Alterar `qualified: true` para `qualified: false` dentro da mutation `createDocument`.
    *   Adicionar o objeto `configs` definindo `signature_appearance: "ELETRONIC"`.

Isso simplificará o fluxo para o usuário final, permitindo que ele apenas visualize e clique em "Assinar" (Aceitar), que é o comportamento desejado.