import '/backend/backend.dart';
import '/backend/custom_cloud_functions/custom_cloud_function_response_manager.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_pdf_viewer.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'ver_contrato_page_link_model.dart';
export 'ver_contrato_page_link_model.dart';

class VerContratoPageLinkWidget extends StatefulWidget {
  const VerContratoPageLinkWidget({
    super.key,
    required this.contrato,
  });

  final ContratoRecord? contrato;

  static String routeName = 'VerContratoPageLink';
  static String routePath = '/verContratoPageLink';

  @override
  State<VerContratoPageLinkWidget> createState() =>
      _VerContratoPageLinkWidgetState();
}

class _VerContratoPageLinkWidgetState extends State<VerContratoPageLinkWidget> {
  late VerContratoPageLinkModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerContratoPageLinkModel());

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
          actions: [
            Visibility(
              visible: _model.pdf != null && _model.pdf != '',
              child: Align(
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Builder(
                  builder: (context) => Padding(
                    padding: EdgeInsets.all(8.0),
                    child: FlutterFlowIconButton(
                      borderRadius: 20.0,
                      borderWidth: 1.0,
                      buttonSize: 40.0,
                      icon: FaIcon(
                        FontAwesomeIcons.share,
                        color: FlutterFlowTheme.of(context).info,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        await Share.share(
                          _model.pdf!,
                          sharePositionOrigin: getWidgetBoundingBox(context),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 2.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Contrato',
                style: FlutterFlowTheme.of(context).titleMedium.override(
                      font: GoogleFonts.readexPro(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primary,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).titleMedium.fontStyle,
                    ),
              ),
              Container(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.8,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).alternate,
                  borderRadius: BorderRadius.circular(9.0),
                  shape: BoxShape.rectangle,
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Builder(
                  builder: (context) {
                    if (_model.pdf != null && _model.pdf != '') {
                      return FlutterFlowPdfViewer(
                        networkPath: _model.pdf!,
                        width: double.infinity,
                        height: double.infinity,
                        horizontalScroll: true,
                      );
                    } else {
                      return Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          'Sem PDF',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.readexPro(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(32.0, 16.0, 32.0, 16.0),
                child: Text(
                  'Deslize para o lado para acessar a próxima página.',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight:
                              FlutterFlowTheme.of(context).bodySmall.fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodySmall.fontStyle,
                        ),
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).bodySmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodySmall.fontStyle,
                      ),
                ),
              ),
              FFButtonWidget(
                onPressed: () async {
                  if (Navigator.of(context).canPop()) {
                    context.pop();
                  }
                  context.pushNamed(
                    RegistrarContratoPageWidget.routeName,
                    queryParameters: {
                      'contrato': serializeParam(
                        widget.contrato,
                        ParamType.Document,
                      ),
                    }.withoutNulls,
                    extra: <String, dynamic>{
                      'contrato': widget.contrato,
                    },
                  );
                },
                text: 'Editar',
                options: FFButtonOptions(
                  width: 250.0,
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).tertiary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).info,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 2.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              FFButtonWidget(
                onPressed: () async {
                  context.pushNamed(
                    AssinaturaPageWidget.routeName,
                    queryParameters: {
                      'contrato': serializeParam(
                        widget.contrato,
                        ParamType.Document,
                      ),
                    }.withoutNulls,
                    extra: <String, dynamic>{
                      'contrato': widget.contrato,
                    },
                  );
                },
                text: 'Ver Assinar',
                options: FFButtonOptions(
                  width: 250.0,
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).info,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 2.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              FFButtonWidget(
                onPressed: () async {
                  var _shouldSetState = false;
                  if (_model.confirmarDeletar) {
                    await widget.contrato!.reference.delete();
                    try {
                      await FirebaseFunctions.instanceFor(
                              region: 'southamerica-east1')
                          .httpsCallable('deletarPDF')
                          .call({
                        "contratoId": widget.contrato!.reference.id,
                      });
                      _model.cloudFunctionzyl =
                          DeletarPDFCloudFunctionCallResponse(
                        succeeded: true,
                      );
                    } on FirebaseFunctionsException catch (error) {
                      _model.cloudFunctionzyl =
                          DeletarPDFCloudFunctionCallResponse(
                        errorCode: error.code,
                        succeeded: false,
                      );
                    }

                    _shouldSetState = true;
                    if (!_model.cloudFunctionzyl!.succeeded!) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Ocorreu um erro ao deletar PDF.',
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
                                  color: FlutterFlowTheme.of(context).error,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                          duration: Duration(milliseconds: 2000),
                          backgroundColor:
                              FlutterFlowTheme.of(context).alternate,
                        ),
                      );
                      if (_shouldSetState) safeSetState(() {});
                      return;
                    }
                  } else {
                    _model.confirmarDeletar = true;
                    safeSetState(() {});
                    if (_shouldSetState) safeSetState(() {});
                    return;
                  }

                  context.safePop();
                  if (_shouldSetState) safeSetState(() {});
                },
                text:
                    _model.confirmarDeletar ? 'Confirmar' : 'Deletar Contrato',
                options: FFButtonOptions(
                  width: 250.0,
                  height: 40.0,
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                  iconPadding:
                      EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                  color: valueOrDefault<Color>(
                    _model.confirmarDeletar
                        ? FlutterFlowTheme.of(context).tertiary
                        : FlutterFlowTheme.of(context).error,
                    FlutterFlowTheme.of(context).error,
                  ),
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        font: GoogleFonts.readexPro(
                          fontWeight: FlutterFlowTheme.of(context)
                              .titleSmall
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).titleSmall.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).info,
                        fontSize: 18.0,
                        letterSpacing: 0.0,
                        fontWeight:
                            FlutterFlowTheme.of(context).titleSmall.fontWeight,
                        fontStyle:
                            FlutterFlowTheme.of(context).titleSmall.fontStyle,
                      ),
                  elevation: 2.0,
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ].divide(SizedBox(height: 24.0)).around(SizedBox(height: 24.0)),
          ),
        ),
      ),
    );
  }
}
