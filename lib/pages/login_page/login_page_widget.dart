import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'login_page_model.dart';
export 'login_page_model.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  static String routeName = 'LoginPage';
  static String routePath = '/loginPage';

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  late LoginPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String label,
  }) {
    final theme = FlutterFlowTheme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide(color: theme.alternate),
    );

    return InputDecoration(
      labelText: label,
      labelStyle: theme.labelMedium.override(color: theme.secondaryText),
      filled: true,
      fillColor: theme.secondaryBackground,
      enabledBorder: border,
      focusedBorder: border.copyWith(
        borderSide: BorderSide(color: theme.primary, width: 1.4),
      ),
      errorBorder: border.copyWith(
        borderSide: BorderSide(color: theme.error),
      ),
      focusedErrorBorder: border.copyWith(
        borderSide: BorderSide(color: theme.error, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 14.0,
      ),
    );
  }

  Future<void> _entrar() async {
    if (_model.formKey.currentState == null ||
        !_model.formKey.currentState!.validate()) {
      return;
    }
    GoRouter.of(context).prepareAuthEvent();

    final user = await authManager.signInWithEmail(
      context,
      _model.emailTextController.text,
      _model.passwordTextController.text,
    );
    if (user == null) {
      return;
    }

    context.goNamedAuth(
      ContratosPageWidget.routeName,
      context.mounted,
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
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420.0),
                child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              'assets/images/sinatep_logo_color.png',
                              height: 58.0,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Cursos profissionalizantes',
                              textAlign: TextAlign.center,
                              style: theme.labelMedium.override(
                                color: theme.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 36.0),
                            Text(
                              'Entrar',
                              style: theme.headlineSmall,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Use o e-mail cadastrado da equipe.',
                              style: theme.bodyMedium.override(
                                color: theme.secondaryText,
                              ),
                            ),
                            const SizedBox(height: 20.0),
                            Form(
                              key: _model.formKey,
                              autovalidateMode: AutovalidateMode.disabled,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _model.emailTextController,
                                    focusNode: _model.emailFocusNode,
                                    autofocus: true,
                                    autofillHints: const [AutofillHints.email],
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: _inputDecoration(
                                      context: context,
                                      label: 'E-mail',
                                    ),
                                    style: theme.bodyLarge,
                                    validator: _model
                                        .emailTextControllerValidator
                                        .asValidator(context),
                                  ),
                                  const SizedBox(height: 12.0),
                                  TextFormField(
                                    controller: _model.passwordTextController,
                                    focusNode: _model.passwordFocusNode,
                                    autofillHints: const [
                                      AutofillHints.password
                                    ],
                                    textInputAction: TextInputAction.done,
                                    obscureText: !_model.passwordVisibility,
                                    onFieldSubmitted: (_) => _entrar(),
                                    decoration: _inputDecoration(
                                      context: context,
                                      label: 'Senha',
                                    ).copyWith(
                                      suffixIcon: IconButton(
                                        onPressed: () => safeSetState(
                                          () => _model.passwordVisibility =
                                              !_model.passwordVisibility,
                                        ),
                                        icon: Icon(
                                          _model.passwordVisibility
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: theme.secondaryText,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                    style: theme.bodyLarge,
                                    validator: _model
                                        .passwordTextControllerValidator
                                        .asValidator(context),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18.0),
                            SizedBox(
                              height: 46.0,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: theme.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                ),
                                onPressed: _entrar,
                                child: Text(
                                  'Entrar',
                                  style: theme.titleSmall.override(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () async {
                                  context.pushNamed(
                                    EsqueceuSenhaPageWidget.routeName,
                                  );
                                },
                                child: Text(
                                  'Esqueci a senha',
                                  style: theme.bodyMedium.override(
                                    color: theme.secondary,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              'Versão 1.2.11',
                              textAlign: TextAlign.center,
                              style: theme.labelSmall.override(
                                color: theme.secondaryText,
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
