import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

/// Servicio para comprimir imágenes antes de subirlas
class ImageCompressionService {
  /// Comprime una imagen manteniendo buena calidad
  /// [file] - Archivo de imagen original
  /// [quality] - Calidad de compresión (0-100), default 70
  /// [maxWidth] - Ancho máximo en pixels, default 1080
  /// [maxHeight] - Alto máximo en pixels, default 1920
  static Future<File> compressImage(
    File file, {
    int quality = 70,
    int maxWidth = 1080,
    int maxHeight = 1920,
  }) async {
    try {
      // Leer bytes de la imagen
      final bytes = await file.readAsBytes();

      // Decodificar imagen
      img.Image? image = img.decodeImage(bytes);

      if (image == null) {
        return file; // Si no se puede decodificar, retornar original
      }

      // Redimensionar si es necesario
      if (image.width > maxWidth || image.height > maxHeight) {
        // Calcular el ratio para mantener proporciones
        final double widthRatio = maxWidth / image.width;
        final double heightRatio = maxHeight / image.height;
        final double ratio = widthRatio < heightRatio
            ? widthRatio
            : heightRatio;

        final int newWidth = (image.width * ratio).round();
        final int newHeight = (image.height * ratio).round();

        image = img.copyResize(
          image,
          width: newWidth,
          height: newHeight,
          interpolation: img.Interpolation.linear,
        );
      }

      // Comprimir a JPEG
      final Uint8List compressedBytes = img.encodeJpg(image, quality: quality);

      // Guardar en archivo temporal
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/compressed_$timestamp.jpg');
      await tempFile.writeAsBytes(compressedBytes);

      debugPrint(
        'Imagen comprimida: ${bytes.length} -> ${compressedBytes.length} bytes',
      );

      return tempFile;
    } catch (e) {
      debugPrint('Error al comprimir imagen: $e');
      return file; // En caso de error, retornar original
    }
  }

  /// Comprime múltiples imágenes
  static Future<List<File>> compressMultipleImages(
    List<File> files, {
    int quality = 70,
    int maxWidth = 1080,
    int maxHeight = 1920,
  }) async {
    final List<File> compressedFiles = [];

    for (final file in files) {
      final compressed = await compressImage(
        file,
        quality: quality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      compressedFiles.add(compressed);
    }

    return compressedFiles;
  }

  /// Obtiene el tamaño del archivo en KB
  static Future<double> getFileSizeInKB(File file) async {
    final bytes = await file.length();
    return bytes / 1024;
  }

  /// Verifica si la imagen necesita compresión (> 500KB)
  static Future<bool> needsCompression(File file, {int maxSizeKB = 500}) async {
    final sizeKB = await getFileSizeInKB(file);
    return sizeKB > maxSizeKB;
  }
}
