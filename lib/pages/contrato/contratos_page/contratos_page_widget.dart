import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/components/drawer/drawer_widget.dart';
import '/custom_code/contrato_consulta.dart';
import '/custom_code/contrato_validacao.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'contratos_page_model.dart';
export 'contratos_page_model.dart';

class ContratosPageWidget extends StatefulWidget {
  const ContratosPageWidget({super.key, this.filtroInicial = 'todos'});

  final String filtroInicial;

  static String routeName = 'ContratosPage';
  static String routePath = '/contratosPage';

  @override
  State<ContratosPageWidget> createState() => _ContratosPageWidgetState();
}

class _ContratosPageWidgetState extends State<ContratosPageWidget> {
  late ContratosPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _cidadeController = TextEditingController();

  String _filtro = 'todos';
  int _limite = 40;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContratosPageModel());
    _filtro = widget.filtroInicial;

    _model.pesquisarPorCidadeTextController ??= TextEditingController();
    _model.pesquisarPorCidadeFocusNode ??= FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _cidadeController.dispose();
    _model.dispose();

    super.dispose();
  }

  void _atualizarBusca() {
    EasyDebounce.debounce(
      'busca-contratos',
      const Duration(milliseconds: 350),
      () {
        if (mounted) safeSetState(() => _limite = 40);
      },
    );
  }

  Query _consulta(Query contratoRecord) {
    final consulta = montarConsulta(
      admin: currentUserDocument?.isAdmin == true,
      filtro: _filtro,
      termo: _model.pesquisarPorCidadeTextController?.text ?? '',
      cidade: _cidadeController.text,
    );
    var query = contratoRecord;
    if (consulta.restringeCriador) {
      query = query.where('criador', isEqualTo: currentUserReference);
    }
    for (final igualdade in consulta.igualdades) {
      query = query.where(igualdade.campo, isEqualTo: igualdade.valor);
    }
    final prefixo = consulta.prefixo;
    if (consulta.prefixoCampo != null && prefixo != null && prefixo.isNotEmpty) {
      query = query
          .where(consulta.prefixoCampo!, isGreaterThanOrEqualTo: prefixo)
          .where(consulta.prefixoCampo!, isLessThanOrEqualTo: '$prefixo\uf8ff');
    }
    if (consulta.ordenar) {
      query = query.orderBy(consulta.ordenarPor, descending: consulta.descendente);
    }
    return query;
  }

  bool _mostrar(ContratoRecord contrato) {
    final consulta = montarConsulta(
      admin: currentUserDocument?.isAdmin == true,
      filtro: _filtro,
      termo: _model.pesquisarPorCidadeTextController?.text ?? '',
      cidade: _cidadeController.text,
    );
    return passaFiltroLocal(
      filtro: consulta.filtroLocal,
      assinado: contrato.contratoAssinado,
      enviado: contrato.autentiqueId.isNotEmpty ||
          contrato.autentiqueStatus == 'enviado',
      cidadeContrato: contrato.cidade,
      cidadeBusca: _cidadeController.text,
      filtrarCidadeLocal: consulta.filtrarCidadeLocal,
    );
  }

  InputDecoration _searchDecoration(
    BuildContext context, {
    required String label,
    required IconData icon,
    required bool mostrarLimpar,
    required VoidCallback aoLimpar,
  }) {
    final theme = FlutterFlowTheme.of(context);

    return InputDecoration(
      labelText: label,
      labelStyle: theme.labelMedium.override(
        color: theme.secondaryText,
      ),
      filled: true,
      fillColor: theme.secondaryBackground,
      prefixIcon: Icon(
        icon,
        color: theme.secondaryText,
        size: 20.0,
      ),
      suffixIcon: mostrarLimpar
          ? InkWell(
              onTap: aoLimpar,
              child: Icon(
                Icons.close_rounded,
                color: theme.secondaryText,
                size: 20.0,
              ),
            )
          : null,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.alternate),
        borderRadius: BorderRadius.circular(14.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.primary, width: 1.3),
        borderRadius: BorderRadius.circular(14.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error),
        borderRadius: BorderRadius.circular(14.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: theme.error, width: 1.3),
        borderRadius: BorderRadius.circular(14.0),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 12.0,
        vertical: 12.0,
      ),
    );
  }

  Widget _buildContratoCard(
    BuildContext context,
    ContratoRecord contrato,
  ) {
    final theme = FlutterFlowTheme.of(context);

    final situacao = seloSituacao(
      assinado: contrato.contratoAssinado,
      testemunha: contrato.contratoTestemunha,
      enviado: contrato.autentiqueId.isNotEmpty ||
          contrato.autentiqueStatus == 'enviado',
      temPdf: contrato.pdf.isNotEmpty || contrato.signedUrl.isNotEmpty,
    );
    final corSituacao = contrato.contratoAssinado
        ? theme.success
        : contrato.autentiqueStatus == 'enviado'
            ? theme.primary
            : theme.warning;

    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0F1B2836),
            blurRadius: 16.0,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () async {
          context.pushNamed(
            VerContratoPageWidget.routeName,
            queryParameters: {
              'contrato': serializeParam(
                contrato,
                ParamType.Document,
              ),
              'contratoAssinado': serializeParam(
                contrato.contratoAssinado,
                ParamType.bool,
              ),
              'contratoTestemunha': serializeParam(
                contrato.contratoTestemunha,
                ParamType.bool,
              ),
              'nomeTxt': serializeParam(
                contrato.contratante,
                ParamType.String,
              ),
            }.withoutNulls,
            extra: <String, dynamic>{
              'contrato': contrato,
            },
          );
        },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: SizedBox(
                    width: 48.0,
                    height: 48.0,
                    child: contrato.fotoCliente.isEmpty
                        ? ColoredBox(
                            color: theme.accent4,
                            child: Icon(
                              Icons.person,
                              color: theme.secondaryText,
                              size: 22.0,
                            ),
                          )
                        : CachedNetworkImage(
                            imageUrl: contrato.fotoCliente,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => ColoredBox(
                              color: theme.accent4,
                              child: Icon(
                                Icons.person,
                                color: theme.secondaryText,
                                size: 22.0,
                              ),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contrato.contratante,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.titleSmall,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        [
                          if (contrato.numeroDoc > 0)
                            'Nº ${contrato.numeroDoc}',
                          if (contrato.cidade.isNotEmpty) contrato.cidade,
                          if (contrato.documento.isNotEmpty)
                            contrato.documento,
                        ].join('  ·  '),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.bodySmall.override(
                          color: theme.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      situacao,
                      style: theme.labelSmall.override(
                        color: corSituacao,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (contrato.criadoEm != null) ...[
                      const SizedBox(height: 2.0),
                      Text(
                        dateTimeFormat(
                          'd/M/y',
                          contrato.criadoEm!,
                          locale: FFLocalizations.of(context).languageCode,
                        ),
                        style: theme.labelSmall,
                      ),
                    ],
                  ],
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
        drawer: Drawer(
          elevation: 0.0,
          child: wrapWithModel(
            model: _model.drawerModel,
            updateCallback: () => safeSetState(() {}),
            child: const DrawerWidget(),
          ),
        ),
        body: SafeArea(
              child: Column(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.secondaryBackground,
                      border: Border(
                        bottom: BorderSide(color: theme.alternate),
                      ),
                    ),
                    child: SizedBox(
                      height: 60.0,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () =>
                                scaffoldKey.currentState!.openDrawer(),
                            icon: Icon(
                              Icons.menu_rounded,
                              color: theme.primaryText,
                            ),
                          ),
                          Image.asset(
                            'assets/images/sinatep_logo_color.png',
                            height: 28.0,
                            fit: BoxFit.contain,
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.primary,
                                foregroundColor: Colors.white,
                                elevation: 0.0,
                                minimumSize: const Size(0.0, 36.0),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              onPressed: () async {
                                context.pushNamed(
                                  RegistrarContratoPageWidget.routeName,
                                );
                              },
                              child: Text(
                                'Novo contrato',
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
                  Expanded(
                    child: ColoredBox(
                      color: theme.primaryBackground,
                      child: SingleChildScrollView(
                      padding:
                          const EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 20.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 960.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                                        Text(
                                          'Contratos',
                                          style: theme.headlineSmall,
                                        ),
                                        const SizedBox(height: 12.0),
                                        TextFormField(
                                          controller: _model
                                              .pesquisarPorCidadeTextController,
                                          focusNode: _model
                                              .pesquisarPorCidadeFocusNode,
                                          onChanged: (_) => _atualizarBusca(),
                                          autofocus: false,
                                          textCapitalization:
                                              TextCapitalization.words,
                                          textInputAction: TextInputAction.next,
                                          obscureText: false,
                                          decoration: _searchDecoration(
                                            context,
                                            label: 'Nome, CPF ou número',
                                            icon: Icons.search_rounded,
                                            mostrarLimpar: _model
                                                    .pesquisarPorCidadeTextController
                                                    ?.text
                                                    .isNotEmpty ??
                                                false,
                                            aoLimpar: () {
                                              _model.pesquisarPorCidadeTextController
                                                  ?.clear();
                                              safeSetState(() => _limite = 40);
                                            },
                                          ),
                                          style: theme.bodyLarge,
                                        ),
                                        const SizedBox(height: 12.0),
                                        TextFormField(
                                          controller: _cidadeController,
                                          onChanged: (_) => _atualizarBusca(),
                                          textCapitalization:
                                              TextCapitalization.words,
                                          decoration: _searchDecoration(
                                            context,
                                            label: 'Cidade',
                                            icon: Icons.location_on_outlined,
                                            mostrarLimpar: _cidadeController
                                                .text.isNotEmpty,
                                            aoLimpar: () {
                                              _cidadeController.clear();
                                              safeSetState(() => _limite = 40);
                                            },
                                          ),
                                          style: theme.bodyLarge,
                                        ),
                                        const SizedBox(height: 4.0),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              for (final item in const [
                                                ['todos', 'Todos'],
                                                ['pendentes', 'Pendentes'],
                                                ['enviados', 'Enviados'],
                                                ['assinados', 'Assinados'],
                                              ])
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    right: 8.0,
                                                  ),
                                                  child: InkWell(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      20.0,
                                                    ),
                                                    onTap: () =>
                                                        safeSetState(() {
                                                      _filtro = item[0];
                                                      _limite = 40;
                                                    }),
                                                    child: Container(
                                                      padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                        horizontal: 14.0,
                                                        vertical: 8.0,
                                                      ),
                                                      decoration:
                                                          BoxDecoration(
                                                        color: _filtro ==
                                                                item[0]
                                                            ? theme.primary
                                                            : theme
                                                                .secondaryBackground,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          20.0,
                                                        ),
                                                        border: Border.all(
                                                          color: _filtro ==
                                                                  item[0]
                                                              ? theme.primary
                                                              : theme.alternate,
                                                        ),
                                                      ),
                                                      child: Text(
                                                        item[1],
                                                        style: theme.titleSmall
                                                            .override(
                                                          color: _filtro ==
                                                                  item[0]
                                                              ? Colors.white
                                                              : theme
                                                                  .secondaryText,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8.0),
                                        AuthUserStreamWidget(
                                          builder: (context) => StreamBuilder<
                                              List<ContratoRecord>>(
                                            stream: queryContratoRecord(
                                              queryBuilder: _consulta,
                                              limit: _limite,
                                            ),
                                            builder: (context, snapshot) {
                                              if (!snapshot.hasData) {
                                                return Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 48.0,
                                                  ),
                                                  child: Center(
                                                    child: SizedBox(
                                                      width: 32.0,
                                                      height: 32.0,
                                                      child:
                                                          CircularProgressIndicator(
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                Color>(
                                                          theme.primary,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              }
                                              final contratos = snapshot.data!;
                                              final filtrados = contratos
                                                  .where(_mostrar)
                                                  .toList();

                                              if (filtrados.isEmpty) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                    vertical: 28.0,
                                                  ),
                                                  child: Text(
                                                    'Nenhum contrato encontrado.',
                                                    style: theme.bodyMedium
                                                        .override(
                                                      color:
                                                          theme.secondaryText,
                                                    ),
                                                  ),
                                                );
                                              }

                                              return Column(
                                                children: [
                                                  ListView.separated(
                                                    shrinkWrap: true,
                                                    physics:
                                                        const NeverScrollableScrollPhysics(),
                                                    itemCount: filtrados.length,
                                                    separatorBuilder: (_, __) =>
                                                        const SizedBox(
                                                            height: 10.0),
                                                    itemBuilder:
                                                        (context, index) {
                                                      final contrato =
                                                          filtrados[index];
                                                      return _buildContratoCard(
                                                          context, contrato);
                                                    },
                                                  ),
                                                  if (contratos.length >=
                                                      _limite)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8.0),
                                                      child: TextButton(
                                                        onPressed: () =>
                                                            safeSetState(() =>
                                                                _limite += 40),
                                                        child: const Text(
                                                            'Carregar mais'),
                                                      ),
                                                    ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
