Entendi perfeitamente com a explicação do suporte.

O suporte explicou que:
1.  **Assinatura Qualificada (`qualified: true`)**: É quando o signatário usa o **próprio** certificado digital (e-CPF/e-CNPJ) dele para assinar. Isso é obrigatório apenas em casos específicos (imóveis, notas fiscais, atos de poder).
2.  **Arquivo Certificado (PAdES)**: É apenas o arquivo final "selado" com o certificado da Autentique. Eles **não recomendam** usar esse arquivo a não ser que seja exigido, pois pode corromper em alguns leitores.
3.  **O Recomendado**: Usar assinatura normal (`qualified: false`, que já revertemos) e baixar o **"PDF assinado"** (com marcações e página de auditoria), que é o padrão aceito juridicamente para contratos comuns.

**Sobre a sua dúvida final na imagem ("não tem como essa opção já baixar o documento qualificado?"):**
O suporte esclareceu que se você criar como qualificado (`qualified: true`), o usuário terá que ter um certificado digital. Se criar como normal (`qualified: false`), ele assina eletronicamente e o arquivo final gerado será o "PDF assinado".

O seu app já está configurado corretamente agora (`qualified: false`), o que gera o **"PDF assinado"** que é o padrão seguro e compatível. O link que salvamos no banco de dados (`signedUrl`) ou o link enviado pela Autentique por e-mail/WhatsApp leva para a página onde o usuário baixa esse PDF final assinado.

Não precisamos fazer nenhuma alteração adicional no código, pois já revertemos para `false`, que é o modo correto para o seu caso de uso (contratos de curso). O "PAdES" (arquivo certificado) é um formato técnico específico que geralmente não é necessário para o usuário final.

**Resumo:** O sistema está configurado da maneira ideal. O aluno assina, e o documento final gerado é o PDF com validade jurídica (com log de auditoria), sem exigir certificado digital do aluno (o que inviabilizaria a assinatura para muitos).