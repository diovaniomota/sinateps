import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/drawer/drawer_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contratos_page_model.dart';
export 'contratos_page_model.dart';

class ContratosPageWidget extends StatefulWidget {
  const ContratosPageWidget({super.key});

  static String routeName = 'ContratosPage';
  static String routePath = '/contratosPage';

  @override
  State<ContratosPageWidget> createState() => _ContratosPageWidgetState();
}

class _ContratosPageWidgetState extends State<ContratosPageWidget>
    with TickerProviderStateMixin {
  late ContratosPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContratosPageModel());

    _model.pesquisarPorCidadeTextController ??= TextEditingController();
    _model.pesquisarPorCidadeFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 32.0),
            end: const Offset(0.0, 0.0),
          ),
        ],
      ),
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  InputDecoration _searchDecoration(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return InputDecoration(
      labelText: 'Pesquisar por cidade',
      labelStyle: theme.labelMedium.override(
        font: GoogleFonts.manrope(
          fontWeight: FontWeight.w600,
          fontStyle: theme.labelMedium.fontStyle,
        ),
        color: theme.secondaryText,
        letterSpacing: 0.0,
      ),
      filled: true,
      fillColor: theme.secondaryBackground,
      prefixIcon: Icon(
        Icons.location_on_outlined,
        color: theme.secondaryText,
        size: 22.0,
      ),
      suffixIcon: _model.pesquisarPorCidadeTextController!.text.isNotEmpty
          ? InkWell(
              onTap: () async {
                _model.pesquisarPorCidadeTextController?.clear();
                safeSetState(() {});
              },
              child: Icon(
                Icons.close_rounded,
                color: theme.secondaryText,
                size: 20.0,
              ),
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.alternate),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primary, width: 1.3),
        borderRadius: BorderRadius.circular(20.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.3),
        borderRadius: BorderRadius.circular(20.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 18.0,
      ),
    );
  }

  Widget _buildContratoCard(
    BuildContext context,
    ContratoRecord contrato,
  ) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      borderRadius: BorderRadius.circular(24.0),
      onTap: () async {
        context.pushNamed(
          VerContratoPageWidget.routeName,
          queryParameters: {
            'contrato': serializeParam(
              contrato,
              ParamType.Document,
            ),
            'contratoAssinado': serializeParam(
              contrato.contratoAssinado,
              ParamType.bool,
            ),
            'contratoTestemunha': serializeParam(
              contrato.contratoTestemunha,
              ParamType.bool,
            ),
            'nomeTxt': serializeParam(
              contrato.contratante,
              ParamType.String,
            ),
          }.withoutNulls,
          extra: <String, dynamic>{
            'contrato': contrato,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.secondaryBackground,
          borderRadius: BorderRadius.circular(24.0),
          border: Border.all(color: theme.alternate),
          boxShadow: const [
            BoxShadow(
              blurRadius: 22.0,
              color: Color(0x120F2237),
              offset: Offset(0.0, 12.0),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62.0,
                  height: 62.0,
                  decoration: BoxDecoration(
                    color: theme.accent4,
                    borderRadius: BorderRadius.circular(18.0),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18.0),
                    child: Image.network(
                      valueOrDefault<String>(
                        contrato.fotoCliente,
                        'https://images.vexels.com/content/137047/preview/user-profile-blue-icon-32113c.png',
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 14.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          if (contrato.numeroDoc > 0)
                            Container(
                              decoration: BoxDecoration(
                                color: theme.accent1,
                                borderRadius: BorderRadius.circular(999.0),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10.0,
                                vertical: 6.0,
                              ),
                              child: Text(
                                'Nº ${contrato.numeroDoc}',
                                style: theme.labelSmall.override(
                                  font: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w800,
                                    fontStyle: theme.labelSmall.fontStyle,
                                  ),
                                  color: theme.primary,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F7FB),
                              borderRadius: BorderRadius.circular(999.0),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                              vertical: 6.0,
                            ),
                            child: Text(
                              dateTimeFormat(
                                'd/M/y',
                                contrato.criadoEm!,
                                locale:
                                    FFLocalizations.of(context).languageCode,
                              ),
                              style: theme.labelSmall.override(
                                font: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: theme.labelSmall.fontStyle,
                                ),
                                color: theme.secondaryText,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        contrato.contratante,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.titleLarge.override(
                          font: GoogleFonts.sora(
                            fontWeight: FontWeight.w700,
                            fontStyle: theme.titleLarge.fontStyle,
                          ),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 6.0),
                      Text(
                        valueOrDefault<String>(contrato.tipo, 'N/A'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            fontStyle: theme.bodyMedium.fontStyle,
                          ),
                          color: theme.secondaryText,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                Container(
                  width: 38.0,
                  height: 38.0,
                  decoration: BoxDecoration(
                    color: theme.accent4,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: theme.primary,
                    size: 20.0,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: theme.accent4,
                borderRadius: BorderRadius.circular(18.0),
              ),
              padding: const EdgeInsets.all(14.0),
              child: Text(
                contrato.documento,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
                style: theme.bodyMedium.override(
                  font: GoogleFonts.manrope(
                    fontWeight: FontWeight.w600,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        drawer: Drawer(
          elevation: 0.0,
          child: wrapWithModel(
            model: _model.drawerModel,
            updateCallback: () => safeSetState(() {}),
            child: const DrawerWidget(),
          ),
        ),
        appBar: AppBar(
          backgroundColor: theme.secondaryBackground,
          automaticallyImplyLeading: false,
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlutterFlowIconButton(
              borderColor: theme.alternate,
              borderRadius: 18.0,
              borderWidth: 1.0,
              fillColor: theme.secondaryBackground,
              buttonSize: 48.0,
              icon: Icon(
                Icons.menu_rounded,
                color: theme.primaryText,
                size: 24.0,
              ),
              onPressed: () async {
                scaffoldKey.currentState!.openDrawer();
              },
            ),
          ),
          title: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              'assets/images/Design_sem_nome_(37).png',
              width: 148.0,
              height: 44.0,
              fit: BoxFit.contain,
              alignment: const Alignment(0.0, 0.0),
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 960.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          theme.primary,
                          const Color(0xFF4E88BC),
                        ],
                        begin: const AlignmentDirectional(-1.0, -1.0),
                        end: const AlignmentDirectional(1.0, 1.0),
                      ),
                      borderRadius: BorderRadius.circular(28.0),
                    ),
                    padding: const EdgeInsets.all(22.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(999.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                          child: Text(
                            'Painel de contratos',
                            style: theme.labelLarge.override(
                              font: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                fontStyle: theme.labelLarge.fontStyle,
                              ),
                              color: theme.info,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          'Visualize e gerencie os registros mais recentes.',
                          style: theme.headlineSmall.override(
                            font: GoogleFonts.sora(
                              fontWeight: FontWeight.w700,
                              fontStyle: theme.headlineSmall.fontStyle,
                            ),
                            color: theme.info,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'A busca e o acesso aos detalhes continuam iguais, mas com leitura mais rápida e organização melhor.',
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontStyle: theme.bodyMedium.fontStyle,
                            ),
                            color: Colors.white.withValues(alpha: 0.86),
                            letterSpacing: 0.0,
                            lineHeight: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        FFButtonWidget(
                          onPressed: () async {
                            context.pushNamed(
                              RegistrarContratoPageWidget.routeName,
                            );
                          },
                          text: 'Novo registro',
                          icon: const FaIcon(
                            FontAwesomeIcons.plus,
                            size: 16.0,
                          ),
                          options: FFButtonOptions(
                            width: 200.0,
                            height: 50.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              22.0,
                              0.0,
                              22.0,
                              0.0,
                            ),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              0.0,
                              8.0,
                              0.0,
                            ),
                            iconColor: theme.primary,
                            color: Colors.white,
                            textStyle: theme.titleSmall.override(
                              font: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                fontStyle: theme.titleSmall.fontStyle,
                              ),
                              color: theme.primary,
                              letterSpacing: 0.0,
                            ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ],
                    ),
                  ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation']!,
                  ),
                  const SizedBox(height: 18.0),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      borderRadius: BorderRadius.circular(28.0),
                      border: Border.all(color: theme.alternate),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Últimos contratos',
                          style: theme.titleLarge.override(
                            font: GoogleFonts.sora(
                              fontWeight: FontWeight.w700,
                              fontStyle: theme.titleLarge.fontStyle,
                            ),
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Text(
                          'Filtre por cidade para localizar registros mais rápido.',
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontStyle: theme.bodyMedium.fontStyle,
                            ),
                            color: theme.secondaryText,
                            letterSpacing: 0.0,
                          ),
                        ),
                        const SizedBox(height: 18.0),
                        TextFormField(
                          controller: _model.pesquisarPorCidadeTextController,
                          focusNode: _model.pesquisarPorCidadeFocusNode,
                          onChanged: (_) => EasyDebounce.debounce(
                            '_model.pesquisarPorCidadeTextController',
                            const Duration(milliseconds: 2000),
                            () => safeSetState(() {}),
                          ),
                          autofocus: false,
                          autofillHints: const [AutofillHints.addressCity],
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.next,
                          obscureText: false,
                          decoration: _searchDecoration(context),
                          style: theme.bodyLarge.override(
                            font: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontStyle: theme.bodyLarge.fontStyle,
                            ),
                            letterSpacing: 0.0,
                          ),
                          keyboardType: TextInputType.streetAddress,
                          validator: _model
                              .pesquisarPorCidadeTextControllerValidator
                              .asValidator(context),
                          inputFormatters: [
                            if (!isAndroid && !isiOS)
                              TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                                  return TextEditingValue(
                                    selection: newValue.selection,
                                    text: newValue.text.toCapitalization(
                                      TextCapitalization.words,
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 18.0),
                        SizedBox(
                          height: 0.0,
                          width: double.infinity,
                        ),
                        AuthUserStreamWidget(
                          builder: (context) =>
                              StreamBuilder<List<ContratoRecord>>(
                            stream: queryContratoRecord(
                              queryBuilder: (contratoRecord) => contratoRecord
                                  .where(
                                    'criador',
                                    isEqualTo: !valueOrDefault<bool>(
                                      currentUserDocument?.isAdmin,
                                      false,
                                    )
                                        ? currentUserReference
                                        : null,
                                  )
                                  .orderBy('criado_em', descending: true),
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 48.0,
                                  ),
                                  child: Center(
                                    child: SizedBox(
                                      width: 32.0,
                                      height: 32.0,
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          theme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }
                              final contratos = snapshot.data!;
                              final filtrados = (_model
                                              .pesquisarPorCidadeTextController
                                              .text !=
                                          ''
                                      ? contratos
                                          .where(
                                            (e) => valueOrDefault<String>(
                                              e.cidade,
                                              'X',
                                            ).contains(
                                              _model
                                                  .pesquisarPorCidadeTextController
                                                  .text,
                                            ),
                                          )
                                          .toList()
                                      : contratos)
                                  .take(200)
                                  .toList();

                              if (filtrados.isEmpty) {
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: theme.accent4,
                                    borderRadius: BorderRadius.circular(24.0),
                                  ),
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.search_off_rounded,
                                        color: theme.secondaryText,
                                        size: 34.0,
                                      ),
                                      const SizedBox(height: 12.0),
                                      Text(
                                        'Nenhum contrato encontrado.',
                                        style: theme.titleMedium.override(
                                          font: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w800,
                                            fontStyle:
                                                theme.titleMedium.fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      Text(
                                        'Tente ajustar o filtro de cidade para ver mais resultados.',
                                        textAlign: TextAlign.center,
                                        style: theme.bodyMedium.override(
                                          font: GoogleFonts.manrope(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                theme.bodyMedium.fontStyle,
                                          ),
                                          color: theme.secondaryText,
                                          letterSpacing: 0.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }

                              return ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filtrados.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 14.0),
                                itemBuilder: (context, index) {
                                  final contrato = filtrados[index];
                                  return _buildContratoCard(context, contrato)
                                      .animateOnPageLoad(
                                    animationsMap[
                                        'containerOnPageLoadAnimation']!,
                                  );
                                },
                              );
                            },
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
    );
  }
}
