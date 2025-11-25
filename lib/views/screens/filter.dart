import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/app_text_styles.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  double age = 21;
  double distance = 10;

  List<String> interests = [
    "Música",
    "Arte",
    "Lectura",
    "Deportes",
    "Viajes",
    "Cine",
  ];
  List<String> selected = ["Arte", "Cine"];

  String selectedFaculty = "Todas las facultades";

  List<String> faculties = [
    "Todas las facultades",
    "Veterinaria",
    "Economía",
    "Agronomía",
    "Computación",
    "Agroindustria",
  ];

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
        centerTitle: true,
        title: Text('Filtros', style: AppTextStyles.titleMedium),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            filterCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      title("Rango de edad"),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "18 - ${age.toInt()}",
                          style: TextStyle(
                            color: AppColors.primaryDarker,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: age,
                    min: 18,
                    max: 30,
                    activeColor: AppColors.primaryDarker,
                    inactiveColor: AppColors.primaryDarker,
                    thumbColor: AppColors.white,
                    onChanged: (v) {
                      setState(() => age = v);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            filterCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      title("Distancia"),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "Hasta ${distance.toInt()} km",
                          style: TextStyle(
                            color: AppColors.primaryDarker,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: distance,
                    min: 1,
                    max: 10,
                    activeColor: AppColors.primaryDarker,
                    inactiveColor: AppColors.primaryDarker,
                    thumbColor: AppColors.white,
                    onChanged: (v) {
                      setState(() => distance = v);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            filterCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title("Facultad"),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusRound,
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedFaculty,
                        isExpanded: true,
                        icon: Icon(
                          Icons.expand_more,
                          color: AppColors.primaryDarker,
                        ),
                        style: TextStyle(
                          color: AppColors.primaryDarker,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                        items: faculties
                            .map(
                              (f) => DropdownMenuItem(value: f, child: Text(f)),
                            )
                            .toList(),
                        onChanged: (v) {
                          setState(() => selectedFaculty = v!);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            filterCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  title("Intereses"),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 40,
                    runSpacing: 20,
                    children: interests.map((i) {
                      bool isSelected = selected.contains(i);
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  selected.remove(i);
                                } else {
                                  selected.add(i);
                                }
                              });
                            },
                            child: Container(
                              width: 26,
                              height: 26,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                  color: AppColors.primaryDarker,
                                  width: 2,
                                ),
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                              ),
                              child: isSelected
                                  ? Icon(
                                      Icons.check,
                                      size: 18,
                                      color: AppColors.white,
                                      fontWeight: FontWeight.bold,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            i,
                            style: TextStyle(
                              color: AppColors.primaryDarker,
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(
                    "Aplicar Filtros",
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                "Restablecer",
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget title(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AppColors.primaryDarker,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget filterCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(30),
      ),
      child: child,
    );
  }
}
