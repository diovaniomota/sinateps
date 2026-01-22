## Problemas
- Linha 4179: cadeia de extensões inválida na lista de children causa “Expected to find ')'”.
- Linha 3771: chamada que o analisador interpreta como argumentos posicionais extras.

## Correções propostas
1. Substituir a cadeia `.divide(...).addToStart(...).addToEnd(...)` por `.divide(...).around(...)` na linha 4179, que é o utilitário correto e fecha a expressão adequadamente.
2. Garantir que o aviso de carregamento seja um único Widget:
   - Manter um método privado `_carregandoAviso()` que retorna o Widget condicional e chamá-lo como child na linha 3771 (sem lista inline nem variações que confundem o parser).
3. Rodar o formatador/analisador para confirmar que não restam erros de sintaxe e que os parênteses estão balanceados.

## Limpeza (não bloqueante, após sintaxe ok)
- Remover @override inválido e campos não usados em firebase_auth_manager.dart.
- Ajustar retorno do onError em backend.dart.
- Remover símbolos não referenciados em api_calls.dart.
- Remover default coberto em serialization_util.dart.
- Eliminar pequenos trechos de dead code nas páginas indicadas.

## Validação
- Executar `flutter analyze` e garantir zero erros.
- Abrir a tela de Registro de Contrato para verificar que renderiza e navega sem travadas.

Posso aplicar essas duas correções sintáticas agora e, em seguida, limpar os avisos?