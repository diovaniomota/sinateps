import 'contrato_validacao.dart';

enum FiltroContrato { todos, pendentes, enviados, assinados }

enum TipoTermo { vazio, cpf, numero, nome }

class TermoBusca {
  const TermoBusca(this.tipo, this.valor);

  final TipoTermo tipo;
  final String valor;
}

class IgualdadeConsulta {
  const IgualdadeConsulta(this.campo, this.valor);

  final String campo;
  final Object valor;
}

class ConsultaContrato {
  const ConsultaContrato({
    required this.restringeCriador,
    required this.ordenarPor,
    required this.descendente,
    this.igualdades = const [],
    this.prefixoCampo,
    this.prefixo,
    this.filtroLocal = FiltroContrato.todos,
    this.filtrarCidadeLocal = false,
    this.ordenar = true,
  });

  final bool restringeCriador;
  final String ordenarPor;
  final bool descendente;
  final bool ordenar;
  final List<IgualdadeConsulta> igualdades;
  final String? prefixoCampo;
  final String? prefixo;
  final FiltroContrato filtroLocal;
  final bool filtrarCidadeLocal;
}

FiltroContrato filtroContratoDe(String valor) {
  switch (valor) {
    case 'pendentes':
      return FiltroContrato.pendentes;
    case 'enviados':
      return FiltroContrato.enviados;
    case 'assinados':
      return FiltroContrato.assinados;
    default:
      return FiltroContrato.todos;
  }
}

TermoBusca classificarTermo(String termo) {
  final texto = termo.trim();
  if (texto.isEmpty) return const TermoBusca(TipoTermo.vazio, '');
  final digitos = somenteDigitos(texto);
  if (digitos.length == 11) {
    return TermoBusca(TipoTermo.cpf, formatarCpf(digitos));
  }
  if (digitos.isNotEmpty && digitos.length <= 8 && digitos == texto.replaceAll(RegExp(r'\s'), '')) {
    return TermoBusca(TipoTermo.numero, digitos);
  }
  return TermoBusca(TipoTermo.nome, texto);
}

ConsultaContrato montarConsulta({
  required bool admin,
  required String filtro,
  required String termo,
  required String cidade,
}) {
  final filtroEnum = filtroContratoDe(filtro);
  final busca = classificarTermo(termo);
  final cidadeTexto = cidade.trim();
  final temCidade = cidadeTexto.isNotEmpty;

  if (busca.tipo == TipoTermo.cpf || busca.tipo == TipoTermo.numero) {
    return ConsultaContrato(
      restringeCriador: !admin,
      ordenarPor: 'criado_em',
      descendente: true,
      ordenar: false,
      igualdades: [
        IgualdadeConsulta(
          busca.tipo == TipoTermo.cpf ? 'documento' : 'numero_doc',
          busca.tipo == TipoTermo.cpf ? busca.valor : int.parse(busca.valor),
        ),
      ],
      filtroLocal: filtroEnum,
      filtrarCidadeLocal: temCidade,
    );
  }

  if (busca.tipo == TipoTermo.nome) {
    final prefixo = capitalizarPalavras(busca.valor);
    return ConsultaContrato(
      restringeCriador: !admin,
      ordenarPor: 'contratante',
      descendente: false,
      prefixoCampo: 'contratante',
      prefixo: prefixo,
      filtroLocal: filtroEnum,
      filtrarCidadeLocal: temCidade,
    );
  }

  if (temCidade) {
    return ConsultaContrato(
      restringeCriador: !admin,
      ordenarPor: 'cidade',
      descendente: false,
      prefixoCampo: 'cidade',
      prefixo: capitalizarPalavras(cidadeTexto),
      filtroLocal: filtroEnum,
    );
  }

  if (filtroEnum == FiltroContrato.assinados) {
    return ConsultaContrato(
      restringeCriador: !admin,
      ordenarPor: 'criado_em',
      descendente: true,
      igualdades: const [IgualdadeConsulta('contrato_assinado', true)],
    );
  }

  if (filtroEnum == FiltroContrato.enviados) {
    return ConsultaContrato(
      restringeCriador: !admin,
      ordenarPor: 'criado_em',
      descendente: true,
      igualdades: const [IgualdadeConsulta('autentiqueStatus', 'enviado')],
    );
  }

  return ConsultaContrato(
    restringeCriador: !admin,
    ordenarPor: 'criado_em',
    descendente: true,
    filtroLocal: filtroEnum,
  );
}

bool passaFiltroLocal({
  required FiltroContrato filtro,
  required bool assinado,
  required bool enviado,
  required String cidadeContrato,
  required String cidadeBusca,
  required bool filtrarCidadeLocal,
}) {
  if (filtro == FiltroContrato.pendentes && assinado) return false;
  if (filtro == FiltroContrato.enviados && !enviado) return false;
  if (filtro == FiltroContrato.assinados && !assinado) return false;
  if (filtrarCidadeLocal &&
      !normalizarBusca(cidadeContrato).contains(normalizarBusca(cidadeBusca))) {
    return false;
  }
  return true;
}
