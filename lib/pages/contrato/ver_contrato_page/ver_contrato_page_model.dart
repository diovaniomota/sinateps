import '/backend/custom_cloud_functions/custom_cloud_function_response_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'ver_contrato_page_widget.dart' show VerContratoPageWidget;
import 'package:flutter/material.dart';

class VerContratoPageModel extends FlutterFlowModel<VerContratoPageWidget> {
  ///  Local state fields for this page.

  String? pdf;

  bool confirmarDeletar = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;

  // State field(s) for whatsapp widget.
  FocusNode? whatsappFocusNode;
  TextEditingController? whatsappTextController;
  String? Function(BuildContext, String?)? whatsappTextControllerValidator;

  // Stores action output result for [Cloud Function - atualizarToken] action in VerContratoPage widget.
  AtualizarTokenCloudFunctionCallResponse? cloudFunction;
  // Stores action output result for [Cloud Function - deletarPDF] action in Button widget.
  DeletarPDFCloudFunctionCallResponse? cloudFunctionzyl;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    emailFocusNode?.dispose();
    emailTextController?.dispose();

    whatsappFocusNode?.dispose();
    whatsappTextController?.dispose();
  }
}
