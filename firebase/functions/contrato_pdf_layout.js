const PAGE = { width: 612, height: 1008 };

const LAYOUT_2026 = {
  contratante: [121, 762],
  documento: [64, 746],
  rg: [202, 747],
  dnDia: [491, 744],
  dnMes: [513, 744],
  dnAno: [538, 744],
  filiacao: [106, 734],
  naturalidade: [471, 734],
  sexoM: [104, 715],
  sexoF: [168, 719],
  endereco: [180, 712],
  numero: [530, 715],
  bairro: [70, 702],
  cidade: [71, 688],
  cep: [356, 688],
  uf: [498, 691],
  telefones: [81, 676],
  aluno: [105, 642],
  alunoDocumento: [94, 629],
  alunoDnDia: [474, 639],
  alunoDnMes: [500, 639],
  alunoDnAno: [526, 639],
  alunoNaturalidade: [467, 627],
  alunoTelefone: [70, 614],
  curso1: [38, 562],
  curso2: [38, 552],
  curso3: [183, 561],
  curso4: [183, 552],
  outro: [257, 557],
  indicacao: [100, 540],
  horas: [510, 445],
  inicioDia: [268, 434],
  inicioMes: [295, 434],
  contratada: [456, 433],
  pagamento36: [76, 371],
  pagamento24: [76, 356],
  pagamento18: [76, 339],
  pagamento14: [76, 323],
  pagamento8: [292, 371],
  pagamento3: [292, 354],
  pagamento12: [292, 341],
  parcelaDia: [184, 300],
  parcelaMes: [210, 300],
  parcelaAno: [228, 300],
  desconto: [292, 281],
  dataDia: [97, 210],
  dataMes: [160, 210],
  dataAno: [248, 211],
  foto: { x: 0, y: 98, width: 100, height: 100 },
};

function coordenadaDentroDaPagina(x, y) {
  return x >= 0 && y >= 0 && x <= PAGE.width && y <= PAGE.height;
}

function layoutValido(layout = LAYOUT_2026) {
  return Object.entries(layout).every(([, value]) => {
    if (Array.isArray(value)) {
      return coordenadaDentroDaPagina(value[0], value[1]);
    }
    return (
      coordenadaDentroDaPagina(value.x, value.y) &&
      value.x + value.width <= PAGE.width &&
      value.y + value.height <= PAGE.height
    );
  });
}

function desenharPartes(draw, valor, chaves) {
  if (!valor) return;
  const partes = String(valor).split("/");
  chaves.forEach((chave, index) => {
    if (partes[index]) draw(partes[index], ...LAYOUT_2026[chave]);
  });
}

function preencherContrato2026(draw, info) {
  const ponto = (chave, valor) => draw(valor, ...LAYOUT_2026[chave]);

  ponto("contratante", info.contratante);
  ponto("documento", info.documento);
  ponto("rg", info.rg);
  desenharPartes(draw, info.dn, ["dnDia", "dnMes", "dnAno"]);
  ponto("filiacao", info.filiacao);
  ponto("naturalidade", info.naturalidade);

  if (info.sexo === "M") ponto("sexoM", "X");
  else if (info.sexo === "F") ponto("sexoF", "X");

  ponto("endereco", info.endereco);
  ponto("numero", info.numero);
  ponto("bairro", info.bairro);
  ponto("cidade", info.cidade);
  ponto("cep", info.cep);
  ponto("uf", info.uf);
  ponto("telefones", info.telefones);
  ponto("aluno", info.aluno);
  ponto("alunoDocumento", info.alunoDocumento);
  desenharPartes(draw, info.alunoDN, ["alunoDnDia", "alunoDnMes", "alunoDnAno"]);
  ponto("alunoNaturalidade", info.alunoNaturalidade);
  ponto("alunoTelefone", info.alunoTelefone);

  const opcaoCursoRaw =
    info.opcaoCurso !== undefined && info.opcaoCurso !== null
      ? String(info.opcaoCurso).trim()
      : "";
  const opcaoCursoKeyMatch = opcaoCursoRaw.match(/^[1-4]/);
  const opcaoCursoKey = opcaoCursoKeyMatch ? opcaoCursoKeyMatch[0] : opcaoCursoRaw;
  const curso = { 1: "curso1", 2: "curso2", 3: "curso3", 4: "curso4" }[opcaoCursoKey];
  if (curso) ponto(curso, "X");
  if (opcaoCursoKey === "4") ponto("outro", info.outro);

  ponto("indicacao", info.indicacao);
  ponto("horas", info.horas);
  desenharPartes(draw, info.inicioPrevisto, ["inicioDia", "inicioMes"]);
  ponto("contratada", info.contratada);

  const pagamento = {
    36: "pagamento36",
    24: "pagamento24",
    18: "pagamento18",
    14: "pagamento14",
    8: "pagamento8",
    3: "pagamento3",
    12: "pagamento12",
  }[String(info.pagamento)];
  if (pagamento) ponto(pagamento, "X");

  desenharPartes(draw, info.primeiraParcela, ["parcelaDia", "parcelaMes", "parcelaAno"]);
  ponto("desconto", info.descontoRS);

  const dataFinal = info.criado_str ? String(info.criado_str).split("/") : [];
  if (dataFinal.length === 3) {
    ponto("dataDia", dataFinal[0]);
    ponto("dataMes", dataFinal[1]);
    ponto("dataAno", dataFinal[2]);
  } else {
    const today = new Date();
    ponto("dataDia", String(today.getDate()));
    ponto("dataMes", String(today.getMonth() + 1));
    ponto("dataAno", String(today.getFullYear()));
  }
}

module.exports = {
  PAGE,
  LAYOUT_2026,
  coordenadaDentroDaPagina,
  layoutValido,
  preencherContrato2026,
};
