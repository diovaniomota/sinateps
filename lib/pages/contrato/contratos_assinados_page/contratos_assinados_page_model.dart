import '/components/drawer/drawer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'contratos_assinados_page_widget.dart' show ContratosAssinadosPageWidget;
import 'package:flutter/material.dart';

class ContratosAssinadosPageModel
    extends FlutterFlowModel<ContratosAssinadosPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Drawer component.
  late DrawerModel drawerModel;

  @override
  void initState(BuildContext context) {
    drawerModel = createModel(context, () => DrawerModel());
  }

  @override
  void dispose() {
    drawerModel.dispose();
  }
}
