import 'dart:io';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/models/services/supabase.dart';
import 'package:social_agraria/models/registration_data.dart';

class AdditionalInfo extends StatefulWidget {
  final RegistrationData registrationData;
  final List<File?> selectedImages;

  const AdditionalInfo({
    super.key,
    required this.registrationData,
    required this.selectedImages,
  });

  @override
  State<AdditionalInfo> createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  final TextEditingController bioController = TextEditingController();
  final _authService = AuthService();
  final _dbService = DatabaseService();
  final _storageService = StorageService();
  bool _isLoading = false;

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

  List<String> seleccionados = [];

  final TextEditingController _newInterestController = TextEditingController();

  @override
  void dispose() {
    bioController.dispose();
    _newInterestController.dispose();
    super.dispose();
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
            hintText: 'Ej: Fotografía, Gaming, Anime...',
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
          ),
          textCapitalization: TextCapitalization.words,
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
              final newInterest = _newInterestController.text.trim();
              if (newInterest.isNotEmpty) {
                setState(() {
                  if (!intereses.contains(newInterest)) {
                    intereses.add(newInterest);
                  }
                  if (!seleccionados.contains(newInterest)) {
                    seleccionados.add(newInterest);
                  }
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Añadir', style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _createAccountAndFinish() async {
    setState(() => _isLoading = true);

    try {
      // 1. Crear la cuenta en Supabase Auth con manejo de rate limiting
      AuthResponse? authResponse;
      int retryCount = 0;
      const maxRetries = 3;

      while (authResponse == null && retryCount < maxRetries) {
        try {
          authResponse = await _authService.signUpWithEmail(
            email: widget.registrationData.email,
            password: widget.registrationData.password,
          );
        } catch (e) {
          final errorMessage = e.toString().toLowerCase();
          // Si es error 429 (rate limit), esperar y reintentar
          if (errorMessage.contains('429') || errorMessage.contains('rate')) {
            retryCount++;
            if (retryCount < maxRetries) {
              // Esperar antes de reintentar (2, 4, 6 segundos)
              await Future.delayed(Duration(seconds: retryCount * 2));
              continue;
            }
          }
          rethrow;
        }
      }

      final user = authResponse?.user;
      if (user == null) {
        throw Exception('Error al crear la cuenta');
      }

      // 2. Subir las fotos al Storage (si hay)
      List<String> photoUrls = [];
      final imagesToUpload = widget.selectedImages
          .where((img) => img != null)
          .toList();

      if (imagesToUpload.isNotEmpty) {
        try {
          photoUrls = await _storageService.uploadMultiplePhotos(
            files: widget.selectedImages,
            userId: user.id,
          );
        } catch (e) {
          // Si falla la subida de fotos, continuar sin ellas
          // y mostrar advertencia al usuario
          debugPrint('Error al subir fotos: $e');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'No se pudieron subir las fotos. Podrás agregarlas después en tu perfil.',
                ),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        }
      }

      // 3. Crear el perfil completo en la base de datos
      await _dbService.createUserProfile(
        userId: user.id,
        email: widget.registrationData.email,
        nombre: widget.registrationData.nombre,
        apellido: widget.registrationData.apellido,
        edad: widget.registrationData.edad ?? 0,
        telefono: widget.registrationData.telefono ?? '',
        universidad: widget.registrationData.universidad,
        facultad: widget.registrationData.facultad,
        descripcion: bioController.text.trim(),
        intereses: seleccionados,
        photoUrls: photoUrls.isNotEmpty ? photoUrls : null,
        altura: widget.registrationData.altura,
        signoZodiacal: widget.registrationData.signoZodiacal,
        bebe: widget.registrationData.bebe,
        fuma: widget.registrationData.fuma,
        buscando: widget.registrationData.buscando,
        genero: widget.registrationData.genero,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '¡Cuenta creada exitosamente! Revisa tu correo para verificar.',
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 4),
          ),
        );
        // Volver a la pantalla de login
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } catch (e) {
      String errorMessage = e.toString();

      // Mensajes de error más amigables
      if (errorMessage.contains('429')) {
        errorMessage =
            'Demasiados intentos. Por favor espera unos minutos e intenta de nuevo.';
      } else if (errorMessage.contains('403')) {
        errorMessage = 'Error de permisos. Contacta al soporte.';
      } else if (errorMessage.contains('already registered') ||
          errorMessage.contains('User already registered')) {
        errorMessage =
            'Este correo ya está registrado. Intenta iniciar sesión.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tu Biografía",
                      style: TextStyle(
                        fontSize: AppDimens.fontSizeSubtitle,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDarker,
                      ),
                    ),
                    ValueListenableBuilder<TextEditingValue>(
                      valueListenable: bioController,
                      builder: (context, value, child) {
                        final count = value.text.length;
                        final isOverLimit = count > 150;
                        return Text(
                          "$count/150",
                          style: TextStyle(
                            fontSize: 12,
                            color: isOverLimit
                                ? Colors.red
                                : AppColors.primaryDarker.withValues(
                                    alpha: 0.5,
                                  ),
                            fontWeight: isOverLimit
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        );
                      },
                    ),
                  ],
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
                    maxLength: 150,
                    decoration: const InputDecoration(
                      hintText: "Escribe algo sobre ti…",
                      border: InputBorder.none,
                      counterText: "", // Ocultar contador default
                    ),
                  ),
                ),

                SizedBox(height: AppDimens.espacioXLarge),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tus Intereses",
                      style: TextStyle(
                        fontSize: AppDimens.fontSizeSubtitle,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryDarker,
                      ),
                    ),
                    GestureDetector(
                      onTap: _showAddInterestDialog,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white, size: 18),
                            SizedBox(width: 4),
                            Text(
                              "Añadir",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
                    onPressed: _isLoading ? null : _createAccountAndFinish,
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.white,
                          )
                        : Text(
                            "Crear Cuenta",
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
