## Diagnóstico
- O erro “Permission 'iam.serviceAccounts.signBlob' denied” surge quando o código gera URLs assinadas (getSignedUrl) no Cloud Storage. Em execuções com credenciais de serviço sem chave privada, a biblioteca usa a API IAM `signBlob`, que exige a permissão/role adequada.
- Como migramos as funções HTTPS para 2ª Geração (Node 22), o runtime usa uma Service Account gerenciada. Sem a role `roles/iam.serviceAccountTokenCreator` sobre essa própria SA, a chamada `getSignedUrl` falha.

## Estratégia Recomendada (evita IAM)
- Substituir URLs assinadas do GCS por URLs de Firebase Storage baseadas em token (`firebaseStorageDownloadTokens`).
- Essas URLs não usam `signBlob`, funcionam bem em Functions v2, e são simples para o app consumir.

## Alterações no Código
- Arquivo: [index.js](file:///c:/Users/Usuario/Downloads/sinatep/sinatep/firebase/functions/index.js)

### criarPDF
1. Ao salvar o PDF, gerar um token com `crypto.randomUUID()`.
2. Incluir `metadata: { metadata: { firebaseStorageDownloadTokens: token }, contentType: 'application/pdf' }` no `file.save`.
3. Montar a URL pública: `https://firebasestorage.googleapis.com/v0/b/${bucket.name}/o/${encodeURIComponent(path)}?alt=media&token=${token}`.
4. Salvar essa URL em Firestore (ex.: `signedUrl` ou `urlPdf`).

### atualizarToken
1. Remover o uso de `getSignedUrl`.
2. Ler metadados do arquivo; se não houver `firebaseStorageDownloadTokens`, gerar um novo token e atualizar via `file.setMetadata({ metadata: { firebaseStorageDownloadTokens: token } })`.
3. Retornar/mantêr a mesma URL no formato Firebase Storage com token.

## Alternativa com IAM (se preferir manter Signed URL)
- Identificar a Service Account em uso pelas Functions (Cloud Run service da função) e conceder:
  - `roles/iam.serviceAccountTokenCreator` à própria SA no recurso `projects/-/serviceAccounts/SA_EMAIL`.
- Passos práticos: Console do GCP → IAM → localizar a SA (geralmente `PROJECT_ID@appspot.gserviceaccount.com` ou `PROJECT_NUMBER-compute@developer.gserviceaccount.com`) → Conceder a role acima.
- Após conceder, `getSignedUrl` volta a funcionar.

## Validação
- Deploy das funções.
- Fluxo do app: gerar contrato em “Disposições Iniciais” e verificar que a mensagem de erro desaparece e a visualização/baixa do PDF funciona.
- Conferir no Firestore que o campo de URL foi atualizado para o formato Firebase Storage com token.

## Observações
- O formato Firebase Storage com token é estável e não expira, a menos que você remova/altere o token.
- Caso queira expiração, mantenha Signed URL e aplique a correção de IAM.
- O app Flutter não precisa de ajustes; apenas consome a nova URL retornada pela função.