Entendido. Vou adicionar o campo de WhatsApp na tela onde já se digita o e-mail do destinatário.

**Plano de Implementação Completa (Frontend + Backend):**

1.  **Frontend (Flutter)**:
    *   **Arquivo**: Identificar a página correta. Pelo log de erro anterior, a tela é `ver_contrato_page_widget.dart` (onde está o botão de enviar), e não `registrar_contrato`. Vou confirmar isso.
    *   **Ação**: Adicionar um `TextFormField` para o WhatsApp abaixo do campo de E-mail.
    *   **Lógica**: Capturar o valor digitado e passá-lo como parâmetro (`whatsappAluno`) na chamada da Cloud Function `enviarContratoAutentique`.

2.  **Backend (Cloud Function)**:
    *   **Arquivo**: `firebase/functions/index.js`.
    *   **Ação**: Atualizar a função `enviarContratoAutentique` para aceitar o novo parâmetro `whatsappAluno`.
    *   **Lógica**: Se o `whatsappAluno` for fornecido, usá-lo para configurar o envio via WhatsApp (com formatação +55). Se não, enviar apenas por e-mail.

3.  **Deploy**:
    *   Deploy da Cloud Function atualizada.
    *   Gerar novo APK com a tela atualizada.

Vou começar localizando o arquivo correto da tela de "Ver Contrato/Enviar".