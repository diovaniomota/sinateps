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
        font: GoogleFonts.manrope(
          fontWeight: FontWeight.w700,
          fontStyle: theme.labelMedium.fontStyle,
        ),
        color: theme.secondaryText,
        letterSpacing: 0.0,
      ),
      hintStyle: theme.bodyMedium.override(
        font: GoogleFonts.manrope(
          fontWeight: FontWeight.w600,
          fontStyle: theme.bodyMedium.fontStyle,
        ),
        color: theme.secondaryText,
        letterSpacing: 0.0,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.alternate, width: 1.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primary, width: 1.4),
        borderRadius: BorderRadius.circular(20.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.4),
        borderRadius: BorderRadius.circular(20.0),
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

    Widget infoChip(IconData icon, String label) => Container(
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
                Icons.arrow_back_rounded,
                color: theme.primaryText,
                size: 24.0,
              ),
              onPressed: () async => context.safePop(),
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
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF5F8FC), Color(0xFFEAF2FB)],
              begin: AlignmentDirectional(0.0, -1.0),
              end: AlignmentDirectional(0.0, 1.0),
            ),
          ),
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
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [theme.primary, const Color(0xFF4E88BC)],
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
                              Row(
                                children: [
                                  Container(
                                    width: 62.0,
                                    height: 62.0,
                                    decoration: BoxDecoration(
                                      color:
                                          Colors.white.withValues(alpha: 0.16),
                                      borderRadius: BorderRadius.circular(22.0),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      _initials(nome),
                                      style: theme.headlineSmall.override(
                                        font: GoogleFonts.sora(
                                          fontWeight: FontWeight.w700,
                                          fontStyle:
                                              theme.headlineSmall.fontStyle,
                                        ),
                                        color: theme.info,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14.0),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Meu perfil',
                                          style: theme.headlineSmall.override(
                                            font: GoogleFonts.sora(
                                              fontWeight: FontWeight.w700,
                                              fontStyle:
                                                  theme.headlineSmall.fontStyle,
                                            ),
                                            color: theme.info,
                                            letterSpacing: -0.3,
                                          ),
                                        ),
                                        const SizedBox(height: 6.0),
                                        Text(
                                          'Atualize seus dados com uma leitura mais clara e uma navegação mais tranquila.',
                                          style: theme.bodyMedium.override(
                                            font: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w600,
                                              fontStyle:
                                                  theme.bodyMedium.fontStyle,
                                            ),
                                            color: Colors.white
                                                .withValues(alpha: 0.86),
                                            letterSpacing: 0.0,
                                            lineHeight: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18.0),
                              Wrap(
                                spacing: 10.0,
                                runSpacing: 10.0,
                                children: [
                                  infoChip(Icons.person_outline_rounded, nome),
                                  infoChip(
                                    currentUserEmailVerified
                                        ? Icons.verified_outlined
                                        : Icons.mark_email_unread_outlined,
                                    currentUserEmailVerified
                                        ? 'E-mail verificado'
                                        : 'Verificação pendente',
                                  ),
                                  infoChip(
                                    valueOrDefault<bool>(
                                            currentUserDocument?.isAdmin, false)
                                        ? Icons.workspace_premium_outlined
                                        : Icons.badge_outlined,
                                    valueOrDefault<bool>(
                                            currentUserDocument?.isAdmin, false)
                                        ? 'Administrador'
                                        : 'Conta ativa',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
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
                                'Dados da conta',
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
                                'Mantenha seu nome e e-mail atualizados para facilitar o acesso e a recuperação da conta.',
                                style: theme.bodyMedium.override(
                                  font: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    fontStyle: theme.bodyMedium.fontStyle,
                                  ),
                                  color: theme.secondaryText,
                                  letterSpacing: 0.0,
                                  lineHeight: 1.35,
                                ),
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
                                  font: GoogleFonts.manrope(
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
                                  font: GoogleFonts.manrope(
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
                              borderRadius: BorderRadius.circular(30.0),
                              border: Border.all(color: theme.alternate),
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 52.0,
                                  height: 52.0,
                                  decoration: BoxDecoration(
                                    color: theme.accent4,
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  child: Icon(
                                    Icons.lock_reset_rounded,
                                    color: theme.primary,
                                    size: 24.0,
                                  ),
                                ),
                                const SizedBox(width: 14.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Segurança da conta',
                                        style: theme.titleMedium.override(
                                          font: GoogleFonts.sora(
                                            fontWeight: FontWeight.w700,
                                            fontStyle:
                                                theme.titleMedium.fontStyle,
                                          ),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      const SizedBox(height: 6.0),
                                      Text(
                                        'Redefina sua senha quando precisar e mantenha o acesso protegido.',
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
                                ),
                                const SizedBox(width: 12.0),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: theme.secondaryText,
                                  size: 18.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 22.0),
                        SizedBox(
                          height: 56.0,
                          child: ElevatedButton.icon(
                            onPressed: _saveProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.primary,
                              foregroundColor: theme.info,
                              elevation: 0.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                            ),
                            icon: const Icon(Icons.check_rounded, size: 20.0),
                            label: Text(
                              'Salvar alterações',
                              style: theme.titleSmall.override(
                                font: GoogleFonts.manrope(
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
                              font: GoogleFonts.manrope(
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
