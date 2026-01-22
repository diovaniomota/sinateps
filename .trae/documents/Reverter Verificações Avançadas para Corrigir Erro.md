Vou reverter a inclusão do campo `verifications` porque a API da Autentique retornou erro dizendo que esse campo não existe no `SignerInput`.

Embora a funcionalidade de Selfie/Documento exista no painel da Autentique, a forma de solicitá-la via API (GraphQL V2) parece ser diferente ou restrita a configurações de conta/modelo, e não um campo direto na criação simples do documento.

**Ações:**
1.  Remover o bloco `verifications` do código para que o envio volte a funcionar imediatamente.
2.  Manter a validação de CPF (`ignore_cpf: false`) e a validação de posse do telefone via WhatsApp (`DELIVERY_METHOD_WHATSAPP`), que já atendem a maior parte dos requisitos de segurança solicitados e funcionam na API atual.

Assim, o sistema volta a operar sem erros e com a segurança reforçada que já implementamos.