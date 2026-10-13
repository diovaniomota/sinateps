import '/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'esqueceu_senha_page_model.dart';
export 'esqueceu_senha_page_model.dart';

class EsqueceuSenhaPageWidget extends StatefulWidget {
  const EsqueceuSenhaPageWidget({super.key});

  static String routeName = 'EsqueceuSenhaPage';
  static String routePath = '/esqueceuSenhaPage';

  @override
  State<EsqueceuSenhaPageWidget> createState() =>
      _EsqueceuSenhaPageWidgetState();
}

class _EsqueceuSenhaPageWidgetState extends State<EsqueceuSenhaPageWidget> {
  late EsqueceuSenhaPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EsqueceuSenhaPageModel());

    _model.emailTextController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14.0),
      borderSide: BorderSide(color: theme.alternate),
    );

    return InputDecoration(
      labelText: 'E-mail',
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

  Future<void> _enviar() async {
    _model.redefinir = true;
    if (_model.formKey.currentState == null ||
        !_model.formKey.currentState!.validate()) {
      safeSetState(() => _model.redefinir = false);
      return;
    }
    if (_model.emailTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o e-mail.'),
        ),
      );
      safeSetState(() => _model.redefinir = false);
      return;
    }
    await authManager.resetPassword(
      email: _model.emailTextController.text,
      context: context,
    );
    safeSetState(() {});
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
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 12.0,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: () => context.pop(),
                        icon: Icon(
                          Icons.arrow_back,
                          color: theme.primaryText,
                        ),
                      ),
                    ),
                    Image.asset(
                      'assets/images/sinatep_logo_color.png',
                      height: 52.0,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 28.0),
                    Text(
                      'Esqueci a senha',
                      style: theme.headlineSmall,
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      'Enviaremos um link para o e-mail cadastrado.',
                      style: theme.bodyMedium.override(
                        color: theme.secondaryText,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Form(
                      key: _model.formKey,
                      autovalidateMode: AutovalidateMode.disabled,
                      child: TextFormField(
                        controller: _model.emailTextController,
                        focusNode: _model.emailFocusNode,
                        autofocus: true,
                        autofillHints: const [AutofillHints.email],
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.emailAddress,
                        onFieldSubmitted: (_) => _enviar(),
                        decoration: _inputDecoration(context),
                        style: theme.bodyLarge,
                        validator: _model.emailTextControllerValidator
                            .asValidator(context),
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
                        onPressed: _enviar,
                        child: Text(
                          'Enviar',
                          style: theme.titleSmall.override(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
