import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/views/screens/photos_info.dart';
import 'package:social_agraria/models/registration_data.dart';

class PersonalDetails extends StatefulWidget {
  final RegistrationData registrationData;

  const PersonalDetails({super.key, required this.registrationData});

  @override
  State<PersonalDetails> createState() => _PersonalDetailsState();
}

class _PersonalDetailsState extends State<PersonalDetails> {
  final alturaCtrl = TextEditingController();

  String? _selectedGenero;
  String? _selectedSigno;
  String? _selectedBebe;
  String? _selectedFuma;
  String? _selectedBuscando;

  final List<String> _generos = [
    'Hombre',
    'Mujer',
    'No binario',
    'Prefiero no decir',
  ];

  final List<String> _signos = [
    'Aries',
    'Tauro',
    'Géminis',
    'Cáncer',
    'Leo',
    'Virgo',
    'Libra',
    'Escorpio',
    'Sagitario',
    'Capricornio',
    'Acuario',
    'Piscis',
  ];

  final List<String> _opcionesBebe = ['Nunca', 'Socialmente', 'Frecuentemente'];

  final List<String> _opcionesFuma = ['Nunca', 'Socialmente', 'Frecuentemente'];

  final List<String> _opcionesBuscando = [
    'Relación seria',
    'Algo casual',
    'Amistad',
    'No lo sé aún',
  ];

  @override
  void dispose() {
    alturaCtrl.dispose();
    super.dispose();
  }

  void _continueToNextStep() {
    // Guardar datos en registrationData
    if (alturaCtrl.text.isNotEmpty) {
      widget.registrationData.altura = int.tryParse(alturaCtrl.text);
    }
    widget.registrationData.genero = _selectedGenero;
    widget.registrationData.signoZodiacal = _selectedSigno;
    widget.registrationData.bebe = _selectedBebe;
    widget.registrationData.fuma = _selectedFuma;
    widget.registrationData.buscando = _selectedBuscando;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            PhotosInfo(registrationData: widget.registrationData),
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
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingLarge,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppDimens.espacioMedium),

                      // Icono
                      Icon(
                        Icons.person_outline,
                        size: 60,
                        color: AppColors.primaryDarker,
                      ),
                      const SizedBox(height: 16),

                      // Título
                      const Text(
                        "Cuéntanos más\nsobre ti",
                        style: TextStyle(
                          fontSize: AppDimens.fontSizeTitleLarge,
                          height: 1.2,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryDarker,
                        ),
                      ),
                      const SizedBox(height: 8),

                      Text(
                        "Esta información es opcional pero ayuda a encontrar mejores matches.",
                        style: TextStyle(
                          fontSize: AppDimens.fontSizeBody,
                          color: AppColors.primaryDarker.withValues(alpha: 0.7),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Género
                      _buildSectionTitle('Género', Icons.wc_outlined),
                      const SizedBox(height: 12),
                      _buildChipSelector(
                        options: _generos,
                        selectedValue: _selectedGenero,
                        onSelected: (value) =>
                            setState(() => _selectedGenero = value),
                      ),

                      const SizedBox(height: 24),

                      // Altura
                      _buildSectionTitle('Altura', Icons.height),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          SizedBox(
                            width: 120,
                            child: TextField(
                              controller: alturaCtrl,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
                              ],
                              decoration: InputDecoration(
                                hintText: '168',
                                suffixText: 'cm',
                                filled: true,
                                fillColor: AppColors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.radiusMedium,
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Signo zodiacal
                      _buildSectionTitle('Signo zodiacal', Icons.star_outline),
                      const SizedBox(height: 12),
                      _buildChipSelector(
                        options: _signos,
                        selectedValue: _selectedSigno,
                        onSelected: (value) =>
                            setState(() => _selectedSigno = value),
                        wrap: true,
                      ),

                      const SizedBox(height: 24),

                      // ¿Qué buscas?
                      _buildSectionTitle(
                        '¿Qué buscas?',
                        Icons.favorite_outline,
                      ),
                      const SizedBox(height: 12),
                      _buildChipSelector(
                        options: _opcionesBuscando,
                        selectedValue: _selectedBuscando,
                        onSelected: (value) =>
                            setState(() => _selectedBuscando = value),
                      ),

                      const SizedBox(height: 24),

                      // Bebe
                      _buildSectionTitle('¿Bebes?', Icons.wine_bar_outlined),
                      const SizedBox(height: 12),
                      _buildChipSelector(
                        options: _opcionesBebe,
                        selectedValue: _selectedBebe,
                        onSelected: (value) =>
                            setState(() => _selectedBebe = value),
                      ),

                      const SizedBox(height: 24),

                      // Fuma
                      _buildSectionTitle(
                        '¿Fumas?',
                        Icons.smoking_rooms_outlined,
                      ),
                      const SizedBox(height: 12),
                      _buildChipSelector(
                        options: _opcionesFuma,
                        selectedValue: _selectedFuma,
                        onSelected: (value) =>
                            setState(() => _selectedFuma = value),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),

              // Botón continuar
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
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
                        onPressed: _continueToNextStep,
                        child: const Text(
                          "Continuar",
                          style: TextStyle(
                            fontSize: AppDimens.fontSizeSubtitle,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _continueToNextStep,
                      child: Text(
                        "Omitir por ahora",
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryDarker.withValues(alpha: 0.6),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primaryDarker),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: AppDimens.fontSizeSubtitle,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDarker,
          ),
        ),
      ],
    );
  }

  Widget _buildChipSelector({
    required List<String> options,
    required String? selectedValue,
    required Function(String) onSelected,
    bool wrap = false,
  }) {
    final chips = options.map((option) {
      final isSelected = selectedValue == option;
      return GestureDetector(
        onTap: () => onSelected(option),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(25),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.accent,
              width: 1.5,
            ),
          ),
          child: Text(
            option,
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? AppColors.white : AppColors.primaryDarker,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      );
    }).toList();

    if (wrap) {
      return Wrap(spacing: 10, runSpacing: 10, children: chips);
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips
            .map(
              (chip) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: chip,
              ),
            )
            .toList(),
      ),
    );
  }
}
