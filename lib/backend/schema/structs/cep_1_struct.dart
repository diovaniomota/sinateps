// ignore_for_file: unnecessary_getters_setters

import 'package:cloud_firestore/cloud_firestore.dart';

import '/backend/schema/util/firestore_util.dart';

import '/flutter_flow/flutter_flow_util.dart';

class Cep1Struct extends FFFirebaseStruct {
  Cep1Struct({
    String? cep,
    String? logradouro,
    String? complemento,
    String? unidade,
    String? bairro,
    String? localidade,
    String? uf,
    String? estado,
    String? regiao,
    String? ibge,
    String? gia,
    String? ddd,
    String? siafi,
    FirestoreUtilData firestoreUtilData = const FirestoreUtilData(),
  })  : _cep = cep,
        _logradouro = logradouro,
        _complemento = complemento,
        _unidade = unidade,
        _bairro = bairro,
        _localidade = localidade,
        _uf = uf,
        _estado = estado,
        _regiao = regiao,
        _ibge = ibge,
        _gia = gia,
        _ddd = ddd,
        _siafi = siafi,
        super(firestoreUtilData);

  // "cep" field.
  String? _cep;
  String get cep => _cep ?? '';
  set cep(String? val) => _cep = val;

  bool hasCep() => _cep != null;

  // "logradouro" field.
  String? _logradouro;
  String get logradouro => _logradouro ?? '';
  set logradouro(String? val) => _logradouro = val;

  bool hasLogradouro() => _logradouro != null;

  // "complemento" field.
  String? _complemento;
  String get complemento => _complemento ?? '';
  set complemento(String? val) => _complemento = val;

  bool hasComplemento() => _complemento != null;

  // "unidade" field.
  String? _unidade;
  String get unidade => _unidade ?? '';
  set unidade(String? val) => _unidade = val;

  bool hasUnidade() => _unidade != null;

  // "bairro" field.
  String? _bairro;
  String get bairro => _bairro ?? '';
  set bairro(String? val) => _bairro = val;

  bool hasBairro() => _bairro != null;

  // "localidade" field.
  String? _localidade;
  String get localidade => _localidade ?? '';
  set localidade(String? val) => _localidade = val;

  bool hasLocalidade() => _localidade != null;

  // "uf" field.
  String? _uf;
  String get uf => _uf ?? '';
  set uf(String? val) => _uf = val;

  bool hasUf() => _uf != null;

  // "estado" field.
  String? _estado;
  String get estado => _estado ?? '';
  set estado(String? val) => _estado = val;

  bool hasEstado() => _estado != null;

  // "regiao" field.
  String? _regiao;
  String get regiao => _regiao ?? '';
  set regiao(String? val) => _regiao = val;

  bool hasRegiao() => _regiao != null;

  // "ibge" field.
  String? _ibge;
  String get ibge => _ibge ?? '';
  set ibge(String? val) => _ibge = val;

  bool hasIbge() => _ibge != null;

  // "gia" field.
  String? _gia;
  String get gia => _gia ?? '';
  set gia(String? val) => _gia = val;

  bool hasGia() => _gia != null;

  // "ddd" field.
  String? _ddd;
  String get ddd => _ddd ?? '';
  set ddd(String? val) => _ddd = val;

  bool hasDdd() => _ddd != null;

  // "siafi" field.
  String? _siafi;
  String get siafi => _siafi ?? '';
  set siafi(String? val) => _siafi = val;

  bool hasSiafi() => _siafi != null;

  static Cep1Struct fromMap(Map<String, dynamic> data) => Cep1Struct(
        cep: data['cep'] as String?,
        logradouro: data['logradouro'] as String?,
        complemento: data['complemento'] as String?,
        unidade: data['unidade'] as String?,
        bairro: data['bairro'] as String?,
        localidade: data['localidade'] as String?,
        uf: data['uf'] as String?,
        estado: data['estado'] as String?,
        regiao: data['regiao'] as String?,
        ibge: data['ibge'] as String?,
        gia: data['gia'] as String?,
        ddd: data['ddd'] as String?,
        siafi: data['siafi'] as String?,
      );

  static Cep1Struct? maybeFromMap(dynamic data) =>
      data is Map ? Cep1Struct.fromMap(data.cast<String, dynamic>()) : null;

  Map<String, dynamic> toMap() => {
        'cep': _cep,
        'logradouro': _logradouro,
        'complemento': _complemento,
        'unidade': _unidade,
        'bairro': _bairro,
        'localidade': _localidade,
        'uf': _uf,
        'estado': _estado,
        'regiao': _regiao,
        'ibge': _ibge,
        'gia': _gia,
        'ddd': _ddd,
        'siafi': _siafi,
      }.withoutNulls;

  @override
  Map<String, dynamic> toSerializableMap() => {
        'cep': serializeParam(
          _cep,
          ParamType.String,
        ),
        'logradouro': serializeParam(
          _logradouro,
          ParamType.String,
        ),
        'complemento': serializeParam(
          _complemento,
          ParamType.String,
        ),
        'unidade': serializeParam(
          _unidade,
          ParamType.String,
        ),
        'bairro': serializeParam(
          _bairro,
          ParamType.String,
        ),
        'localidade': serializeParam(
          _localidade,
          ParamType.String,
        ),
        'uf': serializeParam(
          _uf,
          ParamType.String,
        ),
        'estado': serializeParam(
          _estado,
          ParamType.String,
        ),
        'regiao': serializeParam(
          _regiao,
          ParamType.String,
        ),
        'ibge': serializeParam(
          _ibge,
          ParamType.String,
        ),
        'gia': serializeParam(
          _gia,
          ParamType.String,
        ),
        'ddd': serializeParam(
          _ddd,
          ParamType.String,
        ),
        'siafi': serializeParam(
          _siafi,
          ParamType.String,
        ),
      }.withoutNulls;

  static Cep1Struct fromSerializableMap(Map<String, dynamic> data) =>
      Cep1Struct(
        cep: deserializeParam(
          data['cep'],
          ParamType.String,
          false,
        ),
        logradouro: deserializeParam(
          data['logradouro'],
          ParamType.String,
          false,
        ),
        complemento: deserializeParam(
          data['complemento'],
          ParamType.String,
          false,
        ),
        unidade: deserializeParam(
          data['unidade'],
          ParamType.String,
          false,
        ),
        bairro: deserializeParam(
          data['bairro'],
          ParamType.String,
          false,
        ),
        localidade: deserializeParam(
          data['localidade'],
          ParamType.String,
          false,
        ),
        uf: deserializeParam(
          data['uf'],
          ParamType.String,
          false,
        ),
        estado: deserializeParam(
          data['estado'],
          ParamType.String,
          false,
        ),
        regiao: deserializeParam(
          data['regiao'],
          ParamType.String,
          false,
        ),
        ibge: deserializeParam(
          data['ibge'],
          ParamType.String,
          false,
        ),
        gia: deserializeParam(
          data['gia'],
          ParamType.String,
          false,
        ),
        ddd: deserializeParam(
          data['ddd'],
          ParamType.String,
          false,
        ),
        siafi: deserializeParam(
          data['siafi'],
          ParamType.String,
          false,
        ),
      );

  @override
  String toString() => 'Cep1Struct(${toMap()})';

  @override
  bool operator ==(Object other) {
    return other is Cep1Struct &&
        cep == other.cep &&
        logradouro == other.logradouro &&
        complemento == other.complemento &&
        unidade == other.unidade &&
        bairro == other.bairro &&
        localidade == other.localidade &&
        uf == other.uf &&
        estado == other.estado &&
        regiao == other.regiao &&
        ibge == other.ibge &&
        gia == other.gia &&
        ddd == other.ddd &&
        siafi == other.siafi;
  }

  @override
  int get hashCode => const ListEquality().hash([
        cep,
        logradouro,
        complemento,
        unidade,
        bairro,
        localidade,
        uf,
        estado,
        regiao,
        ibge,
        gia,
        ddd,
        siafi
      ]);
}

Cep1Struct createCep1Struct({
  String? cep,
  String? logradouro,
  String? complemento,
  String? unidade,
  String? bairro,
  String? localidade,
  String? uf,
  String? estado,
  String? regiao,
  String? ibge,
  String? gia,
  String? ddd,
  String? siafi,
  Map<String, dynamic> fieldValues = const {},
  bool clearUnsetFields = true,
  bool create = false,
  bool delete = false,
}) =>
    Cep1Struct(
      cep: cep,
      logradouro: logradouro,
      complemento: complemento,
      unidade: unidade,
      bairro: bairro,
      localidade: localidade,
      uf: uf,
      estado: estado,
      regiao: regiao,
      ibge: ibge,
      gia: gia,
      ddd: ddd,
      siafi: siafi,
      firestoreUtilData: FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
        delete: delete,
        fieldValues: fieldValues,
      ),
    );

Cep1Struct? updateCep1Struct(
  Cep1Struct? cep1, {
  bool clearUnsetFields = true,
  bool create = false,
}) =>
    cep1
      ?..firestoreUtilData = FirestoreUtilData(
        clearUnsetFields: clearUnsetFields,
        create: create,
      );

void addCep1StructData(
  Map<String, dynamic> firestoreData,
  Cep1Struct? cep1,
  String fieldName, [
  bool forFieldValue = false,
]) {
  firestoreData.remove(fieldName);
  if (cep1 == null) {
    return;
  }
  if (cep1.firestoreUtilData.delete) {
    firestoreData[fieldName] = FieldValue.delete();
    return;
  }
  final clearFields = !forFieldValue && cep1.firestoreUtilData.clearUnsetFields;
  if (clearFields) {
    firestoreData[fieldName] = <String, dynamic>{};
  }
  final cep1Data = getCep1FirestoreData(cep1, forFieldValue);
  final nestedData = cep1Data.map((k, v) => MapEntry('$fieldName.$k', v));

  final mergeFields = cep1.firestoreUtilData.create || clearFields;
  firestoreData
      .addAll(mergeFields ? mergeNestedFields(nestedData) : nestedData);
}

Map<String, dynamic> getCep1FirestoreData(
  Cep1Struct? cep1, [
  bool forFieldValue = false,
]) {
  if (cep1 == null) {
    return {};
  }
  final firestoreData = mapToFirestore(cep1.toMap());

  // Add any Firestore field values
  cep1.firestoreUtilData.fieldValues.forEach((k, v) => firestoreData[k] = v);

  return forFieldValue ? mergeNestedFields(firestoreData) : firestoreData;
}

List<Map<String, dynamic>> getCep1ListFirestoreData(
  List<Cep1Struct>? cep1s,
) =>
    cep1s?.map((e) => getCep1FirestoreData(e, true)).toList() ?? [];
