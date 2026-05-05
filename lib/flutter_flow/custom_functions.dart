import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/backend.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

DateTime twoDaysLater() {
  return DateTime.now().add(const Duration(days: 2));
}

String funRetornaNome(String nomeTxt) {
  // retorne apenas o primeiro e o ultimo nome sendo ele o nome e sobrenome
  List<String> nomes = nomeTxt.split(" ");
  if (nomes.length >= 2) {
    return "${nomes.first} ${nomes.last}";
  } else {
    return nomeTxt;
  }
}

String funRetornaHoras(DateTime current) {
  // Converte o DateTime para o fuso horário local (se necessário)
  final brDateTime = current.toLocal();

  // Formata a data e hora no padrão desejado: "21 de novembro de 2024 às 23:37"
  final formattedDate = DateFormat("d 'de' MMMM 'de' yyyy 'às' HH:mm", 'pt_BR')
      .format(brDateTime);

  // Retorna a data formatada
  return formattedDate;
}

String autentiqueFeedbackMessage(
  String? deliveryMethodUsed,
  bool fallbackUsed,
  String? emailAluno,
  String? whatsappAluno,
) {
  final email = (emailAluno ?? '').trim();
  final whatsapp = (whatsappAluno ?? '').trim();

  if (fallbackUsed && email.isNotEmpty) {
    return 'WhatsApp nao aceito pela Autentique. O contrato foi enviado por email para $email.';
  }

  if (deliveryMethodUsed == 'whatsapp' && whatsapp.isNotEmpty) {
    return 'Contrato criado na Autentique. O envio foi solicitado via WhatsApp para $whatsapp.';
  }

  if (deliveryMethodUsed == 'email' && email.isNotEmpty) {
    return 'Contrato criado na Autentique. O envio foi solicitado por email para $email.';
  }

  return 'Contrato criado na Autentique com sucesso.';
}

String prettyJson(dynamic value) {
  try {
    return const JsonEncoder.withIndent('  ').convert(value);
  } catch (_) {
    return value?.toString() ?? '';
  }
}
