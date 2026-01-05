import 'dart:math';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:social_agraria/core/app_colors.dart';

/// Widget de animación de corazón para likes
class LikeAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const LikeAnimation({super.key, this.onComplete});

  @override
  State<LikeAnimation> createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_controller);

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: Icon(
              Icons.favorite,
              size: 120,
              color: AppColors.primary,
              shadows: [
                Shadow(
                  color: AppColors.primary.withValues(alpha: 0.5),
                  blurRadius: 20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Widget de animación de X para dislikes
class DislikeAnimation extends StatefulWidget {
  final VoidCallback? onComplete;

  const DislikeAnimation({super.key, this.onComplete});

  @override
  State<DislikeAnimation> createState() => _DislikeAnimationState();
}

class _DislikeAnimationState extends State<DislikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.1,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.1,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);

    _rotationAnimation = Tween<double>(
      begin: -0.1,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_controller);

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Icon(
                Icons.close,
                size: 100,
                color: Colors.grey.shade400,
                shadows: [
                  Shadow(
                    color: Colors.grey.withValues(alpha: 0.3),
                    blurRadius: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Overlay de animación de match con confeti
class MatchAnimation extends StatefulWidget {
  final String? userName;
  final String? userPhoto;
  final VoidCallback? onComplete;

  const MatchAnimation({
    super.key,
    this.userName,
    this.userPhoto,
    this.onComplete,
  });

  @override
  State<MatchAnimation> createState() => _MatchAnimationState();
}

class _MatchAnimationState extends State<MatchAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _heartBeatAnimation;

  // Controladores de confeti
  late ConfettiController _confettiControllerLeft;
  late ConfettiController _confettiControllerRight;
  late ConfettiController _confettiControllerCenter;

  bool _canDismiss = false;

  @override
  void initState() {
    super.initState();

    // Inicializar controladores de confeti
    _confettiControllerLeft = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiControllerRight = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _confettiControllerCenter = ConfettiController(
      duration: const Duration(seconds: 2),
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.3,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
    ]).animate(_controller);

    _opacityAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 15),
    ]).animate(_controller);

    _heartBeatAnimation =
        TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 1.15, end: 1.0), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.1), weight: 25),
          TweenSequenceItem(tween: Tween(begin: 1.1, end: 1.0), weight: 25),
        ]).animate(
          CurvedAnimation(parent: _controller, curve: const Interval(0.3, 0.8)),
        );

    // Iniciar animaciones
    _controller.forward();

    // Permitir cerrar después de 1 segundo
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() => _canDismiss = true);
      }
    });

    // Iniciar confeti con un pequeño delay para mejor efecto
    Future.delayed(const Duration(milliseconds: 200), () {
      _confettiControllerLeft.play();
      _confettiControllerRight.play();
    });
    Future.delayed(const Duration(milliseconds: 400), () {
      _confettiControllerCenter.play();
    });
  }

  void _handleDismiss() {
    if (_canDismiss) {
      widget.onComplete?.call();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _confettiControllerLeft.dispose();
    _confettiControllerRight.dispose();
    _confettiControllerCenter.dispose();
    super.dispose();
  }

  /// Genera formas de confeti personalizadas (corazones y círculos)
  Path drawHeart(Size size) {
    final path = Path();
    final width = size.width;
    final height = size.height;

    path.moveTo(width / 2, height / 4);
    path.cubicTo(width / 8, 0, 0, height / 2, width / 2, height);
    path.moveTo(width / 2, height / 4);
    path.cubicTo(width * 7 / 8, 0, width, height / 2, width / 2, height);

    return path;
  }

  Path drawStar(Size size) {
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    for (int i = 0; i < 5; i++) {
      final angle = (i * 144 - 90) * pi / 180;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleDismiss,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // Fondo oscuro
              Container(
                color: Colors.black.withValues(
                  alpha: 0.75 * _opacityAnimation.value,
                ),
              ),

              // Confeti izquierdo
              Align(
                alignment: Alignment.topLeft,
                child: ConfettiWidget(
                  confettiController: _confettiControllerLeft,
                  blastDirection: -pi / 4, // Hacia abajo-derecha
                  emissionFrequency: 0.03,
                  numberOfParticles: 15,
                  maxBlastForce: 25,
                  minBlastForce: 10,
                  gravity: 0.2,
                  particleDrag: 0.05,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDarker,
                    Colors.pink.shade300,
                    Colors.red.shade300,
                    Colors.white,
                    Colors.yellow.shade300,
                  ],
                  createParticlePath: (size) {
                    final random = Random();
                    if (random.nextBool()) {
                      return drawHeart(size);
                    }
                    return drawStar(size);
                  },
                ),
              ),

              // Confeti derecho
              Align(
                alignment: Alignment.topRight,
                child: ConfettiWidget(
                  confettiController: _confettiControllerRight,
                  blastDirection: -3 * pi / 4, // Hacia abajo-izquierda
                  emissionFrequency: 0.03,
                  numberOfParticles: 15,
                  maxBlastForce: 25,
                  minBlastForce: 10,
                  gravity: 0.2,
                  particleDrag: 0.05,
                  colors: [
                    AppColors.primary,
                    AppColors.primaryDarker,
                    Colors.pink.shade300,
                    Colors.red.shade300,
                    Colors.white,
                    Colors.yellow.shade300,
                  ],
                  createParticlePath: (size) {
                    final random = Random();
                    if (random.nextBool()) {
                      return drawHeart(size);
                    }
                    return drawStar(size);
                  },
                ),
              ),

              // Confeti central (explosión)
              Align(
                alignment: Alignment.center,
                child: ConfettiWidget(
                  confettiController: _confettiControllerCenter,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.0,
                  numberOfParticles: 30,
                  maxBlastForce: 20,
                  minBlastForce: 5,
                  gravity: 0.3,
                  particleDrag: 0.05,
                  colors: [
                    AppColors.primary,
                    Colors.pink,
                    Colors.red,
                    Colors.white,
                    Colors.orange,
                  ],
                ),
              ),

              // Contenido principal
              Center(
                child: Opacity(
                  opacity: _opacityAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Corazones animados con latido
                        Transform.scale(
                          scale: _heartBeatAnimation.value,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Resplandor exterior
                              Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.4,
                                      ),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              // Corazón grande (sombra)
                              Icon(
                                Icons.favorite,
                                size: 110,
                                color: AppColors.primary.withValues(alpha: 0.3),
                              ),
                              // Corazón principal
                              ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    AppColors.primary,
                                    Colors.pink.shade400,
                                  ],
                                ).createShader(bounds),
                                child: const Icon(
                                  Icons.favorite,
                                  size: 90,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Texto "¡Es un Match!"
                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [Colors.white, Colors.pink.shade100],
                          ).createShader(bounds),
                          child: Text(
                            "¡Es un Match!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                              shadows: [
                                Shadow(
                                  color: AppColors.primary,
                                  blurRadius: 25,
                                ),
                                Shadow(
                                  color: Colors.pink.withValues(alpha: 0.5),
                                  blurRadius: 40,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (widget.userName != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Tú y ${widget.userName} se han gustado",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 24),
                        // Emoji de celebración
                        Text("✨💖✨", style: TextStyle(fontSize: 32)),
                        if (_canDismiss) ...[
                          const SizedBox(height: 20),
                          Text(
                            "Toca para continuar",
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
