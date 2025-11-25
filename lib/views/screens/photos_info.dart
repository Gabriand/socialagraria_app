import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:social_agraria/views/screens/affiliation_info.dart';

class PhotosInfo extends StatefulWidget {
  const PhotosInfo({super.key});

  @override
  State<PhotosInfo> createState() => _PhotosInfoState();
}

class _PhotosInfoState extends State<PhotosInfo> {
  final List<File?> _images = List.filled(5, null);
  final ImagePicker _picker = ImagePicker();

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

  int get _uploadedCount => _images.where((img) => img != null).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: AppColors.primaryDarker,
                      size: 28,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "¡Muestra tu mejor lado!",
                    style: TextStyle(
                      fontSize: AppDimens.fontSizeTitleLarge,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDarker,
                    ),
                  ),
                  SizedBox(height: AppDimens.radiusSmall),
                  Text(
                    "Sube al menos 2 fotos para continuar. ¡Más es mejor!",
                    style: TextStyle(
                      fontSize: AppDimens.fontSizeBody,
                      color: AppColors.primaryDarker.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: AspectRatio(
                            aspectRatio: 0.7,
                            child: _buildMainPhotoSlot(0),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 0.95,
                                child: _buildPhotoSlot(1),
                              ),
                              const SizedBox(height: 12),
                              AspectRatio(
                                aspectRatio: 0.95,
                                child: _buildPhotoSlot(2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1.5,
                            child: _buildPhotoSlot(3),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AspectRatio(
                            aspectRatio: 1.5,
                            child: _buildPhotoSlot(4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _uploadedCount >= 2
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const AffiliationInfo(),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _uploadedCount >= 2
                            ? AppColors.primaryDarker
                            : AppColors.accent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        disabledBackgroundColor: AppColors.accent,
                      ),
                      child: Text(
                        "Siguiente",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _uploadedCount >= 2
                              ? Colors.white
                              : AppColors.primaryDarker.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AffiliationInfo(),
                        ),
                      );
                    },
                    child: Text(
                      "Omitir por ahora",
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryDarker.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainPhotoSlot(int index) {
    return GestureDetector(
      onTap: () {
        print('Tapped main photo slot $index');
        _pickImage(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryDarker.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: _images[index] != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      _images[index]!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 48,
                    color: AppColors.primaryDarker.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Foto principal",
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.primaryDarker.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildPhotoSlot(int index) {
    return GestureDetector(
      onTap: () {
        print('Tapped photo slot $index');
        _pickImage(index);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.accent.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.primaryDarker.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: _images[index] != null
            ? Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.file(
                      _images[index]!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _removeImage(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
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
                ],
              )
            : Icon(
                Icons.add,
                size: 36,
                color: AppColors.primaryDarker.withValues(alpha: 0.4),
              ),
      ),
    );
  }
}
