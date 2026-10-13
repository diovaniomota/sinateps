const test = require("node:test");
const assert = require("node:assert/strict");
const { LAYOUT_2026, PAGE, layoutValido, preencherContrato2026 } = require("./contrato_pdf_layout");

test("todas as coordenadas do contrato 2026 cabem na página", () => {
  assert.equal(PAGE.width, 612);
  assert.equal(PAGE.height, 1008);
  assert.equal(layoutValido(LAYOUT_2026), true);
  assert.equal(Object.keys(LAYOUT_2026).length >= 40, true);
});

test("preenche nome, cpf e marca o curso sem desenhar campo vazio", () => {
  const desenhos = [];
  const draw = (texto, x, y) => {
    if (texto === undefined || texto === null || texto === "") return;
    desenhos.push({ texto, x, y });
  };

  preencherContrato2026(draw, {
    contratante: "Maria Silva",
    documento: "529.982.247-25",
    opcaoCurso: "2",
    sexo: "F",
    pagamento: "12",
    criado_str: "29/09/2026",
  });

  assert.deepEqual(desenhos[0], { texto: "Maria Silva", x: 121, y: 762 });
  assert.ok(desenhos.some((item) => item.texto === "529.982.247-25"));
  assert.ok(desenhos.some((item) => item.texto === "X" && item.x === 38 && item.y === 552));
  assert.ok(desenhos.every((item) => item.texto !== "" && item.texto != null));
});
