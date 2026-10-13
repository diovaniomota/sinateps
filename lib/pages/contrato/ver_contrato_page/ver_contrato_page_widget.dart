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
import 'package:google_fonts/google_fonts.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:share_plus/share_plus.dart';
import 'ver_contrato_page_model.dart';
export 'ver_contrato_page_model.dart';

class VerContratoPageWidget extends StatefulWidget {
  const VerContratoPageWidget({
    super.key,
    required this.contrato,
    bool? contratoAssinado,
    bool? contratoTestemunha,
    this.nomeTxt,
  })  : this.contratoAssinado = contratoAssinado ?? false,
        this.contratoTestemunha = contratoTestemunha ?? false;

  final ContratoRecord? contrato;
  final bool contratoAssinado;
  final bool contratoTestemunha;
  final String? nomeTxt;

  static String routeName = 'VerContratoPage';
  static String routePath = '/verContratoPage';

  @override
  State<VerContratoPageWidget> createState() => _VerContratoPageWidgetState();
}

class _VerContratoPageWidgetState extends State<VerContratoPageWidget> {
  late VerContratoPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> _showAutentiqueResponseDialog({
    required String title,
    required Map<String, dynamic> payload,
  }) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (dialogContext) => Dialog(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 640.0,
            maxHeight: MediaQuery.sizeOf(dialogContext).height * 0.75,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: FlutterFlowTheme.of(dialogContext).titleSmall,
                ),
                const SizedBox(height: 12.0),
                Flexible(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      functions.prettyJson(payload),
                      style: FlutterFlowTheme.of(dialogContext).bodyMedium,
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Navigator.of(dialogContext).pop(),
                    child: const Text('Fechar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerContratoPageModel());

    _model.emailTextController ??=
        TextEditingController(text: widget.contrato?.email);
    _model.emailFocusNode ??= FocusNode();

    _model.whatsappTextController ??=
        TextEditingController(text: widget.contrato?.alunoTelefone);
    _model.whatsappFocusNode ??= FocusNode();

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
                    font: GoogleFonts.notoSans(
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

  InputDecoration _contactInputDecoration(
    BuildContext context, {
    required String label,
    String? hint,
    required IconData icon,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: theme.labelMedium.override(
        font: GoogleFonts.notoSans(
          fontWeight: FontWeight.w600,
          fontStyle: theme.labelMedium.fontStyle,
        ),
        color: theme.secondaryText,
        letterSpacing: 0.0,
      ),
      hintStyle: theme.labelMedium.override(
        font: GoogleFonts.notoSans(
          fontWeight: FontWeight.w500,
          fontStyle: theme.labelMedium.fontStyle,
        ),
        color: theme.secondaryText,
        letterSpacing: 0.0,
      ),
      prefixIcon: Icon(
        icon,
        color: theme.secondaryText,
        size: 20.0,
      ),
      filled: true,
      fillColor: theme.secondaryBackground,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.alternate,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(14.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.primary,
          width: 1.4,
        ),
        borderRadius: BorderRadius.circular(14.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.error,
          width: 1.2,
        ),
        borderRadius: BorderRadius.circular(14.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.error,
          width: 1.4,
        ),
        borderRadius: BorderRadius.circular(14.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 18.0,
      ),
    );
  }

  FFButtonOptions _actionButtonOptions(
    BuildContext context, {
    required Color color,
    required Color textColor,
    Color? iconColor,
    Color? hoverColor,
  }) {
    final theme = FlutterFlowTheme.of(context);
    return FFButtonOptions(
      width: double.infinity,
      height: 54.0,
      padding: const EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
      iconPadding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 8.0, 0.0),
      iconColor: iconColor ?? textColor,
      color: color,
      hoverColor: hoverColor,
      hoverTextColor: textColor,
      hoverElevation: 0.0,
      textStyle: theme.titleSmall.override(
        font: GoogleFonts.notoSans(
          fontWeight: FontWeight.w800,
          fontStyle: theme.titleSmall.fontStyle,
        ),
        color: textColor,
        letterSpacing: 0.0,
      ),
      elevation: 0.0,
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(14.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final hasPdf = _model.pdf != null && _model.pdf != '';
    final previewHeight = (MediaQuery.sizeOf(context).height * 0.56)
        .clamp(320.0, 640.0)
        .toDouble();
    final contractTitle =
        widget.nomeTxt ?? widget.contrato?.contratante ?? 'Contrato';

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        appBar: AppBar(
          backgroundColor: theme.secondaryBackground,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0.0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.primaryText),
            onPressed: () => context.pop(),
          ),
          title: Image.asset(
            'assets/images/sinatep_logo_color.png',
            height: 28.0,
            fit: BoxFit.contain,
          ),
          actions: [
            if (hasPdf)
              Align(
                alignment: AlignmentDirectional.center,
                child: Builder(
                  builder: (context) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlutterFlowIconButton(
                      borderColor: theme.alternate,
                      borderRadius: 14.0,
                      borderWidth: 1.0,
                      fillColor: theme.secondaryBackground,
                      buttonSize: 48.0,
                      icon: Icon(
                        Icons.share_rounded,
                        color: theme.primaryText,
                        size: 20.0,
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
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: theme.primaryBackground,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 32.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0F1B2836),
                            blurRadius: 16.0,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            contractTitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.headlineSmall,
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            widget.contratoAssinado
                                ? 'Assinado'
                                : hasPdf
                                    ? 'PDF pronto'
                                    : 'PDF em preparação',
                            style: theme.bodyMedium.override(
                              color: widget.contratoAssinado
                                  ? theme.success
                                  : theme.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(color: theme.alternate),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Prévia do contrato',
                                      style: theme.titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                              if (hasPdf) const SizedBox(width: 12.0),
                              if (hasPdf)
                                InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await launchURL(_model.pdf!);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: theme.accent1,
                                      borderRadius: BorderRadius.circular(14.0),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0,
                                      vertical: 12.0,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.open_in_new_rounded,
                                          color: theme.primary,
                                          size: 18.0,
                                        ),
                                        const SizedBox(width: 8.0),
                                        Text(
                                          'Abrir PDF',
                                          style: theme.labelLarge.override(
                                            font: GoogleFonts.notoSans(
                                              fontWeight: FontWeight.w800,
                                              fontStyle:
                                                  theme.labelLarge.fontStyle,
                                            ),
                                            color: theme.primary,
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Container(
                            width: double.infinity,
                            height: previewHeight,
                            decoration: BoxDecoration(
                              color: theme.accent4,
                              borderRadius: BorderRadius.circular(14.0),
                              border: Border.all(color: theme.alternate),
                            ),
                            alignment: AlignmentDirectional.center,
                            child: Builder(
                              builder: (context) {
                                if (hasPdf) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(14.0),
                                    child: FlutterFlowPdfViewer(
                                      networkPath: _model.pdf!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      horizontalScroll: true,
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: const EdgeInsets.all(28.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 58.0,
                                          height: 58.0,
                                          decoration: BoxDecoration(
                                            color: theme.accent1,
                                            borderRadius:
                                                BorderRadius.circular(14.0),
                                          ),
                                          child: Icon(
                                            Icons.picture_as_pdf_outlined,
                                            color: theme.primary,
                                            size: 28.0,
                                          ),
                                        ),
                                        const SizedBox(height: 14.0),
                                        Text(
                                          'PDF ainda não disponível',
                                          style: theme.titleMedium.override(
                                            font: GoogleFonts.notoSans(
                                              fontWeight: FontWeight.w800,
                                              fontStyle:
                                                  theme.titleMedium.fontStyle,
                                            ),
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Assim que o link do documento estiver pronto, a visualização aparecerá aqui.',
                                          textAlign: TextAlign.center,
                                          style: theme.bodyMedium.override(
                                            font: GoogleFonts.notoSans(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  theme.bodyMedium.fontStyle,
                                            ),
                                            color: theme.secondaryText,
                                            letterSpacing: 0.0,
                                            lineHeight: 1.35,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(height: 14.0),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.accent4,
                              borderRadius: BorderRadius.circular(14.0),
                            ),
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.swipe_rounded,
                                  color: theme.primary,
                                  size: 20.0,
                                ),
                                const SizedBox(width: 10.0),
                                Expanded(
                                  child: Text(
                                    'Deslize para o lado para acessar a próxima página. Em navegadores sem suporte à prévia, toque em \"Abrir PDF\".',
                                    style: theme.bodyMedium.override(
                                      font: GoogleFonts.notoSans(
                                        fontWeight: FontWeight.w700,
                                        fontStyle: theme.bodyMedium.fontStyle,
                                      ),
                                      color: theme.primaryText,
                                      letterSpacing: 0.0,
                                      lineHeight: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18.0),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(color: theme.alternate),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ações do contrato',
                            style: theme.titleMedium,
                          ),
                          const SizedBox(height: 18.0),
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
                            text: 'Editar contrato',
                            icon: const Icon(
                              Icons.edit_outlined,
                              size: 18.0,
                            ),
                            options: _actionButtonOptions(
                              context,
                              color: theme.tertiary,
                              textColor: theme.info,
                              hoverColor: theme.secondary,
                            ),
                          ),
                          const SizedBox(height: 18.0),
                          Text(
                            'Contato para envio',
                            style: theme.labelLarge.override(
                              font: GoogleFonts.notoSans(
                                fontWeight: FontWeight.w800,
                                fontStyle: theme.labelLarge.fontStyle,
                              ),
                              color: theme.primary,
                              letterSpacing: 0.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          TextFormField(
                            controller: _model.emailTextController,
                            focusNode: _model.emailFocusNode,
                            autofocus: false,
                            obscureText: false,
                            decoration: _contactInputDecoration(
                              context,
                              label: 'Email do aluno',
                              hint: 'exemplo@dominio.com',
                              icon: Icons.alternate_email_rounded,
                            ),
                            style: theme.bodyMedium.override(
                              font: GoogleFonts.notoSans(
                                fontWeight: FontWeight.w600,
                                fontStyle: theme.bodyMedium.fontStyle,
                              ),
                              letterSpacing: 0.0,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: _model.emailTextControllerValidator
                                .asValidator(context),
                          ),
                          const SizedBox(height: 12.0),
                          TextFormField(
                            controller: _model.whatsappTextController,
                            focusNode: _model.whatsappFocusNode,
                            autofocus: false,
                            obscureText: false,
                            decoration: _contactInputDecoration(
                              context,
                              label: 'WhatsApp do aluno (opcional)',
                              hint: 'Ex: (11) 9 9999-9999',
                              icon: Icons.phone_rounded,
                            ),
                            style: theme.bodyMedium.override(
                              font: GoogleFonts.notoSans(
                                fontWeight: FontWeight.w600,
                                fontStyle: theme.bodyMedium.fontStyle,
                              ),
                              letterSpacing: 0.0,
                            ),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              MaskTextInputFormatter(
                                mask: '(##) # ####-####',
                                filter: {"#": RegExp(r'[0-9]')},
                                type: MaskAutoCompletionType.lazy,
                              )
                            ],
                            validator: _model.whatsappTextControllerValidator
                                .asValidator(context),
                          ),
                          if (!widget.contratoAssinado)
                            FFButtonWidget(
                              onPressed: () async {
                                if (_model.emailTextController.text.isEmpty &&
                                    _model
                                        .whatsappTextController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Por favor, informe o email ou o WhatsApp do aluno.'),
                                    ),
                                  );
                                  return;
                                }
                                try {
                                  final response =
                                      await FirebaseFunctions.instanceFor(
                                              region: 'southamerica-east1')
                                          .httpsCallable(
                                              'enviarContratoAutentique')
                                          .call({
                                    "contratoId": widget.contrato!.reference.id,
                                    "emailAluno":
                                        _model.emailTextController.text.trim(),
                                    "whatsappAluno": _model
                                        .whatsappTextController.text
                                        .trim(),
                                  });

                                  final responseData = response.data is Map
                                      ? Map<String, dynamic>.from(
                                          response.data as Map)
                                      : <String, dynamic>{};

                                  if (responseData['success'] == false) {
                                    throw Exception(responseData['message'] ??
                                        'Erro ao enviar contrato para Autentique.');
                                  }

                                  final successMessage =
                                      functions.autentiqueFeedbackMessage(
                                    responseData['deliveryMethodUsed']
                                        as String?,
                                    responseData['fallbackUsed'] == true,
                                    responseData['emailAluno'] as String?,
                                    responseData['whatsappAluno'] as String?,
                                  );

                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(successMessage),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                  );
                                } on FirebaseFunctionsException catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        e.message ?? 'Erro ao enviar contrato.',
                                      ),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).error,
                                    ),
                                  );
                                  await _showAutentiqueResponseDialog(
                                    title: 'Erro ao enviar para a Autentique',
                                    payload: {
                                      'status': 'error',
                                      'code': e.code,
                                      'message': e.message,
                                      'details': e.details,
                                    },
                                  );
                                } catch (e) {
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content:
                                          Text('Erro ao enviar contrato: $e'),
                                      backgroundColor:
                                          FlutterFlowTheme.of(context).error,
                                    ),
                                  );
                                  await _showAutentiqueResponseDialog(
                                    title: 'Erro ao enviar para a Autentique',
                                    payload: {
                                      'status': 'error',
                                      'message': e.toString(),
                                    },
                                  );
                                }
                              },
                              text: 'Enviar para Autentique',
                              icon: const Icon(
                                Icons.send_rounded,
                                size: 18.0,
                              ),
                              options: _actionButtonOptions(
                                context,
                                color: theme.primary,
                                textColor: theme.info,
                                hoverColor: const Color(0xFF175984),
                              ),
                            ),
                          if (widget.contratoAssinado)
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: theme.accent2,
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.verified_outlined,
                                    color: theme.success,
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      'Este contrato já está assinado, então o envio para a Autentique não é mais necessário.',
                                      style: theme.bodyMedium.override(
                                        font: GoogleFonts.notoSans(
                                          fontWeight: FontWeight.w700,
                                          fontStyle: theme.bodyMedium.fontStyle,
                                        ),
                                        color: theme.primaryText,
                                        letterSpacing: 0.0,
                                        lineHeight: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (_model.confirmarDeletar) ...[
                            const SizedBox(height: 16.0),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4F2),
                                borderRadius: BorderRadius.circular(14.0),
                                border: Border.all(
                                  color: const Color(0xFFF3C7BF),
                                ),
                              ),
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.warning_amber_rounded,
                                    color: theme.error,
                                    size: 20.0,
                                  ),
                                  const SizedBox(width: 10.0),
                                  Expanded(
                                    child: Text(
                                      'Ao confirmar, o contrato e o PDF vinculado serão removidos permanentemente.',
                                      style: theme.bodyMedium.override(
                                        font: GoogleFonts.notoSans(
                                          fontWeight: FontWeight.w700,
                                          fontStyle: theme.bodyMedium.fontStyle,
                                        ),
                                        color: theme.primaryText,
                                        letterSpacing: 0.0,
                                        lineHeight: 1.35,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          const SizedBox(height: 16.0),
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
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Ocorreu um erro ao deletar PDF.',
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.notoSans(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
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
                              } else {
                                _model.confirmarDeletar = true;
                                safeSetState(() {});
                                return;
                              }

                              context.safePop();
                              if (_shouldSetState) safeSetState(() {});
                            },
                            text: _model.confirmarDeletar
                                ? 'Confirmar exclusão'
                                : 'Deletar contrato',
                            icon: Icon(
                              _model.confirmarDeletar
                                  ? Icons.warning_amber_rounded
                                  : Icons.delete_outline_rounded,
                              size: 18.0,
                            ),
                            options: _actionButtonOptions(
                              context,
                              color: _model.confirmarDeletar
                                  ? const Color(0xFFC95A3D)
                                  : theme.error,
                              textColor: theme.info,
                              hoverColor: _model.confirmarDeletar
                                  ? const Color(0xFFB34D33)
                                  : const Color(0xFFC84444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
