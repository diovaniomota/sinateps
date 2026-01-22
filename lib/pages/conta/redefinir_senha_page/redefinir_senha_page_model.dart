import '/flutter_flow/flutter_flow_util.dart';
import 'redefinir_senha_page_widget.dart' show RedefinirSenhaPageWidget;
import 'package:flutter/material.dart';

class RedefinirSenhaPageModel
    extends FlutterFlowModel<RedefinirSenhaPageWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
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

  // State field(s) for ConfirmarSenha widget.
  FocusNode? confirmarSenhaFocusNode;
  TextEditingController? confirmarSenhaTextController;
  late bool confirmarSenhaVisibility;
  String? Function(BuildContext, String?)?
      confirmarSenhaTextControllerValidator;
  String? _confirmarSenhaTextControllerValidator(
      BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Field is required';
    }

    if (val.length < 6) {
      return 'Requires at least 6 characters.';
    }

    return null;
  }

  // Stores action output result for [Custom Action - updatePassword] action in Enviar widget.
  bool? sucesso;

  @override
  void initState(BuildContext context) {
    novaSenhaVisibility = false;
    novaSenhaTextControllerValidator = _novaSenhaTextControllerValidator;
    confirmarSenhaVisibility = false;
    confirmarSenhaTextControllerValidator =
        _confirmarSenhaTextControllerValidator;
  }

  @override
  void dispose() {
    novaSenhaFocusNode?.dispose();
    novaSenhaTextController?.dispose();

    confirmarSenhaFocusNode?.dispose();
    confirmarSenhaTextController?.dispose();
  }
}
