import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/app_text_styles.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final List<File?> _images = List.filled(6, null);
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _nameController = TextEditingController(
    text: 'Erika',
  );
  final TextEditingController _lastNameController = TextEditingController(
    text: '',
  );
  final TextEditingController _ageController = TextEditingController(
    text: '30',
  );
  final TextEditingController _universityController = TextEditingController(
    text: 'Universidad Agraria del Ecuador',
  );
  final TextEditingController _facultyController = TextEditingController(
    text: 'Facultad de Computación',
  );
  final TextEditingController _aboutController = TextEditingController(
    text:
        'Amante de los libros, el café con leche y los paseos por el Retiro. Busco a alguien con quien compartir risas y descubrir nuevas series en Netflix. 📚🎬',
  );

  final List<String> _interests = ['Música', 'Cine', 'Viajar', 'Arte'];
  final TextEditingController _newInterestController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _universityController.dispose();
    _facultyController.dispose();
    _aboutController.dispose();
    _newInterestController.dispose();
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
                  suffixIcon: Icon(
                    Icons.arrow_drop_down,
                    color: AppColors.primaryDarker,
                  ),
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

              Text(
                'Sobre mí',
                style: TextStyle(
                  color: AppColors.primaryDarker,
                  fontSize: AppDimens.fontSizeBody,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 8.0),
              TextField(
                controller: _aboutController,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.0),
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
                  }).toList(),
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
              SizedBox(height: AppDimens.spacing2XLarge),

              SizedBox(
                width: double.infinity,
                height: AppDimens.buttonHeightMedium,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cambios guardados exitosamente'),
                        backgroundColor: AppColors.primaryDarker,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDarker,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimens.radiusXLarge,
                      ),
                    ),
                  ),
                  child: Text(
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
    return GestureDetector(
      onTap: () => _pickImage(index),
      child: Container(
        width: 100.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(15.0),
          border: Border.all(
            color: AppColors.primaryDarker.withValues(alpha: 0.2),
            width: 1.5,
          ),
        ),
        child: _images[index] != null
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
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.close, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              )
            : Icon(
                Icons.camera_alt_outlined,
                color: AppColors.primaryDarker.withValues(alpha: 0.4),
                size: 36.0,
              ),
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
}
