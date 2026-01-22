import '/backend/custom_cloud_functions/custom_cloud_function_response_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'tirar_foto_cliente_page_widget.dart' show TirarFotoClientePageWidget;
import 'package:flutter/material.dart';

class TirarFotoClientePageModel
    extends FlutterFlowModel<TirarFotoClientePageWidget> {
  ///  Local state fields for this page.

  String? pdf;

  bool confirmarDeletar = false;

  bool prosseguir = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Cloud Function - atualizarToken] action in TirarFotoClientePage widget.
  AtualizarTokenCloudFunctionCallResponse? cloudFunction;
  bool isDataUploading_uploadDataQld = false;
  FFUploadedFile uploadedLocalFile_uploadDataQld =
      FFUploadedFile(bytes: Uint8List.fromList([]), originalFilename: '');
  String uploadedFileUrl_uploadDataQld = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
