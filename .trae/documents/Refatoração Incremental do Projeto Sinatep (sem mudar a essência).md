## Objetivos
- Melhorar legibilidade, manutenibilidade e desempenho sem alterar fluxos de negócio.
- Padronizar camadas (UI, estado, serviços) e reduzir código morto/duplicado.
- Endurecer segurança (tokens/segredos) e erros previsíveis.

## App Flutter
### Organização e Estado
- Introduzir ViewModels finos por página usando Provider já existente, mantendo FFAppState como estado global leve. Centralizar chamadas ao backend em serviços.
- Separar widgets grandes em componentes reutilizáveis: páginas com 2+ mil linhas (ex.: registrar_contrato) em subwidgets de seção.
- Remover variáveis locais não usadas e trechos “Dead code” apontados pelo analisador.

### Navegação e Internacionalização
- Consolidar rotas no GoRouter existente e remover helpers redundantes. Manter apenas pt-BR e garantir locale carregado via MyApp.

### UI/Performance
- Usar const constructors e const ThemeData onde possível; aplicar CachedNetworkImage para fotos; adicionar Skeletons para carregamentos.
- Debounce em campos de texto e mascaras consistentes.

### Código Alvo
- Ajustes em: [main.dart](file:///c:/Users/Usuario/Downloads/sinatep/sinatep/lib/main.dart), páginas em [pages/contrato](file:///c:/Users/Usuario/Downloads/sinatep/sinatep/lib/pages/contrato/), componentes em [components](file:///c:/Users/Usuario/Downloads/sinatep/sinatep/lib/components/), esquema em [backend/schema](file:///c:/Users/Usuario/Downloads/sinatep/sinatep/lib/backend/schema/).

## Backend Firebase Functions
### Estrutura e Erros
- Padronizar retorno das funções onCall com objetos { success, data, message }. Normalizar uso de HttpsError com códigos adequados.
- Extrair utilitários (ex.: criação de URL de Storage com token) para funções/helpers.

### Segurança
- Remover token hardcoded da Autentique do código; mover para Secret Manager (Functions v2 secrets) ou Config (parametrização) e acessar via processo.
- Validar auth em todas as funções que lidam com contratos e storage.

### Código Alvo
- Refatorar [index.js](file:///c:/Users/Usuario/Downloads/sinatep/sinatep/firebase/functions/index.js) mantendo v2 onCall e v1 para trigger de auth.

## Regras e Configuração
- Revisar regras de Firestore/Storage para garantir que somente usuários autorizados acessam PDFs e dados de contrato (firestore.rules, storage.rules).
- Adicionar analysis_options com flutter_lints já presentes (pubspec usa flutter_lints 4.0.0); fortalecer regras (ex.: prefer_const_constructors, avoid_print).

## Qualidade
- Adicionar testes de serviço simples para validação de montagem de URLs e serialização de dados (unit tests em Dart para serviços; smoke test para funções com emulação local quando possível).

## Validação
- Rodar build local e analisar warnings; validar fluxo de “Disposições Iniciais” e geração/visualização de PDF.
- Garantir que URLs com token funcionam no app sem erro de permissão.

## Entregáveis
- App com páginas menores, componentes reutilizáveis, e estado organizado.
- Backend sem segredos em código, erros consistentes, e utilitários compartilhados.
- Lints aplicados e warnings reduzidos.

Confirma seguir com esta refatoração incremental? Após confirmar, implemento em etapas curtas e verifico cada mudança com deploy/teste.