import 'dart:io';
import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/views/screens/additional_info.dart';
import 'package:social_agraria/models/registration_data.dart';

class AffiliationInfo extends StatefulWidget {
  final RegistrationData registrationData;
  final List<File?> selectedImages;

  const AffiliationInfo({
    super.key,
    required this.registrationData,
    required this.selectedImages,
  });

  @override
  State<AffiliationInfo> createState() => _AffiliationInfoState();
}

class _AffiliationInfoState extends State<AffiliationInfo> {
  String? universidad;
  String? facultad;

  // Mapa de universidades con sus facultades reales
  final Map<String, List<String>> universidadesFacultades = {
    'Universidad de Guayaquil': [
      'Facultad de Ciencias Médicas',
      'Facultad de Ingeniería Industrial',
      'Facultad de Ingeniería Química',
      'Facultad de Ciencias Matemáticas y Físicas',
      'Facultad de Ciencias Administrativas',
      'Facultad de Ciencias Económicas',
      'Facultad de Jurisprudencia y Ciencias Sociales y Políticas',
      'Facultad de Filosofía, Letras y Ciencias de la Educación',
      'Facultad de Comunicación Social',
      'Facultad de Arquitectura y Urbanismo',
      'Facultad de Odontología',
      'Facultad de Ciencias Psicológicas',
      'Facultad de Ciencias Naturales',
      'Facultad de Ciencias Agrarias',
      'Facultad de Educación Física, Deportes y Recreación',
    ],
    'Universidad Agraria del Ecuador': [
      'Facultad de Ciencias Agrarias',
      'Facultad de Economía Agrícola',
      'Facultad de Medicina Veterinaria y Zootecnia',
      'Facultad de Ingeniería Ambiental',
      'Facultad de Ciencias de la Computación',
    ],
    'ESPOL': [
      'Facultad de Ingeniería en Electricidad y Computación (FIEC)',
      'Facultad de Ingeniería en Mecánica y Ciencias de la Producción (FIMCP)',
      'Facultad de Ingeniería en Ciencias de la Tierra (FICT)',
      'Facultad de Ciencias Naturales y Matemáticas (FCNM)',
      'Facultad de Ciencias Sociales y Humanísticas (FCSH)',
      'Facultad de Ciencias de la Vida (FCV)',
      'Facultad de Arte, Diseño y Comunicación Audiovisual (FADCOM)',
      'Escuela de Postgrado en Administración de Empresas (ESPAE)',
    ],
    'Universidad Católica de Santiago de Guayaquil': [
      'Facultad de Especialidades Empresariales',
      'Facultad de Ciencias Económicas y Administrativas',
      'Facultad de Jurisprudencia y Ciencias Sociales y Políticas',
      'Facultad de Ingeniería',
      'Facultad de Medicina',
      'Facultad de Arquitectura y Diseño',
      'Facultad de Artes y Humanidades',
      'Facultad de Educación Técnica para el Desarrollo',
      'Facultad de Ciencias Médicas',
    ],
    'Universidad de Especialidades Espíritu Santo': [
      'Facultad de Economía y Ciencias Empresariales',
      'Facultad de Derecho, Política y Desarrollo',
      'Facultad de Comunicación',
      'Facultad de Artes Liberales y Educación',
      'Facultad de Sistemas, Telecomunicaciones y Electrónica',
      'Facultad de Arquitectura e Ingeniería Civil',
      'Facultad de Medicina',
      'Facultad de Turismo y Hotelería',
    ],
    'Universidad Ecotec': [
      'Facultad de Ciencias Económicas y Empresariales',
      'Facultad de Ingeniería',
      'Facultad de Derecho y Gobernabilidad',
      'Facultad de Marketing y Comunicación',
      'Facultad de Hospitalidad y Turismo',
    ],
    'Universidad Politécnica Salesiana': [
      'Carrera de Administración de Empresas',
      'Carrera de Contabilidad y Auditoría',
      'Carrera de Ingeniería de Sistemas',
      'Carrera de Ingeniería Electrónica',
      'Carrera de Ingeniería Industrial',
      'Carrera de Ingeniería Mecánica',
      'Carrera de Comunicación',
      'Carrera de Educación',
      'Carrera de Psicología',
    ],
  };

  List<String> get facultadesDisponibles {
    if (universidad == null) return [];
    return universidadesFacultades[universidad] ?? [];
  }

  void _continueToNextStep() {
    if (universidad == null || facultad == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona universidad y facultad'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Actualizar datos de registro
    widget.registrationData.universidad = universidad;
    widget.registrationData.facultad = facultad;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AdditionalInfo(
          registrationData: widget.registrationData,
          selectedImages: widget.selectedImages,
        ),
      ),
    );
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

              Text(
                "Afiliación Universitaria",
                style: TextStyle(
                  fontSize: AppDimens.fontSizeTitleLarge,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDarker,
                ),
              ),

              SizedBox(height: AppDimens.espacioSmall),

              Text(
                "Confirma tu universidad y facultad para continuar.",
                style: TextStyle(
                  fontSize: AppDimens.fontSizeSubtitle,
                  color: AppColors.primaryDarker,
                ),
              ),

              const SizedBox(height: 45),

              // Dropdown Universidad
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
                    isExpanded: true,
                    hint: const Text(
                      "Elige tu universidad",
                      style: TextStyle(
                        color: AppColors.primaryDarker,
                        fontSize: 16,
                      ),
                    ),
                    items: universidadesFacultades.keys
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        universidad = value;
                        facultad =
                            null; // Reset facultad al cambiar universidad
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Dropdown Facultad
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
                    isExpanded: true,
                    hint: Text(
                      universidad == null
                          ? "Primero selecciona una universidad"
                          : "Selecciona tu facultad",
                      style: TextStyle(
                        color: universidad == null
                            ? AppColors.primaryDarker.withValues(alpha: 0.5)
                            : AppColors.primaryDarker,
                        fontSize: 16,
                      ),
                    ),
                    items: facultadesDisponibles
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: universidad == null
                        ? null
                        : (value) {
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
                    backgroundColor: (universidad != null && facultad != null)
                        ? AppColors.primaryDarker
                        : AppColors.accent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 6,
                  ),
                  onPressed: (universidad != null && facultad != null)
                      ? _continueToNextStep
                      : null,
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
