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
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:signature/signature.dart';
import 'assinatura_page_model.dart';
export 'assinatura_page_model.dart';

class AssinaturaPageWidget extends StatefulWidget {
  const AssinaturaPageWidget({
    super.key,
    required this.contrato,
    this.fotoCliente,
  });

  final ContratoRecord? contrato;
  final String? fotoCliente;

  static String routeName = 'AssinaturaPage';
  static String routePath = '/assinaturaPage';

  @override
  State<AssinaturaPageWidget> createState() => _AssinaturaPageWidgetState();
}

class _AssinaturaPageWidgetState extends State<AssinaturaPageWidget> {
  late AssinaturaPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AssinaturaPageModel());

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
          actions: [
            Visibility(
              visible: !widget.contrato!.hasAssinatura(),
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: FlutterFlowIconButton(
                    borderRadius: 20.0,
                    borderWidth: 0.0,
                    buttonSize: 40.0,
                    icon: FaIcon(
                      FontAwesomeIcons.broom,
                      color: FlutterFlowTheme.of(context).info,
                      size: 24.0,
                    ),
                    onPressed: () async {
                      safeSetState(() {
                        _model.assinaturaController?.clear();
                      });
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'LIMPO',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                          duration: Duration(milliseconds: 1000),
                          backgroundColor:
                              FlutterFlowTheme.of(context).alternate,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: Align(
          alignment: AlignmentDirectional(0.0, 0.0),
          child: Container(
            decoration: BoxDecoration(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Wrap(
                      spacing: 0.0,
                      runSpacing: 0.0,
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      runAlignment: WrapAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      clipBehavior: Clip.none,
                      children: [
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Text(
                            'Assinatura',
                            style: FlutterFlowTheme.of(context)
                                .titleMedium
                                .override(
                                  font: GoogleFonts.readexPro(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context).primary,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .fontStyle,
                                ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 30.0, 0.0, 0.0),
                            child: Material(
                              color: Colors.transparent,
                              elevation: 1.0,
                              child: ClipRRect(
                                child: Container(
                                  width: 300.0,
                                  height: 546.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .secondaryBackground,
                                    border: Border.all(
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      width: 3.0,
                                    ),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Builder(
                                    builder: (context) {
                                      if (widget.contrato?.hasAssinatura() ??
                                          false) {
                                        return Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: CachedNetworkImage(
                                            fadeInDuration:
                                                Duration(milliseconds: 500),
                                            fadeOutDuration:
                                                Duration(milliseconds: 500),
                                            imageUrl:
                                                widget.contrato!.assinatura,
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.contain,
                                          ),
                                        );
                                      } else {
                                        return Stack(
                                          children: [
                                            ClipRect(
                                              child: Signature(
                                                controller: _model
                                                        .assinaturaController ??=
                                                    SignatureController(
                                                  penStrokeWidth: 2.0,
                                                  penColor: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  exportBackgroundColor:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .info,
                                                ),
                                                backgroundColor:
                                                    FlutterFlowTheme.of(context)
                                                        .alternate,
                                                height: double.infinity,
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(16.0),
                                              child: Container(
                                                width: 2.0,
                                                height: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primary,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (!widget.contrato!.hasAssinatura())
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 30.0, 0.0, 0.0),
                              child: FFButtonWidget(
                                onPressed: () async {
                                  var _shouldSetState = false;
                                  final signatureImage = await _model
                                      .assinaturaController!
                                      .toPngBytes();
                                  if (signatureImage == null) {
                                    showUploadMessage(
                                      context,
                                      'Signature is empty.',
                                    );
                                    return;
                                  }
                                  showUploadMessage(
                                    context,
                                    'Uploading signature...',
                                    showLoading: true,
                                  );
                                  final downloadUrl = (await uploadData(
                                      getSignatureStoragePath(),
                                      signatureImage));

                                  ScaffoldMessenger.of(context)
                                      .hideCurrentSnackBar();
                                  if (downloadUrl != null) {
                                    safeSetState(() => _model
                                        .uploadedSignatureUrl = downloadUrl);
                                    showUploadMessage(
                                      context,
                                      'Success!',
                                    );
                                  } else {
                                    showUploadMessage(
                                      context,
                                      'Failed to upload signature.',
                                    );
                                    return;
                                  }

                                  await widget.contrato!.reference
                                      .update(createContratoRecordData(
                                    assinatura: _model.uploadedSignatureUrl,
                                    assinadoEm: getCurrentTimestamp,
                                    tipo: 'Presencial',
                                    fotoCliente: widget.fotoCliente,
                                    contratoAssinado: true,
                                    qrCode:
                                        'https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=https://sinatepassinatura.flutterflow.app/',
                                    urlLink:
                                        'https://sinatepassinatura.flutterflow.app/',
                                    dtAssinado: functions
                                        .funRetornaHoras(getCurrentTimestamp),
                                  ));
                                  try {
                                    await FirebaseFunctions.instanceFor(
                                                region: 'southamerica-east1')
                                            .httpsCallable('assinarContrato')
                                            .call({
                                      "contratoId":
                                          widget.contrato!.reference.id,
                                    });
                                    _model.cloudFunction =
                                        AssinarContratoCloudFunctionCallResponse(
                                      succeeded: true,
                                    );
                                  } on FirebaseFunctionsException catch (error) {
                                    _model.cloudFunction =
                                        AssinarContratoCloudFunctionCallResponse(
                                      errorCode: error.code,
                                      succeeded: false,
                                    );
                                  }

                                  _shouldSetState = true;
                                  if (_model.cloudFunction!.succeeded!) {
                                    try {
                                      await FirebaseFunctions.instanceFor(
                                                  region: 'southamerica-east1')
                                              .httpsCallable('fotoCliente')
                                              .call({
                                        "contratoId":
                                            widget.contrato!.reference.id,
                                      });
                                      _model.cloudFunction2 =
                                          FotoClienteCloudFunctionCallResponse(
                                        succeeded: true,
                                      );
                                    } on FirebaseFunctionsException catch (error) {
                                      _model.cloudFunction2 =
                                          FotoClienteCloudFunctionCallResponse(
                                        errorCode: error.code,
                                        succeeded: false,
                                      );
                                    }

                                    _shouldSetState = true;
                                    if (_model.cloudFunction2!.succeeded!) {
                                      try {
                                        await FirebaseFunctions.instanceFor(
                                                    region:
                                                        'southamerica-east1')
                                                .httpsCallable('escreveIp')
                                                .call({
                                          "contratoId":
                                              widget.contrato!.reference.id,
                                        });
                                        _model.cloudFunction3 =
                                            EscreveIpCloudFunctionCallResponse(
                                          succeeded: true,
                                        );
                                      } on FirebaseFunctionsException catch (error) {
                                        _model.cloudFunction3 =
                                            EscreveIpCloudFunctionCallResponse(
                                          errorCode: error.code,
                                          succeeded: false,
                                        );
                                      }

                                      _shouldSetState = true;
                                      if (_model.cloudFunction3!.succeeded!) {
                                        context.pushNamed(
                                          VerContratoPageWidget.routeName,
                                          queryParameters: {
                                            'contrato': serializeParam(
                                              widget.contrato,
                                              ParamType.Document,
                                            ),
                                            'contratoAssinado': serializeParam(
                                              true,
                                              ParamType.bool,
                                            ),
                                          }.withoutNulls,
                                          extra: <String, dynamic>{
                                            'contrato': widget.contrato,
                                          },
                                        );

                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .clearSnackBars();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Ocorreu um erro ao assinar contrato.',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.readexPro(
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .error,
                                                    letterSpacing: 0.0,
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 2000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .alternate,
                                          ),
                                        );
                                        if (_shouldSetState)
                                          safeSetState(() {});
                                        return;
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .clearSnackBars();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Ocorreu um erro ao assinar contrato.',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.readexPro(
                                                    fontWeight:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontWeight,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .error,
                                                  letterSpacing: 0.0,
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          duration:
                                              Duration(milliseconds: 2000),
                                          backgroundColor:
                                              FlutterFlowTheme.of(context)
                                                  .alternate,
                                        ),
                                      );
                                      if (_shouldSetState) safeSetState(() {});
                                      return;
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .clearSnackBars();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Ocorreu um erro ao assinar contrato.',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.readexPro(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .error,
                                                letterSpacing: 0.0,
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                        duration: Duration(milliseconds: 2000),
                                        backgroundColor:
                                            FlutterFlowTheme.of(context)
                                                .alternate,
                                      ),
                                    );
                                    if (_shouldSetState) safeSetState(() {});
                                    return;
                                  }

                                  if (_shouldSetState) safeSetState(() {});
                                },
                                text: 'Confirmar',
                                options: FFButtonOptions(
                                  width: MediaQuery.sizeOf(context).width * 0.6,
                                  height: 40.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      24.0, 0.0, 24.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleSmall
                                      .override(
                                        font: GoogleFonts.readexPro(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleSmall
                                                  .fontStyle,
                                        ),
                                        color:
                                            FlutterFlowTheme.of(context).info,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                  elevation: 2.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ].divide(SizedBox(height: 24.0)).around(SizedBox(height: 24.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
