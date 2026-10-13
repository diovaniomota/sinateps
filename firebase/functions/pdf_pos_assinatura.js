const { PDFDocument, StandardFonts, degrees } = require("pdf-lib");
const axios = require("axios");
const { HttpsError } = require("firebase-functions/v2/https");

const HOSTS_STORAGE = [
  "firebasestorage.googleapis.com",
  "storage.googleapis.com",
];

function urlHttps(url, hosts) {
  try {
    const parsed = new URL(String(url));
    return parsed.protocol === "https:" && hosts.includes(parsed.hostname);
  } catch (error) {
    return false;
  }
}

async function baixar(url, hosts) {
  let atual = String(url);
  for (let salto = 0; salto < 2; salto++) {
    if (!urlHttps(atual, hosts)) {
      throw new HttpsError(
        "failed-precondition",
        "A imagem precisa estar em um endereço permitido.",
      );
    }
    const response = await axios.get(atual, {
      responseType: "arraybuffer",
      timeout: 8000,
      maxRedirects: 0,
      validateStatus: (status) => status >= 200 && status < 400,
    });
    if (response.status >= 300 && response.headers.location) {
      atual = new URL(response.headers.location, atual).toString();
      continue;
    }
    return {
      buffer: Buffer.from(response.data),
      contentType: String(response.headers["content-type"] || ""),
    };
  }
  throw new HttpsError("failed-precondition", "Não foi possível baixar a imagem.");
}

async function pngDoStorage(pdfDoc, url) {
  const { buffer } = await baixar(url, HOSTS_STORAGE);
  return pdfDoc.embedPng(buffer);
}

function desenharAssinatura(page, image, x, y) {
  page.drawImage(image, {
    x: x + (image.height * 0.25) / 2,
    y,
    width: image.width * 0.25,
    height: image.height * 0.25,
    rotate: degrees(90),
  });
}

async function carimbarAssinaturas(pdfDoc, info) {
  const [firstPage, secondPage, thirdPage] = pdfDoc.getPages();
  if (!firstPage || !secondPage || !thirdPage) {
    throw new HttpsError(
      "failed-precondition",
      "O PDF do contrato não tem as três páginas esperadas.",
    );
  }

  if (info.assinatura) {
    const image = await pngDoStorage(pdfDoc, info.assinatura);
    firstPage.drawImage(image, {
      x: 395 + (image.height * 0.23) / 2,
      y: 140,
      width: image.width * 0.25,
      height: image.height * 0.25,
      rotate: degrees(90),
    });
    secondPage.drawImage(image, {
      x: 390 + (image.height * 0.2) / 2,
      y: 60,
      width: image.width * 0.25,
      height: image.height * 0.25,
      rotate: degrees(90),
    });
    desenharAssinatura(thirdPage, image, 300, 540);
  }

  if (info.assTestemunha) {
    const image = await pngDoStorage(pdfDoc, info.assTestemunha);
    desenharAssinatura(firstPage, image, 430, 138.5);
    desenharAssinatura(secondPage, image, 385, 45);
    desenharAssinatura(thirdPage, image, 385, 45);
  }
}

async function carimbarFoto(pdfDoc, info) {
  const thirdPage = pdfDoc.getPages()[2];
  if (!thirdPage) {
    throw new HttpsError(
      "failed-precondition",
      "O PDF do contrato não tem a terceira página.",
    );
  }

  if (info.fotoCliente) {
    const { buffer, contentType } = await baixar(info.fotoCliente, HOSTS_STORAGE);
    const arquivo = String(info.fotoCliente).toLowerCase();
    let image;
    if (contentType.includes("png") || arquivo.includes(".png")) {
      image = await pdfDoc.embedPng(buffer);
    } else if (
      contentType.includes("jpeg") ||
      contentType.includes("jpg") ||
      /\.(jpg|jpeg)/.test(arquivo)
    ) {
      image = await pdfDoc.embedJpg(buffer);
    } else {
      throw new HttpsError(
        "failed-precondition",
        "A foto do aluno precisa ser PNG ou JPEG.",
      );
    }
    const imgDims = image.scale(0.2);
    thirdPage.drawImage(image, {
      x: 500,
      y: 520,
      width: imgDims.width,
      height: imgDims.height,
    });
  }

  if (info.qrCode) {
    const { buffer } = await baixar(info.qrCode, ["api.qrserver.com"]);
    const qrImage = await pdfDoc.embedPng(buffer);
    const qrDims = qrImage.scale(0.5);
    thirdPage.drawImage(qrImage, {
      x: 500,
      y: 650,
      width: qrDims.width,
      height: qrDims.height,
    });
  }
}

async function escreverRastro(pdfDoc, info) {
  const font = await pdfDoc.embedFont(StandardFonts.Helvetica);
  while (pdfDoc.getPageCount() < 3) {
    pdfDoc.addPage();
  }
  const thirdPage = pdfDoc.getPages()[2];
  const size = 10;
  const draw = (text, x, y) => {
    thirdPage.drawText(String(text ?? ""), { x, y, size, font });
  };

  draw(info.urlLink, 35, 670);
  draw(info.contratante, 35, 550);
  draw(info.telefones, 35, 538);
  draw(info.dtCriacao, 35, 383);
  draw(info.criado_por, 35, 373);
  draw(`Criou o envelope no dia: ${info.dtCriacao ?? ""}`, 35, 363);
  draw(info.contratante, 35, 343);
  draw(`Assinou e fotografou o rosto - Telefone:${info.telefones ?? ""}`, 35, 333);
  draw(info.ipCliente, 35, 323);
  draw(`- Geolocalização: ${info.geolocalizacao ?? ""}`, 129, 323);
  draw(`Documento de identificação informado: ${info.documento ?? ""}`, 35, 313);
  draw(`no dia: ${info.dtAssinado ?? ""}`, 283, 313);
}

module.exports = {
  carimbarAssinaturas,
  carimbarFoto,
  escreverRastro,
};
