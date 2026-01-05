import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';

/// Widget de Skeleton loader para estados de carga
class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    this.width = double.infinity,
    this.height = 20,
    this.borderRadius = 8,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _animation.value, 0),
              end: Alignment(_animation.value, 0),
              colors: [
                AppColors.accent.withValues(alpha: 0.3),
                AppColors.accent.withValues(alpha: 0.5),
                AppColors.accent.withValues(alpha: 0.3),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Skeleton para una tarjeta de perfil en el explorador
class ProfileCardSkeleton extends StatelessWidget {
  const ProfileCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 530,
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Stack(
        children: [
          // Fondo skeleton
          const Positioned.fill(child: SkeletonLoader(borderRadius: 40)),
          // Contenido inferior
          Positioned(
            bottom: 23,
            left: 23,
            right: 23,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 180, height: 28, borderRadius: 8),
                const SizedBox(height: 8),
                SkeletonLoader(width: 120, height: 18, borderRadius: 6),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SkeletonLoader(width: 60, height: 28, borderRadius: 20),
                    const SizedBox(width: 8),
                    SkeletonLoader(width: 70, height: 28, borderRadius: 20),
                    const SizedBox(width: 8),
                    SkeletonLoader(width: 50, height: 28, borderRadius: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton para tarjeta de match en grid
class MatchCardSkeleton extends StatelessWidget {
  const MatchCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.accent.withValues(alpha: 0.3),
      ),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: SkeletonLoader(borderRadius: 0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SkeletonLoader(width: 100, height: 16, borderRadius: 4),
                const SizedBox(height: 6),
                SkeletonLoader(width: 70, height: 12, borderRadius: 4),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
