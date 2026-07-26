import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/background_scene_support.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'drawer_model.dart';
export 'drawer_model.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  late DrawerModel _model;

  WebViewController? _backgroundSceneController;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DrawerModel());

    if (supportsBackgroundScene3D) {
      _backgroundSceneController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..loadFlutterAsset('assets/web3d/ambient_scene.html');
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  String _initials(String value) {
    final parts =
        value.trim().split(RegExp(r'\s+')).where((part) => part.isNotEmpty);
    if (parts.isEmpty) {
      return 'SP';
    }
    final list = parts.toList();
    final first = list.first.substring(0, 1).toUpperCase();
    final second = list.length > 1 ? list[1].substring(0, 1).toUpperCase() : '';
    return '$first$second';
  }

  Widget _buildNavRow({
    required BuildContext context,
    required FaIconData icon,
    required String title,
    required Future<void> Function() onTap,
    bool danger = false,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final accentColor = danger ? theme.error : theme.primary;
    final textColor = danger ? theme.error : theme.primaryText;

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 14.0),
        child: Row(
          children: [
            Container(
              width: 38.0,
              height: 38.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withValues(alpha: 0.12),
              ),
              child: Center(
                child: FaIcon(icon, color: accentColor, size: 16.0),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Text(
                title,
                style: theme.bodyLarge.override(
                  font: GoogleFonts.manrope(
                    fontWeight: FontWeight.w700,
                    fontStyle: theme.bodyLarge.fontStyle,
                  ),
                  color: textColor,
                  letterSpacing: 0.0,
                ),
              ),
            ),
            if (!danger)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: theme.secondaryText.withValues(alpha: 0.5),
                size: 14.0,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    final displayName =
        valueOrDefault<String>(currentUserDisplayName, 'Usuário');
    final email = currentUserEmail;
    final photoUrl = currentUserPhoto;

    return Stack(
      children: [
        Positioned.fill(
          child: ColoredBox(
            color: theme.primaryBackground,
            child: _backgroundSceneController == null
                ? const SizedBox.shrink()
                : IgnorePointer(
                    child: WebViewWidget(
                      controller: _backgroundSceneController!,
                    ),
                  ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryBackground.withValues(alpha: 0.3),
                    theme.primaryBackground.withValues(alpha: 0.55),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 32.0),
              Container(
                width: 92.0,
                height: 92.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [theme.primary, const Color(0xFF4B88BF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white, width: 3.0),
                  boxShadow: [
                    BoxShadow(
                      color: theme.primary.withValues(alpha: 0.4),
                      blurRadius: 26.0,
                      offset: const Offset(0.0, 12.0),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(3.0),
                child: ClipOval(
                  child: photoUrl.isNotEmpty
                      ? Image.network(photoUrl, fit: BoxFit.cover)
                      : Center(
                          child: Text(
                            _initials(displayName),
                            style: theme.headlineSmall.override(
                              font: GoogleFonts.sora(
                                fontWeight: FontWeight.w800,
                                fontStyle: theme.headlineSmall.fontStyle,
                              ),
                              color: Colors.white,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16.0),
              Text(
                displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: theme.headlineSmall.override(
                  font: GoogleFonts.sora(
                    fontWeight: FontWeight.w700,
                    fontStyle: theme.headlineSmall.fontStyle,
                  ),
                  color: theme.primaryText,
                  letterSpacing: -0.3,
                ),
              ),
              if (email.isNotEmpty) ...[
                const SizedBox(height: 4.0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: theme.bodySmall.override(
                      font: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600,
                        fontStyle: theme.bodySmall.fontStyle,
                      ),
                      color: theme.secondaryText,
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 28.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Divider(height: 1.0, color: theme.alternate),
              ),
              Expanded(
                child: RepaintBoundary(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 6.0),
                        _buildNavRow(
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
                        _buildNavRow(
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
                        _buildNavRow(
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
                          AuthUserStreamWidget(
                            builder: (context) => _buildNavRow(
                              context: context,
                              icon: FontAwesomeIcons.users,
                              title: 'Usuários',
                              onTap: () async {
                                if (Navigator.of(context).canPop()) {
                                  context.pop();
                                }
                                context.goNamed(UsuariosPageWidget.routeName);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              RepaintBoundary(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Divider(height: 1.0, color: theme.alternate),
                    ),
                    _buildNavRow(
                      context: context,
                      icon: FontAwesomeIcons.rightFromBracket,
                      title: 'Sair',
                      danger: true,
                      onTap: () async {
                        GoRouter.of(context).prepareAuthEvent();
                        await authManager.signOut();
                        GoRouter.of(context).clearRedirectLocation();

                        context.goNamedAuth(
                          LoginPageWidget.routeName,
                          context.mounted,
                        );
                      },
                    ),
                    const SizedBox(height: 6.0),
                    Text(
                      'Versão 1.0',
                      style: theme.labelSmall.override(
                        font: GoogleFonts.manrope(
                          fontWeight: FontWeight.w700,
                          fontStyle: theme.labelSmall.fontStyle,
                        ),
                        color: theme.secondaryText.withValues(alpha: 0.7),
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
