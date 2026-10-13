import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
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

  Future<void> _abrir(String route, {Map<String, String>? queryParameters}) async {
    if (Navigator.of(context).canPop()) {
      context.pop();
    }
    context.goNamed(route, queryParameters: queryParameters ?? const {});
  }

  Widget _item({
    required IconData icon,
    required String title,
    required Future<void> Function() onTap,
    Color? color,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final tinta = color ?? theme.primaryText;
    final icone = color ?? theme.primary;
    return ListTile(
      leading: Icon(icon, color: icone, size: 22.0),
      title: Text(title, style: theme.titleSmall.override(color: tinta)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final displayName = valueOrDefault<String>(currentUserDisplayName, 'Usuário');
    final email = currentUserEmail;

    return Material(
      color: theme.secondaryBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/images/sinatep_logo_color.png',
                    height: 36.0,
                    alignment: Alignment.centerLeft,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 18.0),
                  Text(
                    displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.titleMedium,
                  ),
                  if (email.isNotEmpty)
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.bodySmall.override(
                        color: theme.secondaryText,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            _item(
              icon: Icons.person_outline,
              title: 'Perfil',
              onTap: () => _abrir(PerfilPageWidget.routeName),
            ),
            _item(
              icon: Icons.folder_open_outlined,
              title: 'Documentos',
              onTap: () => _abrir(ContratosPageWidget.routeName),
            ),
            _item(
              icon: Icons.draw_outlined,
              title: 'Assinados',
              onTap: () => _abrir(
                ContratosPageWidget.routeName,
                queryParameters: const {'filtro': 'assinados'},
              ),
            ),
            if (valueOrDefault<bool>(currentUserDocument?.isAdmin, false))
              AuthUserStreamWidget(
                builder: (context) => _item(
                  icon: Icons.people_outline,
                  title: 'Usuários',
                  onTap: () => _abrir(UsuariosPageWidget.routeName),
                ),
              ),
            const Spacer(),
            const Divider(height: 1.0),
            _item(
              icon: Icons.logout,
              title: 'Sair',
              color: theme.error,
              onTap: () async {
                GoRouter.of(context).prepareAuthEvent();
                await authManager.signOut();
                GoRouter.of(context).clearRedirectLocation();
                context.goNamedAuth(LoginPageWidget.routeName, context.mounted);
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 12.0),
              child: Text(
                'Versão 1.2.11',
                style: theme.labelSmall.override(color: theme.secondaryText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
