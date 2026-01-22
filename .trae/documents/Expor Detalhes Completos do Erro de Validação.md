O console do navegador (Flutter Web) não mostra os logs do **Backend (Cloud Functions)**, apenas os erros que chegam no Frontend. O erro "validation" vem do servidor da Autentique para o nosso servidor (Node.js) e depois para o app.

No entanto, eu posso ver os logs do **servidor** (Cloud Functions) aqui mesmo pelo terminal, se eu consultar os logs do Firebase após a sua tentativa.

**Melhor abordagem agora:**
Vou consultar os logs da Cloud Function `enviarContratoAutentique` usando o comando `firebase functions:log`. Como adicionei logs detalhados (`console.log`) na última versão, o payload exato e o erro completo devem estar lá.

**Plano:**
1. Executar o comando para ler os logs das funções.
2. Analisar a saída para encontrar o erro detalhado da última tentativa (15:45).
3. Corrigir o problema com base na informação real.

Vou buscar os logs agora.