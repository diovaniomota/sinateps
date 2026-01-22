import '/backend/backend.dart';
import '/backend/custom_cloud_functions/custom_cloud_function_response_manager.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tirar_foto_cliente_page_model.dart';
export 'tirar_foto_cliente_page_model.dart';

class TirarFotoClientePageWidget extends StatefulWidget {
  const TirarFotoClientePageWidget({
    super.key,
    required this.contrato,
  });

  final ContratoRecord? contrato;

  static String routeName = 'TirarFotoClientePage';
  static String routePath = '/tirarFotoClientePage';

  @override
  State<TirarFotoClientePageWidget> createState() =>
      _TirarFotoClientePageWidgetState();
}

class _TirarFotoClientePageWidgetState
    extends State<TirarFotoClientePageWidget> {
  late TirarFotoClientePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TirarFotoClientePageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!((widget.contrato?.signedEm == null) ||
          (widget.contrato!.signedEm! <= getCurrentTimestamp))) {
        _model.pdf = widget.contrato?.signedUrl;
        safeSetState(() {});
        return;
      }
      try {
        final result =
            await FirebaseFunctions.instanceFor(region: 'southamerica-east1')
                .httpsCallable('atualizarToken')
                .call({
          "contratoId": widget.contrato!.reference.id,
        });
        _model.cloudFunction = AtualizarTokenCloudFunctionCallResponse(
          data: result.data,
          succeeded: true,
          resultAsString: result.data.toString(),
          jsonBody: result.data,
        );
      } on FirebaseFunctionsException catch (error) {
        _model.cloudFunction = AtualizarTokenCloudFunctionCallResponse(
          errorCode: error.code,
          succeeded: false,
        );
      }

      if (_model.cloudFunction!.succeeded!) {
        await widget.contrato!.reference.update(createContratoRecordData(
          signedEm: functions.twoDaysLater(),
        ));
        _model.pdf = _model.cloudFunction?.data;
        safeSetState(() {});
      } else {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ocorreu um erro ao gerar token do PDF.',
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    font: GoogleFonts.readexPro(
                      fontWeight:
                          FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
                    color: FlutterFlowTheme.of(context).error,
                    letterSpacing: 0.0,
                    fontWeight:
                        FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                    fontStyle:
                        FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                  ),
            ),
            duration: Duration(milliseconds: 2000),
            backgroundColor: FlutterFlowTheme.of(context).alternate,
          ),
        );
        return;
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          leading: FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30.0,
            borderWidth: 1.0,
            buttonSize: 60.0,
            icon: FaIcon(
              FontAwesomeIcons.angleLeft,
              color: FlutterFlowTheme.of(context).info,
              size: 30.0,
            ),
            onPressed: () async {
              context.pop();
            },
          ),
          title: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                await launchURL(_model.pdf!);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/Design_sem_nome_(37).png',
                  width: 200.0,
                  height: 50.0,
                  fit: BoxFit.cover,
                  alignment: Alignment(0.0, 0.0),
                ),
              ),
            ),
          ),
          actions: [],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Container(
                  width: 150.0,
                  height: 200.0,
                  child: Stack(
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: Image.network(
                                valueOrDefault<String>(
                                  _model.uploadedFileUrl_uploadDataQld,
                                  'https://images.vexels.com/content/137047/preview/user-profile-blue-icon-32113c.png',
                                ),
                              ).image,
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 4.0,
                                color: Color(0x33000000),
                                offset: Offset(
                                  0.0,
                                  2.0,
                                ),
                              )
                            ],
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.0, 1.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            final selectedMedia = await selectMedia(
                              maxWidth: 350.00,
                              maxHeight: 250.00,
                              imageQuality: 100,
                              multiImage: false,
                            );
                            if (selectedMedia != null &&
                                selectedMedia.every((m) => validateFileFormat(
                                    m.storagePath, context))) {
                              safeSetState(() =>
                                  _model.isDataUploading_uploadDataQld = true);
                              var selectedUploadedFiles = <FFUploadedFile>[];

                              var downloadUrls = <String>[];
                              try {
                                selectedUploadedFiles = selectedMedia
                                    .map((m) => FFUploadedFile(
                                          name: m.storagePath.split('/').last,
                                          bytes: m.bytes,
                                          height: m.dimensions?.height,
                                          width: m.dimensions?.width,
                                          blurHash: m.blurHash,
                                          originalFilename: m.originalFilename,
                                        ))
                                    .toList();

                                downloadUrls = (await Future.wait(
                                  selectedMedia.map(
                                    (m) async => await uploadData(
                                        m.storagePath, m.bytes),
                                  ),
                                ))
                                    .where((u) => u != null)
                                    .map((u) => u!)
                                    .toList();
                              } finally {
                                _model.isDataUploading_uploadDataQld = false;
                              }
                              if (selectedUploadedFiles.length ==
                                      selectedMedia.length &&
                                  downloadUrls.length == selectedMedia.length) {
                                safeSetState(() {
                                  _model.uploadedLocalFile_uploadDataQld =
                                      selectedUploadedFiles.first;
                                  _model.uploadedFileUrl_uploadDataQld =
                                      downloadUrls.first;
                                });
                              } else {
                                safeSetState(() {});
                                return;
                              }
                            }

                            if (_model.uploadedFileUrl_uploadDataQld != '') {
                              _model.prosseguir = true;
                              safeSetState(() {});
                            } else {
                              return;
                            }
                          },
                          child: Icon(
                            Icons.monochrome_photos,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 50.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_model.prosseguir)
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      context.pushNamed(
                        AssinaturaPageWidget.routeName,
                        queryParameters: {
                          'contrato': serializeParam(
                            widget.contrato,
                            ParamType.Document,
                          ),
                          'fotoCliente': serializeParam(
                            _model.uploadedFileUrl_uploadDataQld,
                            ParamType.String,
                          ),
                        }.withoutNulls,
                        extra: <String, dynamic>{
                          'contrato': widget.contrato,
                        },
                      );
                    },
                    text: 'Ir para Assinatura',
                    options: FFButtonOptions(
                      height: 40.0,
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
                      iconPadding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).titleSmall.override(
                                font: GoogleFonts.readexPro(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .fontStyle,
                                ),
                                color: Colors.white,
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .fontStyle,
                              ),
                      elevation: 0.0,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
