import '/components/drawer/drawer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'contratos_page_widget.dart' show ContratosPageWidget;
import 'package:flutter/material.dart';

class ContratosPageModel extends FlutterFlowModel<ContratosPageWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PesquisarPorCidade widget.
  FocusNode? pesquisarPorCidadeFocusNode;
  TextEditingController? pesquisarPorCidadeTextController;
  String? Function(BuildContext, String?)?
      pesquisarPorCidadeTextControllerValidator;
  // Model for Drawer component.
  late DrawerModel drawerModel;

  @override
  void initState(BuildContext context) {
    drawerModel = createModel(context, () => DrawerModel());
  }

  @override
  void dispose() {
    pesquisarPorCidadeFocusNode?.dispose();
    pesquisarPorCidadeTextController?.dispose();

    drawerModel.dispose();
  }
}
