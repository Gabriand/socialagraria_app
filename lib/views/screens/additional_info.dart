import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

class AdditionalInfo extends StatefulWidget {
  const AdditionalInfo({super.key});

  @override
  State<AdditionalInfo> createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  final TextEditingController bioController = TextEditingController();

  List<String> intereses = [
    "Música",
    "Cine",
    "Deportes",
    "Viajar",
    "Arte",
    "Leer",
    "Tecnología",
    "Cocina",
  ];

  List<String> seleccionados = ["Música", "Deportes", "Leer"];

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
                const SizedBox(height: 20),

                const Text(
                  "Ya casi terminas",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDarker,
                  ),
                ),
                const SizedBox(height: 12),

                const Text(
                  "Añade una biografía y selecciona tus\nintereses para completar tu perfil.",
                  style: TextStyle(
                    fontSize: 17,
                    color: AppColors.primaryDarker,
                  ),
                ),
                const SizedBox(height: 30),

                const Text(
                  "Tu Biografía",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarker,
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.accent),
                  ),
                  height: 150,
                  child: TextField(
                    controller: bioController,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Escribe algo sobre ti…",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                const Text(
                  "Tus Intereses",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarker,
                  ),
                ),
                const SizedBox(height: 20),

                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: intereses.map((interes) {
                    bool isSelected = seleccionados.contains(interes);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            seleccionados.remove(interes);
                          } else {
                            seleccionados.add(interes);
                          }
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 22,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.accent,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          interes,
                          style: TextStyle(
                            // quitar const para usar valor dinámico
                            fontSize: 18,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primaryDarker,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 60),

                /// Botón final
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      backgroundColor: AppColors.primaryDarker,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Finalizar",
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
}
