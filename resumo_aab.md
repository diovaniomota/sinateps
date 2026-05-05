# Resumo da Exportação (AAB para Google Play)

## O que foi implementado
Foi configurada a assinatura de release do aplicativo e gerado o pacote Android App Bundle (.aab) necessário para publicação na Google Play Store.

## Arquivos modificados/criados
- **[MODIFICADO]** `android/app/build.gradle` - Alterado para utilizar a configuração de release (`signingConfigs.release`).
- **[CRIADO]** `android/key.properties` - Arquivo de configuração contendo senhas e informações da chave de assinatura.
- **[CRIADO]** `android/app/upload-keystore.jks` - Certificado interno usado para assinar o AAB enviado para a loja.
- **[CRIADO]** `build/app/outputs/bundle/release/app-release.aab` - Arquivo final gerado, compilado e assinado.

## Como funciona
O sistema de build do Android agora lê as propriedades do `key.properties` e utiliza o `upload-keystore.jks` para assinar o aplicativo quando é gerado em modo `release` ou quando é utilizado o comando `flutter build appbundle`.

## Dependências adicionadas
Nenhuma dependência externa adicionada. Apenas comandos nativos do Keytool e do Flutter.

## Instruções de uso/upload
1. O arquivo pronto para upload na Google Play Store localiza-se em:
   `/home/diovaniomota/Área de trabalho/sinateps/build/app/outputs/bundle/release/app-release.aab`
2. Não perca ou exclua os arquivos `key.properties` e `upload-keystore.jks`, pois eles serão necessários para futuras atualizações do app na loja.
3. Para publicar, basta acessar o console da Google Play, ir em produção ou faixa de testes (interna/fechada) e importar o arquivo `.aab`.
