Peço desculpas pela confusão. Eu havia implementado a validação de CPF e Telefone, mas entendi agora que você quer ir além e usar os recursos mais avançados de **verificação de identidade** da Autentique, como **Selfie (Face Match)** e **Documento de Identificação**, não apenas a validação simples de dados.

Para ativar essas verificações específicas na API V2 da Autentique, precisamos adicionar o objeto `verifications` dentro do `SignerInput`.

**Recursos disponíveis para ativar:**
1.  **Validação de CPF (`cpf`)**: Já estávamos enviando `ignore_cpf: false`, mas agora vamos garantir que o CPF seja validado contra a base da Receita Federal se possível (depende do plano, mas a configuração padrão é exigir o CPF).
2.  **Verificação de Identidade (`identity_verification`)**: É aqui que solicitamos a **Selfie** (Face Match) e/ou **Documento** (RG/CNH).

**Plano de Implementação:**

1.  **Backend (`firebase/functions/index.js`)**:
    *   Modificar a estrutura do `SignerInput` para incluir o campo `verifications`.
    *   Configurar `verifications` para exigir:
        *   `evidence: ["SELFIE", "DOCUMENT"]` (Para exigir foto do rosto e do documento).
        *   Manter a exigência do CPF.

**Observação Importante:**
Esses recursos de validação avançada (Selfie/Documento) geralmente consomem créditos específicos ou exigem um plano pago da Autentique. Se a conta não tiver esses recursos habilitados, a API poderá retornar erro. Vou configurar o código para solicitar essas validações.

**Ação:**
Vou editar o `index.js` para incluir o bloco de `verifications` na mutation `createDocument`.