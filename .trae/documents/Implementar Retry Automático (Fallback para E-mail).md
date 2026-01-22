O erro "Erro na API Autentique: validation" persiste. Isso significa que, mesmo com as alterações, algo no payload enviado para a Autentique está sendo rejeitado.

Como o erro é genérico ("validation"), preciso de mais detalhes para corrigi-lo definitivamente. No entanto, a causa mais provável é o **número de telefone**. A Autentique é extremamente rigorosa com formatos de telefone e com a permissão para usar WhatsApp.

**Plano de Depuração e Correção Robusta:**

1.  **Melhorar Logs de Erro**: Vou alterar o código para retornar **exatamente** qual campo falhou na validação (ex: "telefone inválido", "email inválido"). Isso é crucial.
2.  **Fallback Automático (Tentativa sem WhatsApp)**: Vou implementar uma lógica de "tentativa e erro" no backend:
    *   **Tentativa 1**: Enviar com E-mail e WhatsApp.
    *   **Se falhar**: Capturar o erro e tentar enviar **automaticamente** apenas para o E-mail.
    *   Isso garantirá que o usuário não fique bloqueado e o contrato seja enviado, mesmo que o WhatsApp falhe.

**Alterações no `firebase/functions/index.js`:**
*   Envolver a chamada `fetch` da Autentique em um bloco `try...catch` mais inteligente.
*   Se a primeira chamada falhar, verificar se foi erro de validação e tentar novamente removendo o campo `phone` e `delivery_method`.

Vou aplicar essa lógica agora. É a forma mais segura de resolver sem precisar de "tentativa e erro" manual.