Sim, as imagens confirmam exatamente o que o suporte disse: o formato deve ser `+55...` (com o 9 extra).

E o log de erro anterior confirmou o que eu suspeitava e corrigi: **"only_one_allowed: email, phone"**.

Isso significa que, embora o formato do número `+55...` que estávamos gerando estivesse correto (o log mostrou `Phone Formatted: +5548988583186`), o erro ocorria porque estávamos enviando **o e-mail E o telefone juntos** no mesmo signatário.

Na imagem do suporte, veja que eles separam:
*   Um bloco tem `phone` e `delivery_method`.
*   Outro bloco tem `email` e `delivery_method`.

Eles **não misturam** `email` e `phone` no mesmo objeto JSON de signatário quando o objetivo é usar o telefone como chave de entrega principal.

**Estado Atual:**
Já realizei a correção no código para enviar **apenas o telefone** (removendo o e-mail do payload) quando a opção de WhatsApp é escolhida.

**Próximo Passo:**
O deploy da correção já foi feito. Peço que teste novamente. Agora deve funcionar, pois estamos respeitando a regra de "um ou outro" e o formato do número já estava correto.