import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'perfil_page_model.dart';
export 'perfil_page_model.dart';

class PerfilPageWidget extends StatefulWidget {
  const PerfilPageWidget({super.key});

  static String routeName = 'PerfilPage';
  static String routePath = '/perfilPage';

  @override
  State<PerfilPageWidget> createState() => _PerfilPageWidgetState();
}

class _PerfilPageWidgetState extends State<PerfilPageWidget> {
  late PerfilPageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PerfilPageModel());
    _model.nomeTextController ??=
        TextEditingController(text: currentUserDisplayName);
    _model.nomeFocusNode ??= FocusNode();
    _model.emailTextController ??=
        TextEditingController(text: currentUserEmail);
    _model.emailFocusNode ??= FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    FocusScope.of(context).unfocus();

    if (_model.formKey.currentState == null ||
        !_model.formKey.currentState!.validate()) {
      return;
    }

    final nome = _model.nomeTextController.text.trim();
    final email = _model.emailTextController.text.trim();

    if (currentUserReference == null) {
      return;
    }

    await currentUserReference!.update(createUserRecordData(displayName: nome));

    if (currentUserEmail != email) {
      if (email.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Informe um e-mail válido.')),
        );
        return;
      }

      await authManager.updateEmail(email: email, context: context);
      safeSetState(() {});
    }

    if (!mounted) {
      return;
    }

    context.safePop();
  }

  InputDecoration _inputDecoration(
    BuildContext context, {
    required String label,
    required String hint,
    required IconData icon,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: theme.secondaryBackground,
      prefixIcon: Icon(icon, color: theme.secondaryText, size: 20.0),
      labelStyle: theme.labelMedium.override(
        font: GoogleFonts.notoSans(
          fontWeight: FontWeight.w700,
          fontStyle: theme.labelMedium.fontStyle,
        ),
        color: theme.secondaryText,
        letterSpacing: 0.0,
      ),
      hintStyle: theme.bodyMedium.override(
        font: GoogleFonts.notoSans(
          fontWeight: FontWeight.w600,
          fontStyle: theme.bodyMedium.fontStyle,
        ),
        color: theme.secondaryText,
        letterSpacing: 0.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.alternate, width: 1.0),
        borderRadius: BorderRadius.circular(14.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primary, width: 1.4),
        borderRadius: BorderRadius.circular(14.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.0),
        borderRadius: BorderRadius.circular(14.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.4),
        borderRadius: BorderRadius.circular(14.0),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final nome = _model.nomeTextController.text.trim().isNotEmpty
        ? _model.nomeTextController.text.trim()
        : currentUserDisplayName;
    final email = _model.emailTextController.text.trim().isNotEmpty
        ? _model.emailTextController.text.trim()
        : currentUserEmail;

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
            onPressed: () => context.safePop(),
          ),
          title: Image.asset(
            'assets/images/sinatep_logo_color.png',
            height: 28.0,
            fit: BoxFit.contain,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FlutterFlowIconButton(
                borderColor: theme.alternate,
                borderRadius: 18.0,
                borderWidth: 1.0,
                fillColor: theme.secondaryBackground,
                buttonSize: 48.0,
                showLoadingIndicator: true,
                icon: Icon(
                  Icons.check_rounded,
                  color: theme.primary,
                  size: 24.0,
                ),
                onPressed: () async => _saveProfile(),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: theme.primaryBackground,
          child: AuthUserStreamWidget(
            builder: (context) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20.0, 14.0, 20.0, 28.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760.0),
                  child: Form(
                    key: _model.formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          color: theme.secondaryBackground,
                          padding: const EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(nome, style: theme.headlineSmall),
                              const SizedBox(height: 2.0),
                              Text(
                                email,
                                style: theme.bodyMedium.override(
                                  color: theme.secondaryText,
                                ),
                              ),
                              const SizedBox(height: 2.0),
                              Text(
                                valueOrDefault<bool>(
                                        currentUserDocument?.isAdmin, false)
                                    ? 'Administrador'
                                    : 'Equipe',
                                style: theme.labelMedium.override(
                                  color: theme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        Container(
                          decoration: BoxDecoration(
                            color: theme.secondaryBackground,
                            border: Border.all(color: theme.alternate),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Dados da conta',
                                style: theme.titleMedium,
                              ),
                              const SizedBox(height: 18.0),
                              TextFormField(
                                controller: _model.nomeTextController,
                                focusNode: _model.nomeFocusNode,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                decoration: _inputDecoration(
                                  context,
                                  label: 'Nome',
                                  hint: 'Digite seu nome',
                                  icon: Icons.person_outline_rounded,
                                ),
                                style: theme.bodyLarge.override(
                                  font: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: theme.bodyLarge.fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                ),
                                keyboardType: TextInputType.name,
                                onChanged: (_) => safeSetState(() {}),
                                validator: _model.nomeTextControllerValidator
                                    .asValidator(context),
                                inputFormatters: [
                                  if (!isAndroid && !isiOS)
                                    TextInputFormatter.withFunction(
                                      (oldValue, newValue) => TextEditingValue(
                                        selection: newValue.selection,
                                        text: newValue.text.toCapitalization(
                                          TextCapitalization.words,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 14.0),
                              TextFormField(
                                controller: _model.emailTextController,
                                focusNode: _model.emailFocusNode,
                                textInputAction: TextInputAction.done,
                                decoration: _inputDecoration(
                                  context,
                                  label: 'E-mail',
                                  hint: 'Digite seu e-mail',
                                  icon: Icons.mail_outline_rounded,
                                ),
                                style: theme.bodyLarge.override(
                                  font: GoogleFonts.notoSans(
                                    fontWeight: FontWeight.w700,
                                    fontStyle: theme.bodyLarge.fontStyle,
                                  ),
                                  letterSpacing: 0.0,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (_) => safeSetState(() {}),
                                validator: _model.emailTextControllerValidator
                                    .asValidator(context),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18.0),
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context
                                .pushNamed(RedefinirSenhaPageWidget.routeName);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.secondaryBackground,
                              border: Border.all(color: theme.alternate),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 14.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: theme.primary,
                                  size: 20.0,
                                ),
                                const SizedBox(width: 12.0),
                                Expanded(
                                  child: Text(
                                    'Redefinir senha',
                                    style: theme.titleSmall,
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right,
                                  color: theme.secondaryText,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        SizedBox(
                          height: 56.0,
                          child: ElevatedButton.icon(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primary,
                              foregroundColor: theme.info,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                            ),
                            icon: const Icon(Icons.check_rounded, size: 20.0),
                            label: Text(
                              'Salvar alterações',
                              style: theme.titleSmall.override(
                                font: GoogleFonts.notoSans(
                                  fontWeight: FontWeight.w800,
                                  fontStyle: theme.titleSmall.fontStyle,
                                ),
                                color: theme.info,
                                letterSpacing: 0.0,
                              ),
                            ),
                          ),
                        ),
                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 12.0),
                          Text(
                            'E-mail atual: $email',
                            textAlign: TextAlign.center,
                            style: theme.bodySmall.override(
                              font: GoogleFonts.notoSans(
                                fontWeight: FontWeight.w700,
                                fontStyle: theme.bodySmall.fontStyle,
                              ),
                              color: theme.secondaryText,
                              letterSpacing: 0.0,
                            ),
                          ),
                        ],
                      ],
                    ),
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
