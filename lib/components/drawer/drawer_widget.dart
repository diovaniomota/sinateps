import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'drawer_model.dart';
export 'drawer_model.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late DrawerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DrawerModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  Widget _buildNavTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required Future<void> Function() onTap,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      borderRadius: BorderRadius.circular(22.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.accent4,
          borderRadius: BorderRadius.circular(22.0),
          border: Border.all(color: theme.alternate),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Container(
              width: 44.0,
              height: 44.0,
              decoration: BoxDecoration(
                color: theme.accent1,
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: Center(
                child: FaIcon(
                  icon,
                  color: theme.primary,
                  size: 18.0,
                ),
              ),
            ),
            const SizedBox(width: 14.0),
            Expanded(
              child: Text(
                title,
                style: theme.bodyLarge.override(
                  font: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    fontStyle: theme.bodyLarge.fontStyle,
                  ),
                  letterSpacing: 0.0,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: theme.secondaryText,
              size: 16.0,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Container(
      color: theme.secondaryBackground,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: RepaintBoundary(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.primary,
                            const Color(0xFF4A84BA),
                          ],
                          begin: const AlignmentDirectional(-1.0, -1.0),
                          end: const AlignmentDirectional(1.0, 1.0),
                        ),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(28.0),
                          bottomRight: Radius.circular(28.0),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                          24.0,
                          56.0,
                          24.0,
                          24.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 56.0,
                              height: 56.0,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              child: const Center(
                                child: FaIcon(
                                  FontAwesomeIcons.solidCircleUser,
                                  color: Colors.white,
                                  size: 28.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 18.0),
                            Text(
                              'Minha conta',
                              style: theme.headlineSmall.override(
                                font: GoogleFonts.sora(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: theme.headlineSmall.fontStyle,
                                ),
                                color: theme.info,
                                letterSpacing: -0.3,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Acesse rapidamente perfil, documentos e áreas administrativas.',
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
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Navegação',
                            style: theme.labelLarge.override(
                              font: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                fontStyle: theme.labelLarge.fontStyle,
                              ),
                              color: theme.secondaryText,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 14.0),
                          _buildNavTile(
                            context: context,
                            icon: FontAwesomeIcons.solidUser,
                            title: 'Perfil',
                            onTap: () async {
                              if (Navigator.of(context).canPop()) {
                                context.pop();
                              }
                              context.goNamed(PerfilPageWidget.routeName);
                            },
                          ),
                          const SizedBox(height: 14.0),
                          _buildNavTile(
                            context: context,
                            icon: FontAwesomeIcons.solidFile,
                            title: 'Documentos',
                            onTap: () async {
                              if (Navigator.of(context).canPop()) {
                                context.pop();
                              }
                              context.goNamed(ContratosPageWidget.routeName);
                            },
                          ),
                          const SizedBox(height: 14.0),
                          _buildNavTile(
                            context: context,
                            icon: FontAwesomeIcons.signature,
                            title: 'Assinados',
                            onTap: () async {
                              if (Navigator.of(context).canPop()) {
                                context.pop();
                              }
                              context.goNamed(
                                ContratosAssinadosPageWidget.routeName,
                              );
                            },
                          ),
                          if (valueOrDefault<bool>(
                            currentUserDocument?.isAdmin,
                            false,
                          ))
                            Padding(
                              padding: const EdgeInsets.only(top: 14.0),
                              child: AuthUserStreamWidget(
                                builder: (context) => _buildNavTile(
                                  context: context,
                                  icon: FontAwesomeIcons.users,
                                  title: 'Usuários',
                                  onTap: () async {
                                    if (Navigator.of(context).canPop()) {
                                      context.pop();
                                    }
                                    context.goNamed(
                                      UsuariosPageWidget.routeName,
                                    );
                                  },
                                ),
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
          RepaintBoundary(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF5F3),
                      borderRadius: BorderRadius.circular(22.0),
                      border: Border.all(
                        color: const Color(0xFFF4D5CE),
                      ),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sessão',
                          style: theme.labelLarge.override(
                            font: GoogleFonts.manrope(
                              fontWeight: FontWeight.w800,
                              fontStyle: theme.labelLarge.fontStyle,
                            ),
                            color: theme.error,
                            letterSpacing: 0.0,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        FFButtonWidget(
                          onPressed: () async {
                            GoRouter.of(context).prepareAuthEvent();
                            await authManager.signOut();
                            GoRouter.of(context).clearRedirectLocation();

                            context.goNamedAuth(
                              LoginPageWidget.routeName,
                              context.mounted,
                            );
                          },
                          text: 'Sair',
                          icon: const FaIcon(
                            FontAwesomeIcons.rightFromBracket,
                            size: 16.0,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 48.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              20.0,
                              0.0,
                              20.0,
                              0.0,
                            ),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              0.0,
                              6.0,
                              0.0,
                            ),
                            iconColor: theme.error,
                            color: Colors.white,
                            textStyle: theme.titleSmall.override(
                              font: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontStyle: theme.titleSmall.fontStyle,
                              ),
                              color: theme.error,
                              letterSpacing: 0.0,
                            ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: const Color(0xFFF1CDC4),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14.0),
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.accent1,
                        borderRadius: BorderRadius.circular(999.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'Versão 1.0',
                        style: theme.labelMedium.override(
                          font: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            fontStyle: theme.labelMedium.fontStyle,
                          ),
                          color: theme.primary,
                          letterSpacing: 0.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
