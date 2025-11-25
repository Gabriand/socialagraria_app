import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/views/screens/photos_info.dart';

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final edadCtrl = TextEditingController();
  final telefonoCtrl = TextEditingController();

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
                _campoTexto("Tu edad", edadCtrl, tipoNumerico: true),

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
                ),

                const SizedBox(height: 80),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PhotosInfo(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDarker,
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
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
        border: Border.all(color: AppColors.accent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppDimens.espacioMedium),
      child: TextField(
        controller: ctrl,
        keyboardType: tipoNumerico ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(
            fontSize: AppDimens.fontSizeSubtitle,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}
