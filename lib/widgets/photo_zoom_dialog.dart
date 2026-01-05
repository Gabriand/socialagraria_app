import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_agraria/core/app_colors.dart';

/// Dialog con zoom para ver una foto ampliada con animación bonita
class PhotoZoomDialog extends StatefulWidget {
  final String imageUrl;
  final String? heroTag;

  const PhotoZoomDialog({super.key, required this.imageUrl, this.heroTag});

  /// Muestra el dialog con animación
  static Future<void> show(
    BuildContext context, {
    required String imageUrl,
    String? heroTag,
  }) {
    return showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Cerrar',
      barrierColor: Colors.black87,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return PhotoZoomDialog(imageUrl: imageUrl, heroTag: heroTag);
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeInBack,
        );
        return ScaleTransition(
          scale: Tween<double>(begin: 0.5, end: 1.0).animate(curvedAnimation),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }

  @override
  State<PhotoZoomDialog> createState() => _PhotoZoomDialogState();
}

class _PhotoZoomDialogState extends State<PhotoZoomDialog> {
  final TransformationController _transformationController =
      TransformationController();
  double _currentScale = 1.0;

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap() {
    if (_currentScale != 1.0) {
      // Resetear zoom
      _transformationController.value = Matrix4.identity();
      _currentScale = 1.0;
    } else {
      // Zoom in 2x
      final matrix = Matrix4.identity();
      matrix.setEntry(0, 0, 2.0);
      matrix.setEntry(1, 1, 2.0);
      _transformationController.value = matrix;
      _currentScale = 2.0;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Foto con zoom
          GestureDetector(
            onTap: () => Navigator.pop(context),
            onDoubleTap: _handleDoubleTap,
            child: Center(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.5,
                maxScale: 4.0,
                onInteractionEnd: (details) {
                  _currentScale = _transformationController.value
                      .getMaxScaleOnAxis();
                },
                child: Hero(
                  tag: widget.heroTag ?? 'photo_zoom_${widget.imageUrl}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: widget.imageUrl,
                      fit: BoxFit.contain,
                      placeholder: (context, url) => Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.broken_image,
                          size: 60,
                          color: AppColors.primaryDarker,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Botón de cerrar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, color: Colors.white, size: 24),
              ),
            ),
          ),

          // Indicador de zoom
          Positioned(
            bottom: MediaQuery.of(context).padding.bottom + 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Doble toque para zoom • Pellizca para ajustar',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
