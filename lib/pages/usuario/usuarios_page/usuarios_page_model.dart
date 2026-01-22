import '/components/drawer/drawer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'usuarios_page_widget.dart' show UsuariosPageWidget;
import 'package:flutter/material.dart';

class UsuariosPageModel extends FlutterFlowModel<UsuariosPageWidget> {
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
