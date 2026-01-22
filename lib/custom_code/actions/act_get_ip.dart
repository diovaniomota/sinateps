// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:io';

Future<String> actGetIp() async {
  // Obtém o endereço IP de rede
  try {
    // Itera sobre as interfaces de rede disponíveis
    for (var interface in await NetworkInterface.list()) {
      // Verifica os endereços dentro de cada interface
      for (var addr in interface.addresses) {
        // Retorna o endereço IPv4 que não é local
        if (addr.type == InternetAddressType.IPv4 && !addr.isLinkLocal) {
          return addr.address;
        }
      }
    }
    // Se não encontrou nenhum IP, retorna uma mensagem
    return 'IP não encontrado';
  } catch (e) {
    // Retorna uma mensagem de erro caso ocorra algum problema
    return 'Erro ao obter IP: $e';
  }
}
