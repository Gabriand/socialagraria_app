import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

class BasicInfo extends StatefulWidget {
  const BasicInfo({super.key});

  @override
  State<BasicInfo> createState() => _BasicInfoState();
}

class _BasicInfoState extends State<BasicInfo> {
  final nombreCtrl = TextEditingController();
  final apellidoCtrl = TextEditingController();
  final edadCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                const Text(
                  "Empecemos con lo\nbásico",
                  style: TextStyle(
                    fontSize: 34,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDarker,
                  ),
                ),
                const SizedBox(height: 16),

                const Text(
                  "Cuéntanos un poco sobre ti.",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryDarker,
                  ),
                ),
                const SizedBox(height: 40),

                const Text(
                  "Nombre",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryDarker,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                _campoTexto("Tu nombre", nombreCtrl),

                const SizedBox(height: 30),

                const Text(
                  "Apellido",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryDarker,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                _campoTexto("Tu apellido", apellidoCtrl),

                const SizedBox(height: 30),

                const Text(
                  "Edad",
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryDarker,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                _campoTexto("Tu edad", edadCtrl, tipoNumerico: true),

                const SizedBox(height: 80),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDarker,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      "Siguiente",
                      style: TextStyle(fontSize: 20, color: AppColors.white),
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: TextField(
        controller: ctrl,
        keyboardType: tipoNumerico ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(fontSize: 18, color: AppColors.primary),
        ),
      ),
    );
  }
}
