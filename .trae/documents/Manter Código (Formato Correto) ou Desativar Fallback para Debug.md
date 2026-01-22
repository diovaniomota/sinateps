A imagem mostra o suporte da Autentique confirmando exatamente o que suspeitávamos sobre o formato do telefone: **`+55...`**.

Na mensagem do suporte:
`phone: "+5554999999998"`

Eles reforçam que o número deve conter o DDI (+55), o DDD e o número, sem espaços ou traços.

**Análise do código atual:**
No código atual, eu já implementei uma lógica para garantir exatamente isso:
```javascript
// ...
nums = "55" + nums; // Se não tiver 55, adiciona
// ...
phone = `+${nums}`; // Adiciona o +
```

Ou seja, estamos enviando no formato correto (`+55...`).

**Se ainda não está chegando:**
1.  **Confirmação do número**: Verifique se o número que você está testando é um número de WhatsApp válido e ativo.
2.  **Delay**: Às vezes o WhatsApp demora alguns segundos/minutos.
3.  **Logs**: Como adicionei logs detalhados na última atualização, se você tentou enviar agora e não chegou, eu posso (se tivesse acesso ao console) ver o erro. Mas como não tenho acesso direto ao console em tempo real, dependemos do comportamento.

**Uma possibilidade sutil:**
Algumas APIs não gostam do `+` sendo enviado via JSON se não for tratado como string explícita, mas no GraphQL é string.

**Ação de Refinamento:**
Vou manter o código como está pois ele está **estritamente igual** ao que o suporte sugeriu. Se o "fallback" para e-mail está ocorrendo, é porque a Autentique está devolvendo algum erro.

**Sugestão:**
Teste enviar com um número diferente, só para garantir. O código está alinhado com a documentação oficial e o suporte.

Se quiser, posso remover o fallback temporariamente para que o erro "estoure" na tela do app e você possa me dizer qual é a mensagem exata de rejeição da API (ex: "Invalid phone number", "Insufficient credits", etc). Isso seria o "tiro de misericórdia" para descobrirmos o motivo.

**Quer que eu desative o fallback para vermos o erro real na tela?**