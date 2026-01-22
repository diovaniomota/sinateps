import 'package:flutter/material.dart';
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {}

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  Cep1Struct _cep = Cep1Struct();
  Cep1Struct get cep => _cep;
  set cep(Cep1Struct value) {
    _cep = value;
  }

  void updateCepStruct(Function(Cep1Struct) updateFn) {
    updateFn(_cep);
  }

  String _varLogradouro = '';
  String get varLogradouro => _varLogradouro;
  set varLogradouro(String value) {
    _varLogradouro = value;
  }

  String _varBairro = '';
  String get varBairro => _varBairro;
  set varBairro(String value) {
    _varBairro = value;
  }

  String _varCidade = '';
  String get varCidade => _varCidade;
  set varCidade(String value) {
    _varCidade = value;
  }

  String _varUF = '';
  String get varUF => _varUF;
  set varUF(String value) {
    _varUF = value;
  }
}
