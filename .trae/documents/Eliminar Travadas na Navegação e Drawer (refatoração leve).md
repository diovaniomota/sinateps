## Causas prováveis
- Rebuilds desnecessários e setState pós-frame no Drawer.
- Renderização custosa por estilos repetidos com GoogleFonts em tempo de build.
- Streams no Drawer causando re-render do layout inteiro.
- Páginas muito grandes reconstruindo completas ao navegar.

## Refatorações leves (sem mudar essência)
### Drawer
1. Remover o `addPostFrameCallback(() => safeSetState(() {}))` para evitar rebuild imediato após o primeiro frame.
2. Reduzir reconstruções com `const` nos widgets estáticos e adicionar `RepaintBoundary` ao conteúdo do Drawer.
3. Substituir `AuthUserStreamWidget` por leitura memoizada do flag `isAdmin` (ou por `Selector` do Provider) para não reconstruir toda a árvore ao mudar auth.
4. Centralizar tipografia no `FlutterFlowTheme` e evitar `GoogleFonts.readexPro.override` em cada `Text`.
- Arquivo alvo: [drawer_widget.dart](file:///c:/Users/Usuario/Downloads/sinatep/sinatep/lib/components/drawer/drawer_widget.dart)

### Navegação
5. Unificar padrão: fechar Drawer rápido e navegar com `context.goNamed` (GoRouter) para evitar duas transições encadeadas (pop + push) quando apropriado.
- Arquivos: páginas em [pages](file:///c:/Users/Usuario/Downloads/sinatep/sinatep/lib/pages)

### Páginas grandes
6. Quebrar seções de páginas extensas (ex.: registrar_contrato_page_widget.dart ~4000+ linhas) em subwidgets Stateless com `const`, isolando repaints com `RepaintBoundary` nas seções de formulário.
- Arquivo: [registrar_contrato_page_widget.dart](file:///c:/Users/Usuario/Downloads/sinatep/sinatep/lib/pages/contrato/registrar_contrato_page/registrar_contrato_page_widget.dart)

### Micro-otimizações
7. Aplicar `const` em ThemeData, paddings, SizedBox, Icones; remover variáveis locais não usadas (já iniciamos isso) para reduzir trabalho do compilador JIT.
8. Onde houver imagens remotas, garantir `CachedNetworkImage` com placeholders leves.

## Validação
- Medir o tempo de abertura do Drawer e troca entre páginas antes/depois.
- Observar jank no timeline (Flutter Performance) e queda no número de frames perdidos.

## Entregáveis
- Drawer sem rebuild pós-frame e com repaints isolados.
- Navegação mais fluida (menos reconstruções e transições encadeadas).
- Páginas grandes com subwidgets e uso extensivo de `const`.

Posso aplicar essas melhorias agora e mostrar os diffs; seguimos?