import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/views/screens/personal_details.dart';
import 'package:social_agraria/models/registration_data.dart';

class BasicInfo extends StatefulWidget {
  final RegistrationData registrationData;

  const BasicInfo({super.key, required this.registrationData});

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final edadCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Agregar listeners para actualizar el estado cuando cambian los campos
    nombreCtrl.addListener(_updateState);
    apellidoCtrl.addListener(_updateState);
    edadCtrl.addListener(_updateState);
    telefonoCtrl.addListener(_updateState);
  }

  void _updateState() {
    setState(() {});
  }

  @override
  void dispose() {
    nombreCtrl.removeListener(_updateState);
    apellidoCtrl.removeListener(_updateState);
    edadCtrl.removeListener(_updateState);
    telefonoCtrl.removeListener(_updateState);
    nombreCtrl.dispose();
    apellidoCtrl.dispose();
    edadCtrl.dispose();
    telefonoCtrl.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    if (nombreCtrl.text.trim().isEmpty ||
        apellidoCtrl.text.trim().isEmpty ||
        edadCtrl.text.trim().isEmpty ||
        telefonoCtrl.text.trim().isEmpty) {
      return false;
    }

    // Validar edad (16-99 años)
    final edad = int.tryParse(edadCtrl.text.trim());
    if (edad == null || edad < 16 || edad > 99) {
      return false;
    }

    // Validar teléfono (mínimo 7, máximo 10 dígitos)
    final telefono = telefonoCtrl.text.trim();
    if (telefono.length < 7 || telefono.length > 10) {
      return false;
    }

    return true;
  }

  String? get _edadError {
    if (edadCtrl.text.isEmpty) return null;
    final edad = int.tryParse(edadCtrl.text.trim());
    if (edad == null) return 'Ingresa un número válido';
    if (edad < 16) return 'Debes tener al menos 16 años';
    if (edad > 99) return 'Ingresa una edad válida';
    return null;
  }

  String? get _telefonoError {
    if (telefonoCtrl.text.isEmpty) return null;
    final telefono = telefonoCtrl.text.trim();
    if (telefono.length < 7) return 'Mínimo 7 dígitos';
    if (telefono.length > 10) return 'Máximo 10 dígitos';
    return null;
  }

  void _continueToNextStep() {
    if (!_isFormValid) {
      _showError('Por favor completa todos los campos correctamente');
      return;
    }

    // Actualizar datos de registro
    widget.registrationData.nombre = nombreCtrl.text.trim();
    widget.registrationData.apellido = apellidoCtrl.text.trim();
    widget.registrationData.edad = int.tryParse(edadCtrl.text);
    widget.registrationData.telefono = telefonoCtrl.text.trim();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PersonalDetails(registrationData: widget.registrationData),
      ),
    );
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryDarker),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingLarge,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppDimens.espacioMedium),

                const Text(
                  "Empecemos con lo\nbásico",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeTitleLarge,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDarker,
                  ),
                ),
                const SizedBox(height: AppDimens.espacioMedium),

                const Text(
                  "Cuéntanos un poco sobre ti.",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle,
                    color: AppColors.primaryDarker,
                  ),
                ),
                const SizedBox(height: AppDimens.spacing2XLarge),

                const Text(
                  "Nombre",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle,
                    color: AppColors.primaryDarker,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimens.espacioSmall),
                _campoTexto("Tu nombre", nombreCtrl),

                const SizedBox(height: AppDimens.espacioLarge),

                const Text(
                  "Apellido",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle,
                    color: AppColors.primaryDarker,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimens.espacioSmall),
                _campoTexto("Tu apellido", apellidoCtrl),

                const SizedBox(height: AppDimens.espacioLarge),

                const Text(
                  "Edad",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle,
                    color: AppColors.primaryDarker,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimens.espacioSmall),
                _campoTexto(
                  "Tu edad (16-99)",
                  edadCtrl,
                  tipoNumerico: true,
                  maxLength: 2,
                  errorText: _edadError,
                ),

                const SizedBox(height: AppDimens.espacioLarge),

                const Text(
                  "Número de Teléfono",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle,
                    color: AppColors.primaryDarker,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppDimens.espacioSmall),
                _campoTexto(
                  "Tu número de teléfono",
                  telefonoCtrl,
                  tipoNumerico: true,
                  maxLength: 10,
                  errorText: _telefonoError,
                ),

                const SizedBox(height: 80),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? _continueToNextStep : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isFormValid
                          ? AppColors.primaryDarker
                          : AppColors.accent,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusMedium,
                        ),
                      ),
                    ),
                    child: const Text(
                      "Siguiente",
                      style: TextStyle(
                        fontSize: AppDimens.fontSizeSubtitle,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(
    String hint,
    TextEditingController ctrl, {
    bool tipoNumerico = false,
    int? maxLength,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
            border: Border.all(
              color: errorText != null ? Colors.red : AppColors.accent,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.espacioMedium,
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: tipoNumerico
                ? TextInputType.number
                : TextInputType.text,
            inputFormatters: tipoNumerico
                ? [
                    FilteringTextInputFormatter.digitsOnly,
                    if (maxLength != null)
                      LengthLimitingTextInputFormatter(maxLength),
                  ]
                : null,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              counterText: '',
              hintStyle: const TextStyle(
                fontSize: AppDimens.fontSizeSubtitle,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Text(
              errorText,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
