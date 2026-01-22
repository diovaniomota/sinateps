import '/backend/custom_cloud_functions/custom_cloud_function_response_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'gerenciar_usuario_page_widget.dart' show GerenciarUsuarioPageWidget;
import 'package:flutter/material.dart';

class GerenciarUsuarioPageModel
    extends FlutterFlowModel<GerenciarUsuarioPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // Stores action output result for [Cloud Function - gerenciarUsuario] action in IconButton widget.
  GerenciarUsuarioCloudFunctionCallResponse? cloudFunctionAlterar;
  // Stores action output result for [Cloud Function - gerenciarUsuario] action in IconButton widget.
  GerenciarUsuarioCloudFunctionCallResponse? cloudFunctionCriar;
  // State field(s) for Nome widget.
  FocusNode? nomeFocusNode;
  TextEditingController? nomeTextController;
  String? Function(BuildContext, String?)? nomeTextControllerValidator;
  String? _nomeTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 2) {
      return 'Requires at least 2 characters.';
    }

    return null;
  }

  // State field(s) for Email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  String? _emailTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (!RegExp(kTextValidatorEmailRegex).hasMatch(val)) {
      return 'Has to be a valid email address.';
    }
    return null;
  }

  // State field(s) for RedefinirSenha widget.
  bool? redefinirSenhaValue;
  // State field(s) for NovaSenha widget.
  FocusNode? novaSenhaFocusNode;
  TextEditingController? novaSenhaTextController;
  late bool novaSenhaVisibility;
  String? Function(BuildContext, String?)? novaSenhaTextControllerValidator;
  String? _novaSenhaTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 6) {
      return 'Requires at least 6 characters.';
    }

    return null;
  }

  // State field(s) for Senha widget.
  FocusNode? senhaFocusNode;
  TextEditingController? senhaTextController;
  late bool senhaVisibility;
  String? Function(BuildContext, String?)? senhaTextControllerValidator;
  String? _senhaTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 6) {
      return 'Requires at least 6 characters.';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    nomeTextControllerValidator = _nomeTextControllerValidator;
    emailTextControllerValidator = _emailTextControllerValidator;
    novaSenhaVisibility = false;
    novaSenhaTextControllerValidator = _novaSenhaTextControllerValidator;
    senhaVisibility = false;
    senhaTextControllerValidator = _senhaTextControllerValidator;
  }

  @override
  void dispose() {
    nomeFocusNode?.dispose();
    nomeTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();

    novaSenhaFocusNode?.dispose();
    novaSenhaTextController?.dispose();

    senhaFocusNode?.dispose();
    senhaTextController?.dispose();
  }
}
