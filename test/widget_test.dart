import 'package:flutter_test/flutter_test.dart';
import 'package:sinatep/custom_code/contrato_validacao.dart';

void main() {
  test('o cadastro normaliza o nome usado na busca', () {
    expect(normalizarBusca('  José   Ávila '), 'jose avila');
    expect(capitalizarNome('josé ávila'), 'Jose Avila');
  });
}
