import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

class AffiliationInfo extends StatefulWidget {
  const AffiliationInfo({super.key});

  @override
  State<AffiliationInfo> createState() => _AffiliationInfoState();
}

class _AffiliationInfoState extends State<AffiliationInfo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AfiliacionUniversitariaPage(),
    );
  }
}

class AfiliacionUniversitariaPage extends StatefulWidget {
  const AfiliacionUniversitariaPage({super.key});

  @override
  State<AfiliacionUniversitariaPage> createState() =>
      _AfiliacionUniversitariaPageState();
}

class _AfiliacionUniversitariaPageState
    extends State<AfiliacionUniversitariaPage> {
  String? universidad;
  String? facultad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              const Icon(
                Icons.account_balance_outlined,
                size: 70,
                color: AppColors.primaryDarker,
              ),

              const SizedBox(height: 20),

              const Text(
                "Afiliación Universitaria",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDarker,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Confirma tu universidad y facultad para continuar.",
                style: TextStyle(fontSize: 18, color: AppColors.primaryDarker),
              ),

              const SizedBox(height: 45),

              // Dropdown 1
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: universidad,
                    hint: const Text(
                      "Elige tu universidad",
                      style: TextStyle(
                        color: AppColors.primaryDarker,
                        fontSize: 18,
                      ),
                    ),
                    items: ["UAE", "UG", "ESPOL", "UESS", "UCSG"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (value) {
                      setState(() => universidad = value);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Dropdown 2
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.accent),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: facultad,
                    hint: const Text(
                      "Selecciona tu facultad",
                      style: TextStyle(
                        color: AppColors.primaryDarker,
                        fontSize: 18,
                      ),
                    ),
                    items:
                        [
                              "Ingeniería",
                              "Ciencias Médicas",
                              "Derecho",
                              "Ciencias Económicas",
                            ]
                            .map(
                              (e) => DropdownMenuItem(value: e, child: Text(e)),
                            )
                            .toList(),
                    onChanged: (value) {
                      setState(() => facultad = value);
                    },
                  ),
                ),
              ),

              const Spacer(),

              // Botón siguiente
              SizedBox(
                width: double.infinity,
                height: 65,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarker,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Siguiente",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
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
