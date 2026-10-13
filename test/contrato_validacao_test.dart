import 'package:flutter_test/flutter_test.dart';
import 'package:sinatep/custom_code/contrato_consulta.dart';
import 'package:sinatep/custom_code/contrato_validacao.dart';

void main() {
  test('aceita CPF válido e rejeita sequência repetida', () {
    expect(cpfValido('529.982.247-25'), isTrue);
    expect(cpfValido('111.111.111-11'), isFalse);
    expect(cpfValido('123'), isFalse);
  });

  test('telefone exige DDD e e-mail vazio passa', () {
    expect(telefoneValido('+55 (47) 9 9999-0000'), isTrue);
    expect(telefoneValido('9999'), isFalse);
    expect(emailOpcionalValido(''), isTrue);
    expect(emailOpcionalValido('aluno@sinatep.com'), isTrue);
    expect(emailOpcionalValido('sem-arroba'), isFalse);
  });

  test('etapa do contratante aponta o primeiro erro', () {
    expect(
      erroContratante(
        contratante: '',
        documento: '',
        telefones: '',
        email: '',
      ),
      isNull,
    );
    expect(
      erroContratante(
        contratante: 'Maria',
        documento: '123',
        telefones: '9999',
        email: 'sem-arroba',
      ),
      isNull,
    );
    expect(erroAluno(''), isNull);
  });

  test('busca por CPF, número e nome monta consultas diferentes', () {
    final cpf = montarConsulta(
      admin: false,
      filtro: 'todos',
      termo: '52998224725',
      cidade: 'Blumenau',
    );
    expect(cpf.igualdades.single.campo, 'documento');
    expect(cpf.igualdades.single.valor, '529.982.247-25');
    expect(cpf.restringeCriador, isTrue);
    expect(cpf.filtrarCidadeLocal, isTrue);

    final numero = montarConsulta(
      admin: true,
      filtro: 'assinados',
      termo: '42',
      cidade: '',
    );
    expect(numero.igualdades.single.campo, 'numero_doc');
    expect(numero.igualdades.single.valor, 42);
    expect(numero.restringeCriador, isFalse);

    final nome = montarConsulta(
      admin: true,
      filtro: 'pendentes',
      termo: 'maria silva',
      cidade: '',
    );
    expect(nome.prefixoCampo, 'contratante');
    expect(nome.prefixo, 'Maria Silva');
    expect(nome.filtroLocal, FiltroContrato.pendentes);

    final acentuado = montarConsulta(
      admin: false,
      filtro: 'todos',
      termo: 'josé ávila',
      cidade: '',
    );
    expect(acentuado.prefixo, 'José Ávila');

    final cidade = montarConsulta(
      admin: true,
      filtro: 'todos',
      termo: '',
      cidade: 'são paulo',
    );
    expect(cidade.prefixoCampo, 'cidade');
    expect(cidade.prefixo, 'São Paulo');
  });

  test('filtro local esconde contrato já assinado quando a lista é pendente', () {
    expect(
      passaFiltroLocal(
        filtro: FiltroContrato.pendentes,
        assinado: true,
        enviado: false,
        cidadeContrato: 'Blumenau',
        cidadeBusca: '',
        filtrarCidadeLocal: false,
      ),
      isFalse,
    );
    expect(
      seloSituacao(
        assinado: true,
        testemunha: false,
        enviado: true,
        temPdf: true,
      ),
      'Falta testemunha',
    );
  });
}
