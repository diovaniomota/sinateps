import 'dart:async';

import 'package:collection/collection.dart';

import '/backend/schema/util/firestore_util.dart';

import 'index.dart';
import '/flutter_flow/flutter_flow_util.dart';

class ContratoClienteRecord extends FirestoreRecord {
  ContratoClienteRecord._(
    DocumentReference reference,
    Map<String, dynamic> data,
  ) : super(reference, data) {
    _initializeFields();
  }

  // "documento" field.
  String? _documento;
  String get documento => _documento ?? '';
  bool hasDocumento() => _documento != null;

  // "cliente_ref" field.
  DocumentReference? _clienteRef;
  DocumentReference? get clienteRef => _clienteRef;
  bool hasClienteRef() => _clienteRef != null;

  // "contrato" field.
  List<String>? _contrato;
  List<String> get contrato => _contrato ?? const [];
  bool hasContrato() => _contrato != null;

  void _initializeFields() {
    _documento = snapshotData['documento'] as String?;
    _clienteRef = snapshotData['cliente_ref'] as DocumentReference?;
    _contrato = getDataList(snapshotData['contrato']);
  }

  static CollectionReference get collection =>
      FirebaseFirestore.instance.collection('contrato_cliente');

  static Stream<ContratoClienteRecord> getDocument(DocumentReference ref) =>
      ref.snapshots().map((s) => ContratoClienteRecord.fromSnapshot(s));

  static Future<ContratoClienteRecord> getDocumentOnce(DocumentReference ref) =>
      ref.get().then((s) => ContratoClienteRecord.fromSnapshot(s));

  static ContratoClienteRecord fromSnapshot(DocumentSnapshot snapshot) =>
      ContratoClienteRecord._(
        snapshot.reference,
        mapFromFirestore(snapshot.data() as Map<String, dynamic>),
      );

  static ContratoClienteRecord getDocumentFromData(
    Map<String, dynamic> data,
    DocumentReference reference,
  ) =>
      ContratoClienteRecord._(reference, mapFromFirestore(data));

  @override
  String toString() =>
      'ContratoClienteRecord(reference: ${reference.path}, data: $snapshotData)';

  @override
  int get hashCode => reference.path.hashCode;

  @override
  bool operator ==(other) =>
      other is ContratoClienteRecord &&
      reference.path.hashCode == other.reference.path.hashCode;
}

Map<String, dynamic> createContratoClienteRecordData({
  String? documento,
  DocumentReference? clienteRef,
}) {
  final firestoreData = mapToFirestore(
    <String, dynamic>{
      'documento': documento,
      'cliente_ref': clienteRef,
    }.withoutNulls,
  );

  return firestoreData;
}

class ContratoClienteRecordDocumentEquality
    implements Equality<ContratoClienteRecord> {
  const ContratoClienteRecordDocumentEquality();

  @override
  bool equals(ContratoClienteRecord? e1, ContratoClienteRecord? e2) {
    const listEquality = ListEquality();
    return e1?.documento == e2?.documento &&
        e1?.clienteRef == e2?.clienteRef &&
        listEquality.equals(e1?.contrato, e2?.contrato);
  }

  @override
  int hash(ContratoClienteRecord? e) =>
      const ListEquality().hash([e?.documento, e?.clienteRef, e?.contrato]);

  @override
  bool isValidKey(Object? o) => o is ContratoClienteRecord;
}
