import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_page_model.dart';
export 'login_page_model.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({super.key});

  static String routeName = 'LoginPage';
  static String routePath = '/loginPage';

  @override
  State<LoginPageWidget> createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget>
    with TickerProviderStateMixin {
  late LoginPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    animationsMap.addAll({
      'buttonOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          MoveEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: const Offset(0.0, 60.0),
            end: const Offset(0.0, 0.0),
          ),
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
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

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return InputDecoration(
      labelText: label,
      labelStyle: theme.labelMedium.override(
        font: GoogleFonts.manrope(
          fontWeight: FontWeight.w600,
          fontStyle: theme.labelMedium.fontStyle,
        ),
        color: theme.secondaryText,
        letterSpacing: 0.0,
      ),
      filled: true,
      fillColor: theme.accent4,
      prefixIcon: Icon(
        icon,
        color: theme.secondaryText,
        size: 20.0,
      ),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.alternate,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.primary,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.error,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.error,
          width: 1.3,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 18.0,
        vertical: 18.0,
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
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.primaryBackground,
                const Color(0xFFEAF2FB),
                const Color(0xFFF8FBFF),
              ],
              begin: const AlignmentDirectional(-1.0, -1.0),
              end: const AlignmentDirectional(1.0, 1.0),
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground.withValues(alpha: 0.96),
                      borderRadius: BorderRadius.circular(28.0),
                      border: Border.all(color: theme.alternate),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 32.0,
                          color: Color(0x140F2237),
                          offset: Offset(0.0, 18.0),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(28.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 72.0,
                          height: 72.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22.0),
                            gradient: LinearGradient(
                              colors: [
                                theme.primary,
                                const Color(0xFF4B88BF),
                              ],
                              begin: const AlignmentDirectional(-1.0, -1.0),
                              end: const AlignmentDirectional(1.0, 1.0),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.asset(
                                'assets/images/Design_sem_nome_(37).png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Text(
                          'Acesse sua conta',
                          style: theme.headlineMedium.override(
                            font: GoogleFonts.sora(
                              fontWeight: FontWeight.w700,
                              fontStyle: theme.headlineMedium.fontStyle,
                            ),
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'Entrar no painel para consultar contratos e continuar o fluxo do app.',
                          style: theme.bodyMedium.override(
                            font: GoogleFonts.manrope(
                              fontWeight: FontWeight.w500,
                              fontStyle: theme.bodyMedium.fontStyle,
                            ),
                            color: theme.secondaryText,
                            letterSpacing: 0.0,
                            lineHeight: 1.4,
                          ),
                        ),
                        const SizedBox(height: 28.0),
                        Form(
                          key: _model.formKey,
                          autovalidateMode: AutovalidateMode.disabled,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              TextFormField(
                                controller: _model.emailTextController,
                                focusNode: _model.emailFocusNode,
                                autofocus: true,
                                autofillHints: const [AutofillHints.email],
                                textInputAction: TextInputAction.next,
                                obscureText: false,
                                decoration: _inputDecoration(
                                  context: context,
                                  label: 'Email',
                                  icon: Icons.alternate_email_rounded,
                                ),
                                style: theme.bodyLarge.override(
                                  font: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: theme.bodyLarge.fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: _model.emailTextControllerValidator
                                    .asValidator(context),
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                controller: _model.passwordTextController,
                                focusNode: _model.passwordFocusNode,
                                autofocus: false,
                                autofillHints: const [AutofillHints.password],
                                textInputAction: TextInputAction.done,
                                obscureText: !_model.passwordVisibility,
                                decoration: _inputDecoration(
                                  context: context,
                                  label: 'Senha',
                                  icon: Icons.lock_outline_rounded,
                                  suffixIcon: InkWell(
                                    onTap: () => safeSetState(
                                      () => _model.passwordVisibility =
                                          !_model.passwordVisibility,
                                    ),
                                    focusNode: FocusNode(skipTraversal: true),
                                    child: Icon(
                                      _model.passwordVisibility
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: theme.secondaryText,
                                      size: 20.0,
                                    ),
                                  ),
                                ),
                                style: theme.bodyLarge.override(
                                  font: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: theme.bodyLarge.fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                ),
                                validator: _model
                                    .passwordTextControllerValidator
                                    .asValidator(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        FFButtonWidget(
                          onPressed: () async {
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
                          },
                          text: 'Entrar',
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 20.0,
                          ),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 54.0,
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              24.0,
                              0.0,
                              24.0,
                              0.0,
                            ),
                            iconPadding: const EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              0.0,
                              8.0,
                              0.0,
                            ),
                            iconColor: theme.info,
                            color: theme.primary,
                            hoverColor: const Color(0xFF175984),
                            hoverTextColor: theme.info,
                            hoverElevation: 0.0,
                            textStyle: theme.titleSmall.override(
                              font: GoogleFonts.manrope(
                                fontWeight: FontWeight.w700,
                                fontStyle: theme.titleSmall.fontStyle,
                              ),
                              color: theme.info,
                              letterSpacing: 0.0,
                            ),
                            elevation: 0.0,
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ).animateOnPageLoad(
                          animationsMap['buttonOnPageLoadAnimation']!,
                        ),
                        const SizedBox(height: 18.0),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.pushNamed(
                                EsqueceuSenhaPageWidget.routeName,
                              );
                            },
                            child: Text(
                              'Esqueceu sua senha?',
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w700,
                                  fontStyle: theme.bodyMedium.fontStyle,
                                ),
                                color: theme.primary,
                                decoration: TextDecoration.underline,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.accent1,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 12.0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_user_outlined,
                                color: theme.primary,
                                size: 18.0,
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: Text(
                                  'Versão 1.0',
                                  style: theme.labelLarge.override(
                                    font: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w700,
                                      fontStyle: theme.labelLarge.fontStyle,
                                    ),
                                    color: theme.primary,
                                    letterSpacing: 0.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animateOnPageLoad(
                    animationsMap['containerOnPageLoadAnimation']!,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
