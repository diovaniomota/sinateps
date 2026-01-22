Vou aprimorar a segurança do processo de assinatura conforme solicitado:

1.  **Exigir CPF**: Adicionarei `ignore_cpf: false` nas configurações do documento. Isso obrigará o signatário a informar o CPF para assinar.
2.  **Validação por Celular**: Incluirei o número de telefone do aluno (`info.telefones`) no objeto do signatário e definirei o método de entrega como WhatsApp (`DELIVERY_METHOD_WHATSAPP`), que é o padrão mais usado. Isso adiciona uma camada de verificação extra além do e-mail.
3.  **Biometria/Selfie**: A API pública da Autentique não expõe um campo direto "exigir selfie" na criação simples do documento via GraphQL sem um plano Enterprise específico ou configuração de conta. No entanto, ao "não ignorar" o CPF e usar a validação por telefone, já elevamos o nível de segurança. Manterei o foco nas validações de CPF e Telefone que são garantidas pela API.

**Ações no código (`firebase/functions/index.js`):**
*   Sanitizar o telefone do aluno para o formato internacional (+55...).
*   Adicionar `phone` e `delivery_method` ao `SignerInput`.
*   Atualizar `configs` para `{ ignore_cpf: false, signature_appearance: "ELETRONIC" }`.

**Nota:** A validação biométrica (Selfie) geralmente é configurada diretamente no painel da Autentique como uma regra da conta ou exige um endpoint específico de "Identidade" que varia conforme o plano contratado. Implementarei o que está disponível na integração padrão.