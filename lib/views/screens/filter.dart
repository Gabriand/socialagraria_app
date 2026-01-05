import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/app_text_styles.dart';

class Filter extends StatefulWidget {
  const Filter({super.key});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  double minAge = 18;
  double maxAge = 25;
  double distance = 10;

  // Género a mostrar
  String selectedGender = "Todos";
  final List<String> genderOptions = ["Todos", "Hombres", "Mujeres"];

  // Qué está buscando
  String selectedLookingFor = "Todos";
  final List<String> lookingForOptions = [
    "Todos",
    "Relación seria",
    "Algo casual",
    "Amistad",
    "No lo sé aún",
  ];

  // Intereses
  List<String> interests = [
    "Música",
    "Arte",
    "Lectura",
    "Deportes",
    "Viajes",
    "Cine",
    "Fotografía",
    "Cocina",
    "Gaming",
    "Fitness",
  ];
  List<String> selectedInterests = [];

  String selectedFaculty = "Todas las facultades";
  String selectedUniversity = "Todas las universidades";

  final List<String> universities = [
    "Todas las universidades",
    "Universidad Agraria del Ecuador",
    "Escuela Superior Politécnica del Litoral",
    "Universidad de Guayaquil",
    "Universidad Católica de Santiago de Guayaquil",
    "Universidad Estatal de Milagro",
  ];

  final Map<String, List<String>> facultiesByUniversity = {
    "Todas las universidades": ["Todas las facultades"],
    "Universidad Agraria del Ecuador": [
      "Todas las facultades",
      "Facultad de Ciencias Agrarias",
      "Facultad de Economía Agrícola",
      "Facultad de Medicina Veterinaria y Zootecnia",
      "Facultad de Ciencias de la Computación",
    ],
    "Escuela Superior Politécnica del Litoral": [
      "Todas las facultades",
      "FIEC - Ingeniería en Electricidad y Computación",
      "FIMCP - Ingeniería Mecánica y Ciencias de la Producción",
      "FCNM - Ciencias Naturales y Matemáticas",
      "FIMCBOR - Ingeniería Marítima y Ciencias del Mar",
      "FADCOM - Arte, Diseño y Comunicación Audiovisual",
      "FCV - Ciencias de la Vida",
      "FCSH - Ciencias Sociales y Humanísticas",
    ],
    "Universidad de Guayaquil": [
      "Todas las facultades",
      "Facultad de Ciencias Médicas",
      "Facultad de Jurisprudencia",
      "Facultad de Ciencias Administrativas",
      "Facultad de Ingeniería Industrial",
      "Facultad de Arquitectura y Urbanismo",
      "Facultad de Comunicación Social",
      "Facultad de Ciencias Matemáticas y Físicas",
    ],
    "Universidad Católica de Santiago de Guayaquil": [
      "Todas las facultades",
      "Facultad de Medicina",
      "Facultad de Ingeniería",
      "Facultad de Ciencias Económicas y Administrativas",
      "Facultad de Derecho",
      "Facultad de Arquitectura y Diseño",
      "Facultad de Artes y Humanidades",
    ],
    "Universidad Estatal de Milagro": [
      "Todas las facultades",
      "Facultad de Ciencias de la Salud",
      "Facultad de Ciencias Sociales, Educación Comercial y Derecho",
      "Facultad de Ciencias de la Ingeniería",
      "Facultad de Ciencias Administrativas y Comerciales",
    ],
  };

  List<String> get currentFaculties =>
      facultiesByUniversity[selectedUniversity] ?? ["Todas las facultades"];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFilters();
  }

  Future<void> _loadFilters() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      minAge = prefs.getDouble('filter_min_age') ?? 18;
      maxAge = prefs.getDouble('filter_max_age') ?? 25;
      distance = prefs.getDouble('filter_distance') ?? 10;
      selectedGender = prefs.getString('filter_gender') ?? "Todos";
      selectedLookingFor = prefs.getString('filter_looking_for') ?? "Todos";
      selectedUniversity =
          prefs.getString('filter_university') ?? "Todas las universidades";
      selectedFaculty =
          prefs.getString('filter_faculty') ?? "Todas las facultades";
      selectedInterests = prefs.getStringList('filter_interests') ?? [];
      _isLoading = false;
    });
  }

  Future<void> _saveFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('filter_min_age', minAge);
    await prefs.setDouble('filter_max_age', maxAge);
    await prefs.setDouble('filter_distance', distance);
    await prefs.setString('filter_gender', selectedGender);
    await prefs.setString('filter_looking_for', selectedLookingFor);
    await prefs.setString('filter_university', selectedUniversity);
    await prefs.setString('filter_faculty', selectedFaculty);
    await prefs.setStringList('filter_interests', selectedInterests);
  }

  Future<void> _resetFilters() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('filter_min_age');
    await prefs.remove('filter_max_age');
    await prefs.remove('filter_distance');
    await prefs.remove('filter_gender');
    await prefs.remove('filter_looking_for');
    await prefs.remove('filter_university');
    await prefs.remove('filter_faculty');
    await prefs.remove('filter_interests');

    setState(() {
      minAge = 18;
      maxAge = 25;
      distance = 10;
      selectedGender = "Todos";
      selectedLookingFor = "Todos";
      selectedUniversity = "Todas las universidades";
      selectedFaculty = "Todas las facultades";
      selectedInterests = [];
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Filtros restablecidos'),
          backgroundColor: AppColors.primaryDarker,
          duration: Duration(seconds: 2),
        ),
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
        centerTitle: true,
        title: Text('Filtros', style: AppTextStyles.titleMedium),
        actions: [
          TextButton(
            onPressed: _resetFilters,
            child: Text(
              'Resetear',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rango de edad
                  filterCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            title("Rango de edad"),
                            Text(
                              "${minAge.toInt()} - ${maxAge.toInt()} años",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        RangeSlider(
                          values: RangeValues(minAge, maxAge),
                          min: 18,
                          max: 35,
                          divisions: 17,
                          activeColor: AppColors.primary,
                          inactiveColor: AppColors.primaryDarker.withAlpha(50),
                          onChanged: (v) {
                            setState(() {
                              minAge = v.start;
                              maxAge = v.end;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Mostrar género
                  filterCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title("Mostrar"),
                        const SizedBox(height: 12),
                        Row(
                          children: genderOptions.map((g) {
                            bool isSelected = selectedGender == g;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => selectedGender = g),
                                child: Container(
                                  margin: EdgeInsets.only(
                                    right: g != genderOptions.last ? 8 : 0,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.background,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : AppColors.primaryDarker.withAlpha(
                                              100,
                                            ),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      g,
                                      style: TextStyle(
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.primaryDarker,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Buscando
                  filterCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title("Buscando"),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: lookingForOptions.map((option) {
                            bool isSelected = selectedLookingFor == option;
                            return GestureDetector(
                              onTap: () =>
                                  setState(() => selectedLookingFor = option),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.primaryDarker.withAlpha(
                                            100,
                                          ),
                                  ),
                                ),
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.primaryDarker,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Universidad
                  filterCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title("Universidad"),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusRound,
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedUniversity,
                              isExpanded: true,
                              icon: Icon(
                                Icons.expand_more,
                                color: AppColors.primaryDarker,
                              ),
                              style: TextStyle(
                                color: AppColors.primaryDarker,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              items: universities
                                  .map(
                                    (u) => DropdownMenuItem(
                                      value: u,
                                      child: Text(u),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) {
                                setState(() {
                                  selectedUniversity = v!;
                                  selectedFaculty = "Todas las facultades";
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Facultad
                  filterCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        title("Facultad"),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              items: currentFaculties
                                  .map(
                                    (f) => DropdownMenuItem(
                                      value: f,
                                      child: Text(f),
                                    ),
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

                  const SizedBox(height: 16),

                  // Intereses
                  filterCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            title("Intereses"),
                            if (selectedInterests.isNotEmpty)
                              Text(
                                "${selectedInterests.length} seleccionados",
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: interests.map((i) {
                            bool isSelected = selectedInterests.contains(i);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedInterests.remove(i);
                                  } else {
                                    selectedInterests.add(i);
                                  }
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.background,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.primaryDarker.withAlpha(
                                            100,
                                          ),
                                  ),
                                ),
                                child: Text(
                                  i,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.white
                                        : AppColors.primaryDarker,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Botón Aplicar
                  GestureDetector(
                    onTap: () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      await _saveFilters();
                      if (!mounted) return;
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text('Filtros aplicados'),
                          backgroundColor: AppColors.success,
                          duration: Duration(seconds: 2),
                        ),
                      );
                      navigator.pop(true);
                    },
                    child: Container(
                      height: 56,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withAlpha(80),
                            blurRadius: 15,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "Aplicar Filtros",
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
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
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget filterCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
