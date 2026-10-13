String somenteDigitos(String valor) => valor.replaceAll(RegExp(r'\D'), '');

String normalizarBusca(String valor) {
  const de = 'áàâãäéèêëíìîïóòôõöúùûüçñÁÀÂÃÄÉÈÊËÍÌÎÏÓÒÔÕÖÚÙÛÜÇÑ';
  const para = 'aaaaaeeeeiiiiooooouuuucnAAAAAEEEEIIIIOOOOOUUUUCN';
  final buffer = StringBuffer();
  for (final char in valor.trim().toLowerCase().split('')) {
    final index = de.indexOf(char);
    buffer.write(index >= 0 ? para[index] : char);
  }
  return buffer.toString().replaceAll(RegExp(r'\s+'), ' ');
}

String capitalizarNome(String valor) {
  return normalizarBusca(valor)
      .split(' ')
      .where((parte) => parte.isNotEmpty)
      .map((parte) => '${parte[0].toUpperCase()}${parte.substring(1)}')
      .join(' ');
}

/// Título para prefixo no Firestore, com o acento do nome digitado.
String capitalizarPalavras(String valor) {
  return valor
      .trim()
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((parte) => parte.isNotEmpty)
      .map((parte) => '${parte[0].toUpperCase()}${parte.substring(1)}')
      .join(' ');
}

bool cpfValido(String valor) {
  final digitos = somenteDigitos(valor);
  if (digitos.length != 11) return false;
  if (RegExp(r'^(\d)\1{10}$').hasMatch(digitos)) return false;

  int digito(int tamanho) {
    var soma = 0;
    for (var i = 0; i < tamanho; i++) {
      soma += int.parse(digitos[i]) * (tamanho + 1 - i);
    }
    final resto = (soma * 10) % 11;
    return resto == 10 ? 0 : resto;
  }

  return digito(9) == int.parse(digitos[9]) &&
      digito(10) == int.parse(digitos[10]);
}

String formatarCpf(String valor) {
  final digitos = somenteDigitos(valor);
  if (digitos.length != 11) return valor.trim();
  return '${digitos.substring(0, 3)}.${digitos.substring(3, 6)}.${digitos.substring(6, 9)}-${digitos.substring(9)}';
}

bool telefoneValido(String valor) {
  var digitos = somenteDigitos(valor);
  if (digitos.startsWith('55') && digitos.length > 11) {
    digitos = digitos.substring(2);
  }
  return digitos.length == 10 || digitos.length == 11;
}

bool emailOpcionalValido(String valor) {
  final texto = valor.trim();
  if (texto.isEmpty) return true;
  return RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(texto);
}

String? erroContratante({
  required String contratante,
  required String documento,
  required String telefones,
  required String email,
}) {
  return null;
}

String? erroAluno(String aluno) {
  return null;
}

String seloSituacao({
  required bool assinado,
  required bool testemunha,
  required bool enviado,
  required bool temPdf,
}) {
  if (assinado && testemunha) return 'Concluído';
  if (assinado) return 'Falta testemunha';
  if (enviado) return 'Enviado';
  if (temPdf) return 'PDF pronto';
  return 'Rascunho';
}

Map<String, dynamic> camposBusca({
  required String contratante,
  required String documento,
  required String cidade,
}) {
  return {
    'busca_nome': normalizarBusca(contratante),
    'documento_digits': somenteDigitos(documento),
    'cidade_norm': normalizarBusca(cidade),
  };
}
