import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/drawer/drawer_widget.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'contratos_assinados_page_model.dart';
export 'contratos_assinados_page_model.dart';

class ContratosAssinadosPageWidget extends StatefulWidget {
  const ContratosAssinadosPageWidget({super.key});

  static String routeName = 'ContratosAssinadosPage';
  static String routePath = '/contratosAssinadosPage';

  @override
  State<ContratosAssinadosPageWidget> createState() =>
      _ContratosAssinadosPageWidgetState();
}

class _ContratosAssinadosPageWidgetState
    extends State<ContratosAssinadosPageWidget> with TickerProviderStateMixin {
  late ContratosAssinadosPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContratosAssinadosPageModel());
    animationsMap.addAll({
      'pageLoad': AnimationInfo(
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
            begin: const Offset(0.0, 26.0),
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

  String _formatDate(BuildContext context, DateTime? value,
      {String format = 'd/M/y'}) {
    if (value == null) {
      return 'Sem data';
    }
    return dateTimeFormat(
      format,
      value,
      locale: FFLocalizations.of(context).languageCode,
    );
  }

  String _courseLabel(ContratoRecord contrato) {
    for (final option in [contrato.opcaoCurso, contrato.tipo, contrato.outro]) {
      if (option.trim().isNotEmpty) {
        return option.trim();
      }
    }
    return 'Curso não informado';
  }

  String _locationLabel(ContratoRecord contrato) {
    final parts = <String>[];
    if (contrato.cidade.trim().isNotEmpty) {
      parts.add(contrato.cidade.trim());
    }
    if (contrato.uf.trim().isNotEmpty) {
      parts.add(contrato.uf.trim());
    }
    return parts.isEmpty ? 'Local não informado' : parts.join(' - ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    Widget heroChip(IconData icon, String label) => Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(999.0),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 9.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: theme.info, size: 16.0),
              const SizedBox(width: 8.0),
              Text(
                label,
                style: theme.labelMedium.override(
                  font: GoogleFonts.manrope(
                    fontWeight: FontWeight.w800,
                    fontStyle: theme.labelMedium.fontStyle,
                  ),
                  color: theme.info,
                  letterSpacing: 0.0,
                ),
              ),
            ],
          ),
        );

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
              onPressed: () async => scaffoldKey.currentState!.openDrawer(),
            ),
          ),
          title: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              'assets/images/Design_sem_nome_(37).png',
              width: 148.0,
              height: 44.0,
              fit: BoxFit.contain,
            ),
          ),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5F8FC), Color(0xFFEAF2FB)],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0.0, 1.0),
            ),
          ),
          child: AuthUserStreamWidget(
            builder: (context) => StreamBuilder<List<ContratoRecord>>(
              stream: queryContratoRecord(
                queryBuilder: (contratoRecord) => contratoRecord
                    .where('assinado_em', isLessThan: getCurrentTimestamp)
                    .where(
                      'criador',
                      isEqualTo: !valueOrDefault<bool>(
                              currentUserDocument?.isAdmin, false)
                          ? currentUserReference
                          : null,
                    )
                    .orderBy('assinado_em', descending: true),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: SizedBox(
                      width: 32.0,
                      height: 32.0,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(theme.primary),
                      ),
                    ),
                  );
                }

                final contratos = snapshot.data!;
                final latestSigned =
                    contratos.isEmpty ? null : contratos.first.assinadoEm;

                Widget contractCard(ContratoRecord contrato) {
                  final title = contrato.contratante.trim().isNotEmpty
                      ? contrato.contratante.trim()
                      : (contrato.aluno.trim().isNotEmpty
                          ? contrato.aluno.trim()
                          : 'Contrato sem identificação');
                  final subtitle = contrato.aluno.trim().isNotEmpty &&
                          contrato.aluno.trim() != title
                      ? 'Aluno: ${contrato.aluno.trim()}'
                      : (contrato.email.trim().isNotEmpty
                          ? contrato.email.trim()
                          : _locationLabel(contrato));
                  final preview =
                      contrato.documento.replaceAll(RegExp(r'\s+'), ' ').trim();

                  return InkWell(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    borderRadius: BorderRadius.circular(28.0),
                    onTap: () async {
                      context.pushNamed(
                        VerContratoPageWidget.routeName,
                        queryParameters: {
                          'contrato':
                              serializeParam(contrato, ParamType.Document),
                          'contratoAssinado': serializeParam(
                            contrato.contratoAssinado,
                            ParamType.bool,
                          ),
                          'contratoTestemunha': serializeParam(
                            contrato.contratoTestemunha,
                            ParamType.bool,
                          ),
                        }.withoutNulls,
                        extra: <String, dynamic>{'contrato': contrato},
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.secondaryBackground,
                        borderRadius: BorderRadius.circular(28.0),
                        border: Border.all(color: theme.alternate),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 24.0,
                            color: Color(0x120F2237),
                            offset: Offset(0.0, 14.0),
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
                                width: 56.0,
                                height: 56.0,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      theme.primary,
                                      const Color(0xFF5E95C6)
                                    ],
                                    begin:
                                        const AlignmentDirectional(-1.0, -1.0),
                                    end: const AlignmentDirectional(1.0, 1.0),
                                  ),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Icon(
                                  Icons.verified_user_rounded,
                                  color: theme.info,
                                  size: 28.0,
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
                                      children: [
                                        heroChip(Icons.check_circle_outline,
                                            'Assinado'),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F7FB),
                                            borderRadius:
                                                BorderRadius.circular(999.0),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 6.0,
                                          ),
                                          child: Text(
                                            _formatDate(
                                                context, contrato.assinadoEm,
                                                format: 'd MMM y'),
                                            style: theme.labelSmall.override(
                                              font: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w700,
                                                fontStyle:
                                                    theme.labelSmall.fontStyle,
                                              ),
                                              color: theme.secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      title,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.titleLarge.override(
                                        font: GoogleFonts.sora(
                                          fontWeight: FontWeight.w700,
                                          fontStyle: theme.titleLarge.fontStyle,
                                        ),
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 6.0),
                                    Text(
                                      subtitle,
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
                              const SizedBox(width: 12.0),
                              Container(
                                width: 42.0,
                                height: 42.0,
                                decoration: BoxDecoration(
                                  color: theme.accent4,
                                  borderRadius: BorderRadius.circular(16.0),
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
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F9FD),
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    'Curso: ${_courseLabel(contrato)}',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.bodyMedium.override(
                                      font: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w700,
                                        fontStyle: theme.bodyMedium.fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF6F9FD),
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  padding: const EdgeInsets.all(14.0),
                                  child: Text(
                                    _locationLabel(contrato),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.bodyMedium.override(
                                      font: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w700,
                                        fontStyle: theme.bodyMedium.fontStyle,
                                      ),
                                      letterSpacing: 0.0,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14.0),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: theme.accent4,
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              preview.isEmpty
                                  ? 'Prévia do documento indisponível.'
                                  : preview,
                              maxLines: 4,
                              overflow: TextOverflow.ellipsis,
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  fontStyle: theme.bodyMedium.fontStyle,
                                ),
                                letterSpacing: 0.0,
                                lineHeight: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 24.0),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  theme.primary,
                                  const Color(0xFF4E88BC)
                                ],
                                begin: const AlignmentDirectional(-1.0, -1.0),
                                end: const AlignmentDirectional(1.0, 1.0),
                              ),
                              borderRadius: BorderRadius.circular(30.0),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 24.0,
                                  color: Color(0x1E2A5D8F),
                                  offset: Offset(0.0, 16.0),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heroChip(Icons.fact_check_outlined,
                                    'Arquivo de assinaturas'),
                                const SizedBox(height: 18.0),
                                Text(
                                  'Contratos concluídos com leitura rápida e navegação mais clara.',
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
                                  contratos.isEmpty
                                      ? 'Assim que um contrato for assinado, ele aparece aqui organizado para consulta sem ruído visual.'
                                      : 'Toque em qualquer contrato para revisar o documento, conferir o status e seguir com as próximas ações.',
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
                                const SizedBox(height: 18.0),
                                Wrap(
                                  spacing: 10.0,
                                  runSpacing: 10.0,
                                  children: [
                                    heroChip(
                                      Icons.verified_outlined,
                                      '${contratos.length} finalizado${contratos.length == 1 ? '' : 's'}',
                                    ),
                                    heroChip(Icons.visibility_outlined,
                                        'Consulta simplificada'),
                                    heroChip(
                                      Icons.schedule_rounded,
                                      latestSigned == null
                                          ? 'Aguardando assinatura'
                                          : 'Última em ${_formatDate(context, latestSigned)}',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ).animateOnPageLoad(animationsMap['pageLoad']!),
                          const SizedBox(height: 18.0),
                          Container(
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(color: theme.alternate),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 24.0,
                                  color: Color(0x100F2237),
                                  offset: Offset(0.0, 14.0),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Histórico assinado',
                                  style: theme.titleLarge.override(
                                    font: GoogleFonts.sora(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: theme.titleLarge.fontStyle,
                                    ),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 6.0),
                                Text(
                                  contratos.isEmpty
                                      ? 'Nenhum contrato concluído por enquanto.'
                                      : 'Tudo em um só lugar para abrir, revisar e localizar mais rápido.',
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
                                if (contratos.isEmpty)
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF6F9FD),
                                      borderRadius: BorderRadius.circular(24.0),
                                    ),
                                    padding: const EdgeInsets.all(28.0),
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 68.0,
                                          height: 68.0,
                                          decoration: BoxDecoration(
                                            color: theme.accent1,
                                            borderRadius:
                                                BorderRadius.circular(24.0),
                                          ),
                                          child: Icon(
                                            Icons.fact_check_outlined,
                                            color: theme.primary,
                                            size: 30.0,
                                          ),
                                        ),
                                        const SizedBox(height: 18.0),
                                        Text(
                                          'Nenhum contrato assinado ainda.',
                                          textAlign: TextAlign.center,
                                          style: theme.titleLarge.override(
                                            font: GoogleFonts.sora(
                                              fontWeight: FontWeight.w700,
                                              fontStyle:
                                                  theme.titleLarge.fontStyle,
                                            ),
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        Text(
                                          'Quando um contrato for concluído, ele ficará disponível aqui com um visual mais limpo para consulta rápida.',
                                          textAlign: TextAlign.center,
                                          style: theme.bodyMedium.override(
                                            font: GoogleFonts.manrope(
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
                                  )
                                else
                                  ListView.separated(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: contratos.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 14.0),
                                    itemBuilder: (context, index) =>
                                        contractCard(
                                      contratos[index],
                                    ).animateOnPageLoad(
                                            animationsMap['pageLoad']!),
                                  ),
                              ],
                            ),
                          ).animateOnPageLoad(animationsMap['pageLoad']!),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
