import 'dart:ui';

import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/background_scene_support.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
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

  WebViewController? _backgroundSceneController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginPageModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();

    if (supportsBackgroundScene3D) {
      _backgroundSceneController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setBackgroundColor(Colors.transparent)
        ..loadFlutterAsset('assets/web3d/ambient_scene.html');
    }

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
      fillColor: Colors.white.withValues(alpha: 0.9),
      prefixIcon: Icon(
        icon,
        color: theme.primary,
        size: 20.0,
      ),
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(24.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.primary,
          width: 1.6,
        ),
        borderRadius: BorderRadius.circular(24.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.error,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(24.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: theme.error,
          width: 1.6,
        ),
        borderRadius: BorderRadius.circular(24.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 18.0,
      ),
    );
  }

  Widget _buildSignInButton(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.0),
        onTap: () async {
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
        child: Ink(
          height: 56.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [theme.primary, const Color(0xFF4B88BF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withValues(alpha: 0.38),
                blurRadius: 26.0,
                offset: const Offset(0.0, 14.0),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Entrar',
                  style: theme.titleSmall.override(
                    font: GoogleFonts.manrope(
                      fontWeight: FontWeight.w800,
                      fontStyle: theme.titleSmall.fontStyle,
                    ),
                    color: Colors.white,
                    letterSpacing: 0.0,
                  ),
                ),
                const SizedBox(width: 10.0),
                const Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 20.0,
                ),
              ],
            ),
          ),
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
        body: Stack(
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
                        theme.primaryBackground.withValues(alpha: 0.22),
                        const Color(0xFFEAF2FB).withValues(alpha: 0.22),
                        const Color(0xFFF8FBFF).withValues(alpha: 0.4),
                      ],
                      begin: const AlignmentDirectional(-1.0, -1.0),
                      end: const AlignmentDirectional(1.0, 1.0),
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 420.0),
                    child: Stack(
                      alignment: Alignment.topCenter,
                      clipBehavior: Clip.none,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(32.0),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.62),
                                  borderRadius: BorderRadius.circular(32.0),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    width: 1.2,
                                  ),
                                  boxShadow: const [
                                    BoxShadow(
                                      blurRadius: 40.0,
                                      color: Color(0x1F0F2237),
                                      offset: Offset(0.0, 24.0),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.fromLTRB(
                                  28.0,
                                  48.0,
                                  28.0,
                                  32.0,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Acesse sua conta',
                                      textAlign: TextAlign.center,
                                      style: theme.headlineMedium.override(
                                        font: GoogleFonts.sora(
                                          fontWeight: FontWeight.w800,
                                          fontStyle:
                                              theme.headlineMedium.fontStyle,
                                        ),
                                        letterSpacing: -0.6,
                                      ),
                                    ),
                                    const SizedBox(height: 10.0),
                                    Text(
                                      'Entrar no painel para consultar contratos e continuar o fluxo do app.',
                                      textAlign: TextAlign.center,
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
                                    const SizedBox(height: 32.0),
                                    Form(
                                      key: _model.formKey,
                                      autovalidateMode:
                                          AutovalidateMode.disabled,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          TextFormField(
                                            controller:
                                                _model.emailTextController,
                                            focusNode: _model.emailFocusNode,
                                            autofocus: true,
                                            autofillHints: const [
                                              AutofillHints.email
                                            ],
                                            textInputAction:
                                                TextInputAction.next,
                                            obscureText: false,
                                            decoration: _inputDecoration(
                                              context: context,
                                              label: 'Email',
                                              icon:
                                                  Icons.alternate_email_rounded,
                                            ),
                                            style: theme.bodyLarge.override(
                                              font: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    theme.bodyLarge.fontStyle,
                                              ),
                                              letterSpacing: 0.0,
                                            ),
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: _model
                                                .emailTextControllerValidator
                                                .asValidator(context),
                                          ),
                                          const SizedBox(height: 16.0),
                                          TextFormField(
                                            controller:
                                                _model.passwordTextController,
                                            focusNode: _model.passwordFocusNode,
                                            autofocus: false,
                                            autofillHints: const [
                                              AutofillHints.password
                                            ],
                                            textInputAction:
                                                TextInputAction.done,
                                            obscureText:
                                                !_model.passwordVisibility,
                                            decoration: _inputDecoration(
                                              context: context,
                                              label: 'Senha',
                                              icon: Icons.lock_outline_rounded,
                                              suffixIcon: InkWell(
                                                onTap: () => safeSetState(
                                                  () => _model
                                                          .passwordVisibility =
                                                      !_model
                                                          .passwordVisibility,
                                                ),
                                                focusNode: FocusNode(
                                                    skipTraversal: true),
                                                child: Icon(
                                                  _model.passwordVisibility
                                                      ? Icons
                                                          .visibility_outlined
                                                      : Icons
                                                          .visibility_off_outlined,
                                                  color: theme.secondaryText,
                                                  size: 20.0,
                                                ),
                                              ),
                                            ),
                                            style: theme.bodyLarge.override(
                                              font: GoogleFonts.manrope(
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    theme.bodyLarge.fontStyle,
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
                                    const SizedBox(height: 26.0),
                                    _buildSignInButton(context)
                                        .animateOnPageLoad(
                                      animationsMap[
                                          'buttonOnPageLoadAnimation']!,
                                    ),
                                    const SizedBox(height: 18.0),
                                    Align(
                                      alignment: Alignment.center,
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
                                              fontStyle:
                                                  theme.bodyMedium.fontStyle,
                                            ),
                                            color: theme.primary,
                                            decoration:
                                                TextDecoration.underline,
                                            letterSpacing: 0.0,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 22.0),
                                    Text(
                                      'Versão 1.0',
                                      textAlign: TextAlign.center,
                                      style: theme.labelMedium.override(
                                        font: GoogleFonts.manrope(
                                          fontWeight: FontWeight.w700,
                                          fontStyle:
                                              theme.labelMedium.fontStyle,
                                        ),
                                        color: theme.secondaryText
                                            .withValues(alpha: 0.75),
                                        letterSpacing: 0.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 176.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30.0),
                            gradient: LinearGradient(
                              colors: [theme.primary, const Color(0xFF4B88BF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(color: Colors.white, width: 4.0),
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withValues(alpha: 0.45),
                                blurRadius: 28.0,
                                offset: const Offset(0.0, 14.0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18.0,
                              vertical: 12.0,
                            ),
                            child: Image.asset(
                              'assets/images/sinatep_logo_white.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ).animateOnPageLoad(
                      animationsMap['containerOnPageLoadAnimation']!,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
