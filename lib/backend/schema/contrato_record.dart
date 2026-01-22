import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ContratoRecord extends FirestoreRecord {
  ContratoRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "criado_por" field.
  String? _criadoPor;
  String get criadoPor => _criadoPor ?? '';
  bool hasCriadoPor() => _criadoPor != null;

  // "criado_em" field.
  DateTime? _criadoEm;
  DateTime? get criadoEm => _criadoEm;
  bool hasCriadoEm() => _criadoEm != null;

  // "assinatura" field.
  String? _assinatura;
  String get assinatura => _assinatura ?? '';
  bool hasAssinatura() => _assinatura != null;

  // "assinado_em" field.
  DateTime? _assinadoEm;
  DateTime? get assinadoEm => _assinadoEm;
  bool hasAssinadoEm() => _assinadoEm != null;

  // "pdf" field.
  String? _pdf;
  String get pdf => _pdf ?? '';
  bool hasPdf() => _pdf != null;

  // "contratante" field.
  String? _contratante;
  String get contratante => _contratante ?? '';
  bool hasContratante() => _contratante != null;

  // "documento" field.
  String? _documento;
  String get documento => _documento ?? '';
  bool hasDocumento() => _documento != null;

  // "rg" field.
  String? _rg;
  String get rg => _rg ?? '';
  bool hasRg() => _rg != null;

  // "filiacao" field.
  String? _filiacao;
  String get filiacao => _filiacao ?? '';
  bool hasFiliacao() => _filiacao != null;

  // "naturalidade" field.
  String? _naturalidade;
  String get naturalidade => _naturalidade ?? '';
  bool hasNaturalidade() => _naturalidade != null;

  // "sexo" field.
  String? _sexo;
  String get sexo => _sexo ?? '';
  bool hasSexo() => _sexo != null;

  // "endereco" field.
  String? _endereco;
  String get endereco => _endereco ?? '';
  bool hasEndereco() => _endereco != null;

  // "bairro" field.
  String? _bairro;
  String get bairro => _bairro ?? '';
  bool hasBairro() => _bairro != null;

  // "cidade" field.
  String? _cidade;
  String get cidade => _cidade ?? '';
  bool hasCidade() => _cidade != null;

  // "uf" field.
  String? _uf;
  String get uf => _uf ?? '';
  bool hasUf() => _uf != null;

  // "telefones" field.
  String? _telefones;
  String get telefones => _telefones ?? '';
  bool hasTelefones() => _telefones != null;

  // "aluno" field.
  String? _aluno;
  String get aluno => _aluno ?? '';
  bool hasAluno() => _aluno != null;

  // "alunoDocumento" field.
  String? _alunoDocumento;
  String get alunoDocumento => _alunoDocumento ?? '';
  bool hasAlunoDocumento() => _alunoDocumento != null;

  // "alunoNaturalidade" field.
  String? _alunoNaturalidade;
  String get alunoNaturalidade => _alunoNaturalidade ?? '';
  bool hasAlunoNaturalidade() => _alunoNaturalidade != null;

  // "alunoTelefone" field.
  String? _alunoTelefone;
  String get alunoTelefone => _alunoTelefone ?? '';
  bool hasAlunoTelefone() => _alunoTelefone != null;

  // "numero" field.
  String? _numero;
  String get numero => _numero ?? '';
  bool hasNumero() => _numero != null;

  // "cep" field.
  String? _cep;
  String get cep => _cep ?? '';
  bool hasCep() => _cep != null;

  // "dn" field.
  String? _dn;
  String get dn => _dn ?? '';
  bool hasDn() => _dn != null;

  // "alunoDN" field.
  String? _alunoDN;
  String get alunoDN => _alunoDN ?? '';
  bool hasAlunoDN() => _alunoDN != null;

  // "signedUrl" field.
  String? _signedUrl;
  String get signedUrl => _signedUrl ?? '';
  bool hasSignedUrl() => _signedUrl != null;

  // "indicacao" field.
  String? _indicacao;
  String get indicacao => _indicacao ?? '';
  bool hasIndicacao() => _indicacao != null;

  // "horas" field.
  String? _horas;
  String get horas => _horas ?? '';
  bool hasHoras() => _horas != null;

  // "outro" field.
  String? _outro;
  String get outro => _outro ?? '';
  bool hasOutro() => _outro != null;

  // "contratada" field.
  String? _contratada;
  String get contratada => _contratada ?? '';
  bool hasContratada() => _contratada != null;

  // "descontoRS" field.
  String? _descontoRS;
  String get descontoRS => _descontoRS ?? '';
  bool hasDescontoRS() => _descontoRS != null;

  // "opcaoCurso" field.
  String? _opcaoCurso;
  String get opcaoCurso => _opcaoCurso ?? '';
  bool hasOpcaoCurso() => _opcaoCurso != null;

  // "pagamento" field.
  String? _pagamento;
  String get pagamento => _pagamento ?? '';
  bool hasPagamento() => _pagamento != null;

  // "inicioPrevisto" field.
  String? _inicioPrevisto;
  String get inicioPrevisto => _inicioPrevisto ?? '';
  bool hasInicioPrevisto() => _inicioPrevisto != null;

  // "primeiraParcela" field.
  String? _primeiraParcela;
  String get primeiraParcela => _primeiraParcela ?? '';
  bool hasPrimeiraParcela() => _primeiraParcela != null;

  // "assTestemunha" field.
  String? _assTestemunha;
  String get assTestemunha => _assTestemunha ?? '';
  bool hasAssTestemunha() => _assTestemunha != null;

  // "assTes_em" field.
  DateTime? _assTesEm;
  DateTime? get assTesEm => _assTesEm;
  bool hasAssTesEm() => _assTesEm != null;

  // "criador" field.
  DocumentReference? _criador;
  DocumentReference? get criador => _criador;
  bool hasCriador() => _criador != null;

  // "signed_em" field.
  DateTime? _signedEm;
  DateTime? get signedEm => _signedEm;
  bool hasSignedEm() => _signedEm != null;

  // "numero_doc" field.
  int? _numeroDoc;
  int get numeroDoc => _numeroDoc ?? 0;
  bool hasNumeroDoc() => _numeroDoc != null;

  // "criado_str" field.
  String? _criadoStr;
  String get criadoStr => _criadoStr ?? '';
  bool hasCriadoStr() => _criadoStr != null;

  // "idCliente" field.
  String? _idCliente;
  String get idCliente => _idCliente ?? '';
  bool hasIdCliente() => _idCliente != null;

  // "fotoCliente" field.
  String? _fotoCliente;
  String get fotoCliente => _fotoCliente ?? '';
  bool hasFotoCliente() => _fotoCliente != null;

  // "tipo" field.
  String? _tipo;
  String get tipo => _tipo ?? '';
  bool hasTipo() => _tipo != null;

  // "assinatura_link" field.
  String? _assinaturaLink;
  String get assinaturaLink => _assinaturaLink ?? '';
  bool hasAssinaturaLink() => _assinaturaLink != null;

  // "contrato_assinado" field.
  bool? _contratoAssinado;
  bool get contratoAssinado => _contratoAssinado ?? false;
  bool hasContratoAssinado() => _contratoAssinado != null;

  // "contrato_testemunha" field.
  bool? _contratoTestemunha;
  bool get contratoTestemunha => _contratoTestemunha ?? false;
  bool hasContratoTestemunha() => _contratoTestemunha != null;

  // "check_contrato" field.
  bool? _checkContrato;
  bool get checkContrato => _checkContrato ?? false;
  bool hasCheckContrato() => _checkContrato != null;

  // "dtCriacao" field.
  String? _dtCriacao;
  String get dtCriacao => _dtCriacao ?? '';
  bool hasDtCriacao() => _dtCriacao != null;

  // "dtAssinado" field.
  String? _dtAssinado;
  String get dtAssinado => _dtAssinado ?? '';
  bool hasDtAssinado() => _dtAssinado != null;

  // "qrCode" field.
  String? _qrCode;
  String get qrCode => _qrCode ?? '';
  bool hasQrCode() => _qrCode != null;

  // "urlLink" field.
  String? _urlLink;
  String get urlLink => _urlLink ?? '';
  bool hasUrlLink() => _urlLink != null;

  // "email" field.
  String? _email;
  String get email => _email ?? '';
  bool hasEmail() => _email != null;

  // "autentiqueId" field.
  String? _autentiqueId;
  String get autentiqueId => _autentiqueId ?? '';
  bool hasAutentiqueId() => _autentiqueId != null;

  // "autentiqueStatus" field.
  String? _autentiqueStatus;
  String get autentiqueStatus => _autentiqueStatus ?? '';
  bool hasAutentiqueStatus() => _autentiqueStatus != null;

  void _initializeFields() {
    _criadoPor = snapshotData['criado_por'] as String?;
    _criadoEm = snapshotData['criado_em'] as DateTime?;
    _assinatura = snapshotData['assinatura'] as String?;
    _assinadoEm = snapshotData['assinado_em'] as DateTime?;
    _pdf = snapshotData['pdf'] as String?;
    _contratante = snapshotData['contratante'] as String?;
    _documento = snapshotData['documento'] as String?;
    _rg = snapshotData['rg'] as String?;
    _filiacao = snapshotData['filiacao'] as String?;
    _naturalidade = snapshotData['naturalidade'] as String?;
    _sexo = snapshotData['sexo'] as String?;
    _endereco = snapshotData['endereco'] as String?;
    _bairro = snapshotData['bairro'] as String?;
    _cidade = snapshotData['cidade'] as String?;
    _uf = snapshotData['uf'] as String?;
    _telefones = snapshotData['telefones'] as String?;
    _aluno = snapshotData['aluno'] as String?;
    _alunoDocumento = snapshotData['alunoDocumento'] as String?;
    _alunoNaturalidade = snapshotData['alunoNaturalidade'] as String?;
    _alunoTelefone = snapshotData['alunoTelefone'] as String?;
    _numero = snapshotData['numero'] as String?;
    _cep = snapshotData['cep'] as String?;
    _dn = snapshotData['dn'] as String?;
    _alunoDN = snapshotData['alunoDN'] as String?;
    _signedUrl = snapshotData['signedUrl'] as String?;
    _indicacao = snapshotData['indicacao'] as String?;
    _horas = snapshotData['horas'] as String?;
    _outro = snapshotData['outro'] as String?;
    _contratada = snapshotData['contratada'] as String?;
    _descontoRS = snapshotData['descontoRS'] as String?;
    _opcaoCurso = snapshotData['opcaoCurso'] as String?;
    _pagamento = snapshotData['pagamento'] as String?;
    _inicioPrevisto = snapshotData['inicioPrevisto'] as String?;
    _primeiraParcela = snapshotData['primeiraParcela'] as String?;
    _assTestemunha = snapshotData['assTestemunha'] as String?;
    _assTesEm = snapshotData['assTes_em'] as DateTime?;
    _criador = snapshotData['criador'] as DocumentReference?;
    _signedEm = snapshotData['signed_em'] as DateTime?;
    _numeroDoc = castToType<int>(snapshotData['numero_doc']);
    _criadoStr = snapshotData['criado_str'] as String?;
    _idCliente = snapshotData['idCliente'] as String?;
    _fotoCliente = snapshotData['fotoCliente'] as String?;
    _tipo = snapshotData['tipo'] as String?;
    _assinaturaLink = snapshotData['assinatura_link'] as String?;
    _contratoAssinado = snapshotData['contrato_assinado'] as bool?;
    _contratoTestemunha = snapshotData['contrato_testemunha'] as bool?;
    _checkContrato = snapshotData['check_contrato'] as bool?;
    _dtCriacao = snapshotData['dtCriacao'] as String?;
    _dtAssinado = snapshotData['dtAssinado'] as String?;
    _qrCode = snapshotData['qrCode'] as String?;
    _urlLink = snapshotData['urlLink'] as String?;
    _email = snapshotData['email'] as String?;
    _autentiqueId = snapshotData['autentiqueId'] as String?;
    _autentiqueStatus = snapshotData['autentiqueStatus'] as String?;
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('contrato');

  static Stream<ContratoRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ContratoRecord.fromSnapshot(s));

  static Future<ContratoRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ContratoRecord.fromSnapshot(s));

  static ContratoRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ContratoRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ContratoRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ContratoRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ContratoRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ContratoRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createContratoRecordData({
  String? criadoPor,
  DateTime? criadoEm,
  String? assinatura,
  DateTime? assinadoEm,
  String? pdf,
  String? contratante,
  String? documento,
  String? rg,
  String? filiacao,
  String? naturalidade,
  String? sexo,
  String? endereco,
  String? bairro,
  String? cidade,
  String? uf,
  String? telefones,
  String? aluno,
  String? alunoDocumento,
  String? alunoNaturalidade,
  String? alunoTelefone,
  String? numero,
  String? cep,
  String? dn,
  String? alunoDN,
  String? signedUrl,
  String? indicacao,
  String? horas,
  String? outro,
  String? contratada,
  String? descontoRS,
  String? opcaoCurso,
  String? pagamento,
  String? inicioPrevisto,
  String? primeiraParcela,
  String? assTestemunha,
  DateTime? assTesEm,
  DocumentReference? criador,
  DateTime? signedEm,
  int? numeroDoc,
  String? criadoStr,
  String? idCliente,
  String? fotoCliente,
  String? tipo,
  String? assinaturaLink,
  bool? contratoAssinado,
  bool? contratoTestemunha,
  bool? checkContrato,
  String? dtCriacao,
  String? dtAssinado,
  String? qrCode,
  String? urlLink,
  String? email,
  String? autentiqueId,
  String? autentiqueStatus,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'criado_por': criadoPor,
      'criado_em': criadoEm,
      'assinatura': assinatura,
      'assinado_em': assinadoEm,
      'pdf': pdf,
      'contratante': contratante,
      'documento': documento,
      'rg': rg,
      'filiacao': filiacao,
      'naturalidade': naturalidade,
      'sexo': sexo,
      'endereco': endereco,
      'bairro': bairro,
      'cidade': cidade,
      'uf': uf,
      'telefones': telefones,
      'aluno': aluno,
      'alunoDocumento': alunoDocumento,
      'alunoNaturalidade': alunoNaturalidade,
      'alunoTelefone': alunoTelefone,
      'numero': numero,
      'cep': cep,
      'dn': dn,
      'alunoDN': alunoDN,
      'signedUrl': signedUrl,
      'indicacao': indicacao,
      'horas': horas,
      'outro': outro,
      'contratada': contratada,
      'descontoRS': descontoRS,
      'opcaoCurso': opcaoCurso,
      'pagamento': pagamento,
      'inicioPrevisto': inicioPrevisto,
      'primeiraParcela': primeiraParcela,
      'assTestemunha': assTestemunha,
      'assTes_em': assTesEm,
      'criador': criador,
      'signed_em': signedEm,
      'numero_doc': numeroDoc,
      'criado_str': criadoStr,
      'idCliente': idCliente,
      'fotoCliente': fotoCliente,
      'tipo': tipo,
      'assinatura_link': assinaturaLink,
      'contrato_assinado': contratoAssinado,
      'contrato_testemunha': contratoTestemunha,
      'check_contrato': checkContrato,
      'dtCriacao': dtCriacao,
      'dtAssinado': dtAssinado,
      'qrCode': qrCode,
      'urlLink': urlLink,
      'email': email,
      'autentiqueId': autentiqueId,
      'autentiqueStatus': autentiqueStatus,
    }.withoutNulls,
  );

  return firestoreData;
}

class ContratoRecordDocumentEquality implements Equality<ContratoRecord> {
  const ContratoRecordDocumentEquality();

  @override
  bool equals(ContratoRecord? e1, ContratoRecord? e2) {
    return e1?.criadoPor == e2?.criadoPor &&
        e1?.criadoEm == e2?.criadoEm &&
        e1?.assinatura == e2?.assinatura &&
        e1?.assinadoEm == e2?.assinadoEm &&
        e1?.pdf == e2?.pdf &&
        e1?.contratante == e2?.contratante &&
        e1?.documento == e2?.documento &&
        e1?.rg == e2?.rg &&
        e1?.filiacao == e2?.filiacao &&
        e1?.naturalidade == e2?.naturalidade &&
        e1?.sexo == e2?.sexo &&
        e1?.endereco == e2?.endereco &&
        e1?.bairro == e2?.bairro &&
        e1?.cidade == e2?.cidade &&
        e1?.uf == e2?.uf &&
        e1?.telefones == e2?.telefones &&
        e1?.aluno == e2?.aluno &&
        e1?.alunoDocumento == e2?.alunoDocumento &&
        e1?.alunoNaturalidade == e2?.alunoNaturalidade &&
        e1?.alunoTelefone == e2?.alunoTelefone &&
        e1?.numero == e2?.numero &&
        e1?.cep == e2?.cep &&
        e1?.dn == e2?.dn &&
        e1?.alunoDN == e2?.alunoDN &&
        e1?.signedUrl == e2?.signedUrl &&
        e1?.indicacao == e2?.indicacao &&
        e1?.horas == e2?.horas &&
        e1?.outro == e2?.outro &&
        e1?.contratada == e2?.contratada &&
        e1?.descontoRS == e2?.descontoRS &&
        e1?.opcaoCurso == e2?.opcaoCurso &&
        e1?.pagamento == e2?.pagamento &&
        e1?.inicioPrevisto == e2?.inicioPrevisto &&
        e1?.primeiraParcela == e2?.primeiraParcela &&
        e1?.assTestemunha == e2?.assTestemunha &&
        e1?.assTesEm == e2?.assTesEm &&
        e1?.criador == e2?.criador &&
        e1?.signedEm == e2?.signedEm &&
        e1?.numeroDoc == e2?.numeroDoc &&
        e1?.criadoStr == e2?.criadoStr &&
        e1?.idCliente == e2?.idCliente &&
        e1?.fotoCliente == e2?.fotoCliente &&
        e1?.tipo == e2?.tipo &&
        e1?.assinaturaLink == e2?.assinaturaLink &&
        e1?.contratoAssinado == e2?.contratoAssinado &&
        e1?.contratoTestemunha == e2?.contratoTestemunha &&
        e1?.checkContrato == e2?.checkContrato &&
        e1?.dtCriacao == e2?.dtCriacao &&
        e1?.dtAssinado == e2?.dtAssinado &&
        e1?.qrCode == e2?.qrCode &&
        e1?.urlLink == e2?.urlLink &&
        e1?.email == e2?.email &&
        e1?.autentiqueId == e2?.autentiqueId &&
        e1?.autentiqueStatus == e2?.autentiqueStatus;
  }

  @override
  int hash(ContratoRecord? e) => const ListEquality().hash([
        e?.criadoPor,
        e?.criadoEm,
        e?.assinatura,
        e?.assinadoEm,
        e?.pdf,
        e?.contratante,
        e?.documento,
        e?.rg,
        e?.filiacao,
        e?.naturalidade,
        e?.sexo,
        e?.endereco,
        e?.bairro,
        e?.cidade,
        e?.uf,
        e?.telefones,
        e?.aluno,
        e?.alunoDocumento,
        e?.alunoNaturalidade,
        e?.alunoTelefone,
        e?.numero,
        e?.cep,
        e?.dn,
        e?.alunoDN,
        e?.signedUrl,
        e?.indicacao,
        e?.horas,
        e?.outro,
        e?.contratada,
        e?.descontoRS,
        e?.opcaoCurso,
        e?.pagamento,
        e?.inicioPrevisto,
        e?.primeiraParcela,
        e?.assTestemunha,
        e?.assTesEm,
        e?.criador,
        e?.signedEm,
        e?.numeroDoc,
        e?.criadoStr,
        e?.idCliente,
        e?.fotoCliente,
        e?.tipo,
        e?.assinaturaLink,
        e?.contratoAssinado,
        e?.contratoTestemunha,
        e?.checkContrato,
        e?.dtCriacao,
        e?.dtAssinado,
        e?.qrCode,
        e?.urlLink,
        e?.email,
        e?.autentiqueId,
        e?.autentiqueStatus
      ]);

  @override
  bool isValidKey(Object? o) => o is ContratoRecord;
}
