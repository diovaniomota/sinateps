import '/backend/api_requests/api_calls.dart';
import '/backend/backend.dart';
import '/backend/custom_cloud_functions/custom_cloud_function_response_manager.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'registrar_contrato_page_widget.dart' show RegistrarContratoPageWidget;
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegistrarContratoPageModel
    extends FlutterFlowModel<RegistrarContratoPageWidget> {
  ///  Local state fields for this page.

  bool txtCarregando = false;

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for Contratante widget.
  FocusNode? contratanteFocusNode;
  TextEditingController? contratanteTextController;
  String? Function(BuildContext, String?)? contratanteTextControllerValidator;
  // State field(s) for Documento widget.
  FocusNode? documentoFocusNode;
  TextEditingController? documentoTextController;
  late MaskTextInputFormatter documentoMask;
  String? Function(BuildContext, String?)? documentoTextControllerValidator;
  // State field(s) for RG widget.
  FocusNode? rgFocusNode;
  TextEditingController? rgTextController;
  late MaskTextInputFormatter rgMask;
  String? Function(BuildContext, String?)? rgTextControllerValidator;
  // State field(s) for DN widget.
  FocusNode? dnFocusNode;
  TextEditingController? dnTextController;
  late MaskTextInputFormatter dnMask;
  String? Function(BuildContext, String?)? dnTextControllerValidator;
  // State field(s) for Filiacao widget.
  FocusNode? filiacaoFocusNode;
  TextEditingController? filiacaoTextController;
  String? Function(BuildContext, String?)? filiacaoTextControllerValidator;
  // State field(s) for Naturalidade widget.
  FocusNode? naturalidadeFocusNode;
  TextEditingController? naturalidadeTextController;
  String? Function(BuildContext, String?)? naturalidadeTextControllerValidator;
  // State field(s) for Sexo widget.
  String? sexoValue;
  FormFieldController<String>? sexoValueController;
  // State field(s) for CEP widget.
  FocusNode? cepFocusNode;
  TextEditingController? cepTextController;
  late MaskTextInputFormatter cepMask;
  String? Function(BuildContext, String?)? cepTextControllerValidator;
  // Stores action output result for [Backend Call - API (getEndereco)] action in IconButton widget.
  ApiCallResponse? cep;
  // State field(s) for Endereco widget.
  FocusNode? enderecoFocusNode;
  TextEditingController? enderecoTextController;
  String? Function(BuildContext, String?)? enderecoTextControllerValidator;
  // State field(s) for Numero widget.
  FocusNode? numeroFocusNode;
  TextEditingController? numeroTextController;
  String? Function(BuildContext, String?)? numeroTextControllerValidator;
  // State field(s) for Bairro widget.
  FocusNode? bairroFocusNode;
  TextEditingController? bairroTextController;
  String? Function(BuildContext, String?)? bairroTextControllerValidator;
  // State field(s) for Cidade widget.
  FocusNode? cidadeFocusNode;
  TextEditingController? cidadeTextController;
  String? Function(BuildContext, String?)? cidadeTextControllerValidator;
  // State field(s) for UF widget.
  FocusNode? ufFocusNode;
  TextEditingController? ufTextController;
  late MaskTextInputFormatter ufMask;
  String? Function(BuildContext, String?)? ufTextControllerValidator;
  // State field(s) for Telefones widget.
  FocusNode? telefonesFocusNode;
  TextEditingController? telefonesTextController;
  late MaskTextInputFormatter telefonesMask;
  String? Function(BuildContext, String?)? telefonesTextControllerValidator;
  // State field(s) for Aluno widget.
  FocusNode? alunoFocusNode;
  TextEditingController? alunoTextController;
  String? Function(BuildContext, String?)? alunoTextControllerValidator;
  // State field(s) for AlunoDN widget.
  FocusNode? alunoDNFocusNode;
  TextEditingController? alunoDNTextController;
  late MaskTextInputFormatter alunoDNMask;
  String? Function(BuildContext, String?)? alunoDNTextControllerValidator;
  // State field(s) for AlunoDocumento widget.
  FocusNode? alunoDocumentoFocusNode;
  TextEditingController? alunoDocumentoTextController;
  String? Function(BuildContext, String?)?
      alunoDocumentoTextControllerValidator;
  // State field(s) for AlunoNaturalidade widget.
  FocusNode? alunoNaturalidadeFocusNode;
  TextEditingController? alunoNaturalidadeTextController;
  String? Function(BuildContext, String?)?
      alunoNaturalidadeTextControllerValidator;
  // State field(s) for AlunoTelefone widget.
  FocusNode? alunoTelefoneFocusNode;
  TextEditingController? alunoTelefoneTextController;
  late MaskTextInputFormatter alunoTelefoneMask;
  String? Function(BuildContext, String?)? alunoTelefoneTextControllerValidator;
  // State field(s) for OpcaoCurso widget.
  String? opcaoCursoValue;
  FormFieldController<String>? opcaoCursoValueController;
  // State field(s) for Outro widget.
  FocusNode? outroFocusNode;
  TextEditingController? outroTextController;
  String? Function(BuildContext, String?)? outroTextControllerValidator;
  // State field(s) for Indicacao widget.
  FocusNode? indicacaoFocusNode;
  TextEditingController? indicacaoTextController;
  String? Function(BuildContext, String?)? indicacaoTextControllerValidator;
  // State field(s) for Horas widget.
  FocusNode? horasFocusNode;
  TextEditingController? horasTextController;
  String? Function(BuildContext, String?)? horasTextControllerValidator;
  // State field(s) for InicioPrevisto widget.
  FocusNode? inicioPrevistoFocusNode;
  TextEditingController? inicioPrevistoTextController;
  late MaskTextInputFormatter inicioPrevistoMask;
  String? Function(BuildContext, String?)?
      inicioPrevistoTextControllerValidator;
  // State field(s) for Contratada widget.
  FocusNode? contratadaFocusNode;
  TextEditingController? contratadaTextController;
  String? Function(BuildContext, String?)? contratadaTextControllerValidator;
  // State field(s) for PagementoOp3 widget.
  String? pagementoOp3Value;
  FormFieldController<String>? pagementoOp3ValueController;
  // State field(s) for Pagemento widget.
  String? pagementoValue;
  FormFieldController<String>? pagementoValueController;
  // State field(s) for PrimeiraParcela widget.
  FocusNode? primeiraParcelaFocusNode;
  TextEditingController? primeiraParcelaTextController;
  late MaskTextInputFormatter primeiraParcelaMask;
  String? Function(BuildContext, String?)?
      primeiraParcelaTextControllerValidator;
  // State field(s) for Desconto widget.
  FocusNode? descontoFocusNode;
  TextEditingController? descontoTextController;
  String? Function(BuildContext, String?)? descontoTextControllerValidator;
  // State field(s) for Email widget.
  FocusNode? emailFocusNode;
  TextEditingController? emailTextController;
  String? Function(BuildContext, String?)? emailTextControllerValidator;
  // Stores action output result for [Firestore Query - Query a collection] action in Gerar widget.
  int? count;
  // Stores action output result for [Backend Call - Create Document] action in Gerar widget.
  ContratoRecord? contratoDoc;
  // Stores action output result for [Cloud Function - criarPDF] action in Gerar widget.
  CriarPDFCloudFunctionCallResponse? func01;
  // Stores action output result for [Cloud Function - escreverPDF] action in Gerar widget.
  EscreverPDFCloudFunctionCallResponse? func02;
  // Stores action output result for [Cloud Function - deletarPDF] action in Gerar widget.
  DeletarPDFCloudFunctionCallResponse? cloudFunctionq93;
  // Stores action output result for [Cloud Function - criarPDF] action in Gerar widget.
  CriarPDFCloudFunctionCallResponse? cloudFunctions6g;
  // Stores action output result for [Cloud Function - escreverPDF] action in Gerar widget.
  EscreverPDFCloudFunctionCallResponse? cloudFunctionf9l;
  // Stores action output result for [Cloud Function - assinarContrato] action in Gerar widget.
  AssinarContratoCloudFunctionCallResponse? cloudFunctionap7;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    contratanteFocusNode?.dispose();
    contratanteTextController?.dispose();

    documentoFocusNode?.dispose();
    documentoTextController?.dispose();

    rgFocusNode?.dispose();
    rgTextController?.dispose();

    dnFocusNode?.dispose();
    dnTextController?.dispose();

    filiacaoFocusNode?.dispose();
    filiacaoTextController?.dispose();

    naturalidadeFocusNode?.dispose();
    naturalidadeTextController?.dispose();

    cepFocusNode?.dispose();
    cepTextController?.dispose();

    enderecoFocusNode?.dispose();
    enderecoTextController?.dispose();

    numeroFocusNode?.dispose();
    numeroTextController?.dispose();

    bairroFocusNode?.dispose();
    bairroTextController?.dispose();

    cidadeFocusNode?.dispose();
    cidadeTextController?.dispose();

    ufFocusNode?.dispose();
    ufTextController?.dispose();

    telefonesFocusNode?.dispose();
    telefonesTextController?.dispose();

    alunoFocusNode?.dispose();
    alunoTextController?.dispose();

    alunoDNFocusNode?.dispose();
    alunoDNTextController?.dispose();

    alunoDocumentoFocusNode?.dispose();
    alunoDocumentoTextController?.dispose();

    alunoNaturalidadeFocusNode?.dispose();
    alunoNaturalidadeTextController?.dispose();

    alunoTelefoneFocusNode?.dispose();
    alunoTelefoneTextController?.dispose();

    outroFocusNode?.dispose();
    outroTextController?.dispose();

    indicacaoFocusNode?.dispose();
    indicacaoTextController?.dispose();

    horasFocusNode?.dispose();
    horasTextController?.dispose();

    inicioPrevistoFocusNode?.dispose();
    inicioPrevistoTextController?.dispose();

    contratadaFocusNode?.dispose();
    contratadaTextController?.dispose();

    primeiraParcelaFocusNode?.dispose();
    primeiraParcelaTextController?.dispose();

    descontoFocusNode?.dispose();
    descontoTextController?.dispose();

    emailFocusNode?.dispose();
    emailTextController?.dispose();
  }
}
