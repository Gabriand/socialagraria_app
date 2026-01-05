import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/app_text_styles.dart';
import 'package:social_agraria/models/services/supabase.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final List<File?> _images = List.filled(6, null);
  final List<String> _existingPhotoUrls = [];
  final ImagePicker _picker = ImagePicker();
  final _dbService = DatabaseService();
  final _storageService = StorageService();
  bool _isLoading = false;
  bool _isSaving = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _careerController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  List<String> _interests = [];
  final TextEditingController _newInterestController = TextEditingController();

  // Nuevos campos de detalles personales
  String? _selectedGenero;
  String? _selectedSignoZodiacal;
  String? _selectedBuscando;
  String? _selectedBebe;
  String? _selectedFuma;

  final List<String> _generosOptions = [
    'Hombre',
    'Mujer',
    'No binario',
    'Prefiero no decir',
  ];
  final List<String> _signosZodiacalesOptions = [
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
  final List<String> _buscandoOptions = [
    'Relación seria',
    'Algo casual',
    'Amistad',
    'No lo sé aún',
  ];
  final List<String> _bebeOptions = ['Nunca', 'Socialmente', 'Frecuentemente'];
  final List<String> _fumaOptions = ['Nunca', 'Socialmente', 'Frecuentemente'];

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    setState(() => _isLoading = true);

    try {
      final profile = await _dbService.getUserProfile(user.id);
      if (profile != null && mounted) {
        setState(() {
          _nameController.text = profile['nombre'] ?? '';
          _lastNameController.text = profile['apellido'] ?? '';
          _ageController.text = profile['edad']?.toString() ?? '';
          _universityController.text = profile['universidad'] ?? '';
          _facultyController.text = profile['facultad'] ?? '';
          _careerController.text = profile['carrera'] ?? '';
          _semesterController.text = profile['semestre'] ?? '';
          _aboutController.text = profile['descripcion'] ?? '';
          // Nuevos campos de detalles personales
          _alturaController.text = profile['altura']?.toString() ?? '';
          _selectedGenero = profile['genero'];
          _selectedSignoZodiacal = profile['signo_zodiacal'];
          _selectedBuscando = profile['buscando'];
          _selectedBebe = profile['bebe'];
          _selectedFuma = profile['fuma'];
          if (profile['intereses'] != null) {
            _interests = List<String>.from(profile['intereses']);
          }
          if (profile['photo_urls'] != null) {
            _existingPhotoUrls.addAll(List<String>.from(profile['photo_urls']));
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cargar perfil: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);

    try {
      // Subir nuevas fotos si las hay
      List<String> photoUrls = List.from(_existingPhotoUrls);

      for (int i = 0; i < _images.length; i++) {
        if (_images[i] != null) {
          final url = await _storageService.uploadProfilePhoto(
            file: _images[i]!,
            userId: user.id,
            index: photoUrls.length,
          );
          photoUrls.add(url);
        }
      }

      // Actualizar perfil
      await _dbService.updateUserProfile(
        userId: user.id,
        nombre: _nameController.text.trim(),
        apellido: _lastNameController.text.trim(),
        edad: int.tryParse(_ageController.text) ?? 0,
        universidad: _universityController.text.trim(),
        facultad: _facultyController.text.trim(),
        carrera: _careerController.text.trim(),
        semestre: _semesterController.text.trim(),
        descripcion: _aboutController.text.trim(),
        intereses: _interests,
        photoUrls: photoUrls.isNotEmpty ? photoUrls : null,
        altura: int.tryParse(_alturaController.text),
        genero: _selectedGenero,
        signoZodiacal: _selectedSignoZodiacal,
        buscando: _selectedBuscando,
        bebe: _selectedBebe,
        fuma: _selectedFuma,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cambios guardados exitosamente'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al guardar: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _universityController.dispose();
    _facultyController.dispose();
    _careerController.dispose();
    _semesterController.dispose();
    _aboutController.dispose();
    _newInterestController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(int index) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _images[index] = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al seleccionar imagen: $e')),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images[index] = null;
    });
  }

  void _removeInterest(int index) {
    setState(() {
      _interests.removeAt(index);
    });
  }

  void _showAddInterestDialog() {
    _newInterestController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          'Añadir nuevo interés',
          style: TextStyle(color: AppColors.primaryDarker),
        ),
        content: TextField(
          controller: _newInterestController,
          decoration: InputDecoration(
            hintText: 'Ej: Fotografía',
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: AppColors.primaryDarker),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_newInterestController.text.isNotEmpty) {
                setState(() {
                  _interests.add(_newInterestController.text);
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryDarker,
            ),
            child: Text('Añadir', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AppColors.primaryDarker),
            onPressed: () => Navigator.pop(context),
          ),
          centerTitle: true,
          title: Text('Editar Perfil', style: AppTextStyles.titleMedium),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryDarker),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('Editar Perfil', style: AppTextStyles.titleMedium),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Mis Fotos Section
              Text(
                'Mis Fotos',
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: AppDimens.fontSizeSubtitle,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15.0),

              // Grid de fotos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPhotoSlot(0, isMain: true),
                  _buildPhotoSlot(1),
                  _buildPhotoSlot(2),
                ],
              ),
              SizedBox(height: 12.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildPhotoSlot(3),
                  _buildPhotoSlot(4),
                  _buildPhotoSlot(5),
                ],
              ),
              SizedBox(height: 30.0),

              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre',
                          style: TextStyle(
                            color: AppColors.primaryDarker,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Apellido',
                          style: TextStyle(
                            color: AppColors.primaryDarker,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        TextField(
                          controller: _lastNameController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                              vertical: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),

              Text(
                'Edad',
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: AppDimens.fontSizeBody,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimens.espacioSmall),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              Text(
                'Universidad',
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _universityController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              Text(
                'Facultad',
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimens.espacioSmall),
              TextField(
                controller: _facultyController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  hintText: 'Ej: Ingeniería',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // Carrera
              Text(
                'Carrera',
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimens.espacioSmall),
              TextField(
                controller: _careerController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  hintText: 'Ej: Ingeniería de Sistemas',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
              ),
              SizedBox(height: 20.0),

              // Semestre
              Text(
                'Semestre',
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppDimens.espacioSmall),
              TextField(
                controller: _semesterController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  hintText: 'Ej: 5to semestre',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 14.0,
                  ),
                ),
              ),
              SizedBox(height: AppDimens.espacioLarge),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sobre mí',
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontSize: AppDimens.fontSizeBody,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _aboutController,
                    builder: (context, value, child) {
                      final count = value.text.length;
                      final isOverLimit = count > 150;
                      return Text(
                        "$count/150",
                        style: TextStyle(
                          fontSize: 12,
                          color: isOverLimit
                              ? Colors.red
                              : AppColors.primaryDarker.withValues(alpha: 0.5),
                          fontWeight: isOverLimit
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _aboutController,
                maxLines: 5,
                maxLength: 150,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.0),
                  counterText: "", // Ocultar contador default
                ),
              ),
              SizedBox(height: 20.0),

              Text(
                'Intereses',
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.0),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  ..._interests.asMap().entries.map((entry) {
                    return _buildInterestChip(entry.value, entry.key);
                  }),
                ],
              ),
              SizedBox(height: 10.0),

              InkWell(
                onTap: _showAddInterestDialog,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.primaryDarker.withValues(alpha: 0.3),
                      style: BorderStyle.solid,
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.add,
                        color: AppColors.primaryDarker.withValues(alpha: 0.6),
                        size: 18.0,
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        'Añadir nuevo interés',
                        style: TextStyle(
                          color: AppColors.primaryDarker.withValues(alpha: 0.6),
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.0),

              // Sección Detalles Personales
              Text(
                'Detalles personales',
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 15.0),

              // Altura
              TextField(
                controller: _alturaController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Altura (cm) - Ej: 170',
                  hintStyle: TextStyle(
                    color: AppColors.primaryDarker.withValues(alpha: 0.5),
                  ),
                  filled: true,
                  fillColor: AppColors.accent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.0),
                  prefixIcon: Icon(
                    Icons.height,
                    color: AppColors.primaryDarker.withValues(alpha: 0.6),
                  ),
                ),
              ),
              SizedBox(height: 15.0),

              // Género
              _buildDropdownField(
                label: 'Género',
                value: _selectedGenero,
                items: _generosOptions,
                icon: Icons.person_outline,
                onChanged: (value) => setState(() => _selectedGenero = value),
              ),
              SizedBox(height: 15.0),

              // Signo Zodiacal
              _buildDropdownField(
                label: 'Signo zodiacal',
                value: _selectedSignoZodiacal,
                items: _signosZodiacalesOptions,
                icon: Icons.star_outline,
                onChanged: (value) =>
                    setState(() => _selectedSignoZodiacal = value),
              ),
              SizedBox(height: 15.0),

              // Buscando
              _buildDropdownField(
                label: '¿Qué estás buscando?',
                value: _selectedBuscando,
                items: _buscandoOptions,
                icon: Icons.favorite_outline,
                onChanged: (value) => setState(() => _selectedBuscando = value),
              ),
              SizedBox(height: 15.0),

              // Bebe
              _buildDropdownField(
                label: '¿Bebes?',
                value: _selectedBebe,
                items: _bebeOptions,
                icon: Icons.wine_bar_outlined,
                onChanged: (value) => setState(() => _selectedBebe = value),
              ),
              SizedBox(height: 15.0),

              // Fuma
              _buildDropdownField(
                label: '¿Fumas?',
                value: _selectedFuma,
                items: _fumaOptions,
                icon: Icons.smoking_rooms_outlined,
                onChanged: (value) => setState(() => _selectedFuma = value),
              ),

              SizedBox(height: AppDimens.spacing2XLarge),

              SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeightMedium,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarker,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusXLarge,
                      ),
                    ),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: AppColors.white)
                      : Text(
                          'Guardar Cambios',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: AppDimens.fontSizeSubtitle,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSlot(int index, {bool isMain = false}) {
    // Primero verificamos si hay una foto existente en este índice
    final hasExistingPhoto = index < _existingPhotoUrls.length;
    final hasNewPhoto = _images[index] != null;

    return GestureDetector(
      onTap: () => _pickImage(index),
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: isMain && (hasExistingPhoto || hasNewPhoto)
                ? AppColors.primary
                : AppColors.primaryDarker.withValues(alpha: 0.2),
            width: isMain && (hasExistingPhoto || hasNewPhoto) ? 2.5 : 1.5,
          ),
        ),
        child: hasNewPhoto
            // Mostrar foto nueva seleccionada
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13.5),
                    child: Image.file(
                      _images[index]!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  // Badge "Nueva"
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Nueva',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Botón eliminar
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  // Badge principal
                  if (isMain)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Principal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            : hasExistingPhoto
            // Mostrar foto existente del servidor
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(13.5),
                    child: CachedNetworkImage(
                      imageUrl: _existingPhotoUrls[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      placeholder: (context, url) => Container(
                        color: AppColors.accent,
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.accent,
                        child: Icon(
                          Icons.broken_image,
                          color: AppColors.primaryDarker.withValues(alpha: 0.4),
                        ),
                      ),
                    ),
                  ),
                  // Botón eliminar foto existente
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeExistingPhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                  // Badge principal
                  if (isMain)
                    Positioned(
                      bottom: 4,
                      left: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'Principal',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              )
            // Slot vacío
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    color: AppColors.primaryDarker.withValues(alpha: 0.4),
                    size: 32.0,
                  ),
                  if (isMain)
                    Text(
                      'Principal',
                      style: TextStyle(
                        color: AppColors.primaryDarker.withValues(alpha: 0.4),
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
      ),
    );
  }

  void _removeExistingPhoto(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        title: Text(
          '¿Eliminar foto?',
          style: TextStyle(color: AppColors.primaryDarker),
        ),
        content: Text(
          'Esta foto se eliminará de tu perfil.',
          style: TextStyle(
            color: AppColors.primaryDarker.withValues(alpha: 0.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: AppColors.primaryDarker),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _existingPhotoUrls.removeAt(index);
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestChip(String label, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.primaryDarker,
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 6.0),
          GestureDetector(
            onTap: () => _removeInterest(index),
            child: Icon(
              Icons.close,
              color: AppColors.primaryDarker,
              size: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: AppColors.primaryDarker.withValues(alpha: 0.6),
          ),
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: AppColors.primaryDarker.withValues(alpha: 0.6),
          ),
        ),
        dropdownColor: AppColors.background,
        style: TextStyle(color: AppColors.primaryDarker, fontSize: 16.0),
        items: items.map((String item) {
          return DropdownMenuItem<String>(value: item, child: Text(item));
        }).toList(),
        onChanged: onChanged,
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.primaryDarker.withValues(alpha: 0.6),
        ),
      ),
    );
  }
}
