import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';

/// Widget de estado vacío reutilizable
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? buttonText;
  final VoidCallback? onButtonPressed;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono con fondo circular
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 60, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            // Título
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryDarker,
                fontSize: AppDimens.fontSizeTitleMedium,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            // Subtítulo
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryDarker.withValues(alpha: 0.7),
                fontSize: AppDimens.fontSizeBody,
                height: 1.4,
              ),
            ),
            // Botón opcional
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusMedium),
                  ),
                ),
                child: Text(
                  buttonText!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Empty state para cuando no hay perfiles
class NoProfilesEmptyState extends StatelessWidget {
  final VoidCallback? onRefresh;

  const NoProfilesEmptyState({super.key, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.explore_outlined,
      title: '¡Has visto todos los perfiles!',
      subtitle:
          'Por ahora no hay más personas cerca.\nVuelve más tarde para descubrir nuevas conexiones.',
      buttonText: 'Actualizar',
      onButtonPressed: onRefresh,
    );
  }
}

/// Empty state para cuando no hay matches
class NoMatchesEmptyState extends StatelessWidget {
  const NoMatchesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.favorite_outline,
      title: 'Aún no tienes matches',
      subtitle:
          'Cuando alguien te guste y tú también le gustes,\naparecerán aquí. ¡Sigue explorando!',
    );
  }
}

/// Empty state para notificaciones vacías
class NoNotificationsEmptyState extends StatelessWidget {
  const NoNotificationsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.notifications_none_outlined,
      title: 'Sin notificaciones',
      subtitle:
          'Aquí aparecerán tus notificaciones\ncuando tengas actividad nueva.',
    );
  }
}

/// Empty state para cuando no hay likes
class NoLikesEmptyState extends StatelessWidget {
  const NoLikesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.thumb_up_outlined,
      title: 'Aún no has dado likes',
      subtitle:
          'Los perfiles que te gusten aparecerán aquí.\n¡Explora y encuentra personas interesantes!',
    );
  }
}

/// Empty state para cuando no has recibido likes
class NoLikesReceivedEmptyState extends StatelessWidget {
  const NoLikesReceivedEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return const EmptyState(
      icon: Icons.favorite_border,
      title: 'Aún no has recibido likes',
      subtitle:
          'Cuando alguien te dé like, aparecerá aquí\npara que decidas si conectar. ¡Sigue explorando!',
    );
  }
}
