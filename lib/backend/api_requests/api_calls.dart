import 'dart:convert';

import 'package:flutter/foundation.dart';

import '/flutter_flow/flutter_flow_util.dart';
import 'api_manager.dart';

export 'api_manager.dart' show ApiCallResponse;

const _kPrivateApiFunctionName = 'ffPrivateApiCall';

/// Start ViaCep Group Code

class ViaCepGroup {
  static String getBaseUrl() => 'https://viacep.com.br/ws/';
  static Map<String, String> headers = {};
  static GetEnderecoCall getEnderecoCall = GetEnderecoCall();
}

class GetEnderecoCall {
  Future<ApiCallResponse> call({
    String? cep = '',
  }) async {
    final baseUrl = ViaCepGroup.getBaseUrl();

    return ApiManager.instance.makeApiCall(
      callName: 'getEndereco',
      apiUrl: '${baseUrl}${cep}/json',
      callType: ApiCallType.GET,
      headers: {},
      params: {},
      returnBody: true,
      encodeBodyUtf8: false,
      decodeUtf8: false,
      cache: false,
      isStreamingApi: false,
      alwaysAllowBody: false,
    );
  }

  String? logradouro(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.logradouro''',
      ));
  String? bairro(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.bairro''',
      ));
  String? localidade(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.localidade''',
      ));
  String? uf(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.uf''',
      ));
  String? estado(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.estado''',
      ));
  String? cep(dynamic response) => castToType<String>(getJsonField(
        response,
        r'''$.cep''',
      ));
}

/// End ViaCep Group Code

class ApiPagingParams {
  int nextPageNumber = 0;
  int numItems = 0;
  dynamic lastResponse;

  ApiPagingParams({
    required this.nextPageNumber,
    required this.numItems,
    required this.lastResponse,
  });

  @override
  String toString() =>
      'PagingParams(nextPageNumber: $nextPageNumber, numItems: $numItems, lastResponse: $lastResponse,)';
}

String _toEncodable(dynamic item) {
  if (item is DocumentReference) {
    return item.path;
  }
  return item;
}

String _serializeList(List? list) {
  list ??= <String>[];
  try {
    return json.encode(list, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("List serialization failed. Returning empty list.");
    }
    return '[]';
  }
}

String _serializeJson(dynamic jsonVar, [bool isList = false]) {
  jsonVar ??= (isList ? [] : {});
  try {
    return json.encode(jsonVar, toEncodable: _toEncodable);
  } catch (_) {
    if (kDebugMode) {
      print("Json serialization failed. Returning empty json.");
    }
    return isList ? '[]' : '{}';
  }
}
