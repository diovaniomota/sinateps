import '/backend/custom_cloud_functions/custom_cloud_function_response_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'assinatura_page_widget.dart' show AssinaturaPageWidget;
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

class AssinaturaPageModel extends FlutterFlowModel<AssinaturaPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for Assinatura widget.
  SignatureController? assinaturaController;
  String uploadedSignatureUrl = '';
  // Stores action output result for [Cloud Function - assinarContrato] action in Button widget.
  AssinarContratoCloudFunctionCallResponse? cloudFunction;
  // Stores action output result for [Cloud Function - fotoCliente] action in Button widget.
  FotoClienteCloudFunctionCallResponse? cloudFunction2;
  // Stores action output result for [Cloud Function - escreveIp] action in Button widget.
  EscreveIpCloudFunctionCallResponse? cloudFunction3;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    assinaturaController?.dispose();
  }
}
