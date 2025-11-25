import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/root.dart';

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
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryDarker),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: AppDimens.espacioSmall),

                Text(
                  "Ya casi terminas",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeTitleLarge,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDarker,
                  ),
                ),
                SizedBox(height: AppDimens.espacioSmall),

                Text(
                  "Añade una biografía y selecciona tus\nintereses para completar tu perfil.",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeBody,
                    color: AppColors.primaryDarker,
                  ),
                ),
                SizedBox(height: AppDimens.espacioLarge),

                Text(
                  "Tu Biografía",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarker,
                  ),
                ),
                SizedBox(height: AppDimens.espacioSmall),

                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
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

                SizedBox(height: AppDimens.espacioXLarge),

                Text(
                  "Tus Intereses",
                  style: TextStyle(
                    fontSize: AppDimens.fontSizeSubtitle,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarker,
                  ),
                ),
                SizedBox(height: AppDimens.espacioLarge),

                Wrap(
                  spacing: AppDimens.espacioMedium,
                  runSpacing: AppDimens.espacioMedium,
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
                          borderRadius: BorderRadius.circular(
                            AppDimens.radiusXLarge,
                          ),
                        ),
                        child: Text(
                          interes,
                          style: TextStyle(
                            fontSize: AppDimens.fontSizeSubtitle,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primaryDarker,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                SizedBox(height: AppDimens.spacing2XLarge),

                /// Botón final
                SizedBox(
                  width: double.infinity,
                  height: AppDimens.buttonHeightMedium,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryDarker,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusMedium,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).pushReplacement(PageTransitions.fade(const Root()));
                    },
                    child: Text(
                      "Finalizar",
                      style: TextStyle(
                        fontSize: AppDimens.fontSizeSubtitle,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppDimens.spacing2XLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
