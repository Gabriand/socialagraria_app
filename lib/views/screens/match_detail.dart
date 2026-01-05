import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/views/screens/photo_gallery.dart';
import 'package:social_agraria/models/model.dart';
import 'package:social_agraria/models/services/supabase.dart';
import 'package:cached_network_image/cached_network_image.dart';

/// Enum para identificar desde dónde se abre el perfil
enum ProfileContext {
  explorer, // Desde explorador - mostrar like/dislike
  likeReceived, // Desde likes recibidos - mostrar aceptar/rechazar
  match, // Ya es match - mostrar botón de mensaje
}

class MatchDetail extends StatefulWidget {
  final UserProfile profile;
  final ProfileContext context;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const MatchDetail({
    super.key,
    required this.profile,
    this.context = ProfileContext.explorer,
    this.onAccept,
    this.onReject,
  });

  @override
  State<MatchDetail> createState() => _MatchDetailState();
}

class _MatchDetailState extends State<MatchDetail>
    with TickerProviderStateMixin {
  int currentImageIndex = 0;

  List<String> get images =>
      widget.profile.photoUrls.isNotEmpty ? widget.profile.photoUrls : [''];

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late AnimationController _imageAnimationController;
  late Animation<double> _imageAnimation;
  bool isLikePressed = false;
  bool isDislikePressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _imageAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      value: 1.0,
    );
    _imageAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _imageAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _imageAnimationController.dispose();
    super.dispose();
  }

  void _changeImage(int newIndex) {
    if (newIndex != currentImageIndex &&
        newIndex >= 0 &&
        newIndex < images.length) {
      _imageAnimationController.reset();
      setState(() => currentImageIndex = newIndex);
      _imageAnimationController.forward();
    }
  }

  Widget _buildProfileImage() {
    final imageUrl = images.isNotEmpty && images[currentImageIndex].isNotEmpty
        ? images[currentImageIndex]
        : null;

    if (imageUrl != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.accent,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.accent,
          child: Icon(Icons.person, size: 100, color: AppColors.primaryDarker),
        ),
      );
    }

    return Container(
      color: AppColors.accent,
      child: Icon(Icons.person, size: 100, color: AppColors.primaryDarker),
    );
  }

  void _handleLikePress() async {
    setState(() => isLikePressed = true);
    _animationController.forward().then((_) async {
      _animationController.reverse();

      // Si es del explorador, registrar like
      if (widget.context == ProfileContext.explorer) {
        final user = SupabaseService.currentUser;
        if (user != null) {
          try {
            await DatabaseService().recordSwipe(
              userId: user.id,
              targetUserId: widget.profile.id,
              isLike: true,
            );
          } catch (e) {
            debugPrint('Error al registrar like: $e');
          }
        }
      }

      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => isLikePressed = false);
          Navigator.pop(context);
        }
      });
    });
  }

  void _handleDislikePress() async {
    setState(() => isDislikePressed = true);
    _animationController.forward().then((_) async {
      _animationController.reverse();

      // Si es del explorador, registrar dislike
      if (widget.context == ProfileContext.explorer) {
        final user = SupabaseService.currentUser;
        if (user != null) {
          try {
            await DatabaseService().recordSwipe(
              userId: user.id,
              targetUserId: widget.profile.id,
              isLike: false,
            );
          } catch (e) {
            debugPrint('Error al registrar dislike: $e');
          }
        }
      }

      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => isDislikePressed = false);
          Navigator.pop(context);
        }
      });
    });
  }

  void _handleAccept() {
    setState(() => isLikePressed = true);
    _animationController.forward().then((_) {
      _animationController.reverse();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => isLikePressed = false);
          widget.onAccept?.call();
          Navigator.pop(context);
        }
      });
    });
  }

  void _handleReject() {
    setState(() => isDislikePressed = true);
    _animationController.forward().then((_) {
      _animationController.reverse();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() => isDislikePressed = false);
          widget.onReject?.call();
          Navigator.pop(context);
        }
      });
    });
  }

  void _handleMessage() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Chat próximamente...')));
  }

  void _openPhotoGallery() {
    if (images.isEmpty || images[0].isEmpty) return;

    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, animation, secondaryAnimation) => PhotoGallery(
          imageUrls: images.where((url) => url.isNotEmpty).toList(),
          initialIndex: currentImageIndex,
          heroTag: 'profile_${widget.profile.id}',
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Contenido scrolleable
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen con carrusel
                Stack(
                  children: [
                    GestureDetector(
                      onTap: _openPhotoGallery, // Abrir galería con zoom
                      onDoubleTap: _openPhotoGallery, // También con doble tap
                      onTapDown: (details) {
                        final screenWidth = MediaQuery.of(context).size.width;
                        if (details.localPosition.dx < screenWidth / 2) {
                          if (currentImageIndex > 0) {
                            _changeImage(currentImageIndex - 1);
                          }
                        } else {
                          if (currentImageIndex < images.length - 1) {
                            _changeImage(currentImageIndex + 1);
                          }
                        }
                      },
                      onHorizontalDragEnd: (details) {
                        if (details.primaryVelocity != null &&
                            details.primaryVelocity! < -500) {
                          if (currentImageIndex < images.length - 1) {
                            _changeImage(currentImageIndex + 1);
                          }
                        } else if (details.primaryVelocity != null &&
                            details.primaryVelocity! > 500) {
                          if (currentImageIndex > 0) {
                            _changeImage(currentImageIndex - 1);
                          }
                        }
                      },
                      child: AnimatedBuilder(
                        animation: _imageAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: 0.95 + (_imageAnimation.value * 0.05),
                            child: Opacity(
                              opacity: 0.7 + (_imageAnimation.value * 0.3),
                              child: SizedBox(
                                width: double.infinity,
                                height: 550.0,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Hero(
                                      tag:
                                          'profile_${widget.profile.id}_$currentImageIndex',
                                      child: _buildProfileImage(),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.black.withValues(alpha: 0.1),
                                          ],
                                        ),
                                      ),
                                    ),
                                    // Icono de zoom
                                    Positioned(
                                      top: 50,
                                      right: 16,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(
                                            alpha: 0.4,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.zoom_in,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Indicadores de imagen minimalistas
                    Positioned(
                      bottom: 20.0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            images.length,
                            (index) => AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              width: currentImageIndex == index ? 8.0 : 6.0,
                              height: currentImageIndex == index ? 8.0 : 6.0,
                              margin: EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentImageIndex == index
                                    ? AppColors.white
                                    : AppColors.white.withValues(alpha: 0.5),
                                boxShadow: currentImageIndex == index
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          blurRadius: 4.0,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Botón de regresar
                    Positioned(
                      top: 40.0,
                      left: 8.0,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.white,
                          size: 28.0,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              offset: Offset(0, 2),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ],
                ),

                // Información del perfil
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre y edad
                      Row(
                        children: [
                          Text(
                            widget.profile.displayName,
                            style: TextStyle(
                              color: AppColors.primaryDarker,
                              fontSize: AppDimens.fontSizeTitleLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppDimens.espacioSmall),

                      // Universidad y facultad
                      if (widget.profile.universidad != null ||
                          widget.profile.facultad != null)
                        Row(
                          children: [
                            Icon(
                              Icons.apartment_outlined,
                              color: AppColors.primaryDarker,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
                            Expanded(
                              child: Text(
                                widget.profile.affiliationInfo,
                                style: TextStyle(
                                  color: AppColors.primaryDarker,
                                  fontSize: AppDimens.fontSizeBody,
                                ),
                              ),
                            ),
                          ],
                        ),

                      // Carrera y semestre
                      if (widget.profile.carrera != null ||
                          widget.profile.semestre != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.school_outlined,
                                color: AppColors.primaryDarker,
                                size: 20.0,
                              ),
                              SizedBox(width: 8.0),
                              Expanded(
                                child: Text(
                                  widget.profile.academicInfo,
                                  style: TextStyle(
                                    color: AppColors.primaryDarker,
                                    fontSize: AppDimens.fontSizeBody,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(height: AppDimens.espacioSmall),

                      // Distancia
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primaryDarker,
                            size: 20.0,
                          ),
                          SizedBox(width: 8.0),
                          Text(
                            'Cerca de ti',
                            style: TextStyle(
                              color: AppColors.primaryDarker,
                              fontSize: AppDimens.fontSizeBody,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppDimens.espacioLarge),

                      // Sobre mí
                      if (widget.profile.descripcion != null &&
                          widget.profile.descripcion!.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusMedium,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sobre mí',
                                style: TextStyle(
                                  color: AppColors.primaryDarker,
                                  fontSize: AppDimens.fontSizeSubtitle,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: AppDimens.espacioSmall),
                              Text(
                                widget.profile.descripcion!,
                                style: TextStyle(
                                  color: AppColors.primaryDarker,
                                  fontSize: AppDimens.fontSizeBody,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                      SizedBox(height: AppDimens.espacioLarge),

                      // Mis Intereses
                      if (widget.profile.intereses.isNotEmpty) ...[
                        Text(
                          'Mis Intereses',
                          style: TextStyle(
                            color: AppColors.primaryDarker,
                            fontSize: AppDimens.fontSizeSubtitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: AppDimens.espacioMedium),

                        Wrap(
                          spacing: 10.0,
                          runSpacing: 10.0,
                          children: widget.profile.intereses
                              .map((i) => _buildInterestChip(i))
                              .toList(),
                        ),

                        SizedBox(height: AppDimens.espacioLarge),
                      ],

                      // Más detalles - Solo mostrar si hay datos
                      if (_hasAnyDetail())
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: AppColors.accent,
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusMedium,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Más detalles',
                                style: TextStyle(
                                  color: AppColors.primaryDarker,
                                  fontSize: AppDimens.fontSizeSubtitle,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: AppDimens.espacioMedium),
                              if (widget.profile.alturaFormateada != null)
                                _buildDetailRow(
                                  Icons.height,
                                  widget.profile.alturaFormateada!,
                                  'Altura',
                                ),
                              if (widget.profile.alturaFormateada != null)
                                SizedBox(height: AppDimens.espacioMedium),
                              if (widget.profile.signoZodiacal != null)
                                _buildDetailRow(
                                  Icons.star_outline,
                                  widget.profile.signoZodiacal!,
                                  'Signo zodiacal',
                                ),
                              if (widget.profile.signoZodiacal != null)
                                SizedBox(height: AppDimens.espacioMedium),
                              if (widget.profile.bebe != null)
                                _buildDetailRow(
                                  Icons.wine_bar_outlined,
                                  widget.profile.bebe!,
                                  'Bebe',
                                ),
                              if (widget.profile.bebe != null)
                                SizedBox(height: AppDimens.espacioMedium),
                              if (widget.profile.fuma != null)
                                _buildDetailRow(
                                  Icons.smoking_rooms_outlined,
                                  widget.profile.fuma!,
                                  'Fuma',
                                ),
                              if (widget.profile.fuma != null)
                                SizedBox(height: AppDimens.espacioMedium),
                              if (widget.profile.buscando != null)
                                _buildDetailRow(
                                  Icons.favorite_outline,
                                  widget.profile.buscando!,
                                  'Buscando',
                                ),
                            ],
                          ),
                        ),

                      SizedBox(height: 120.0),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Botones flotantes en la parte inferior
          Positioned(
            bottom: 30.0,
            left: 0,
            right: 0,
            child: _buildBottomButtons(),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    switch (widget.context) {
      case ProfileContext.explorer:
        return _buildExplorerButtons();
      case ProfileContext.likeReceived:
        return _buildLikeReceivedButtons();
      case ProfileContext.match:
        return _buildMatchButtons();
    }
  }

  Widget _buildExplorerButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón de rechazar
        GestureDetector(
          onTapDown: (_) => _handleDislikePress(),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isDislikePressed ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        spreadRadius: 2.0,
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    size: 40.0,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 60.0),
        // Botón de me gusta
        GestureDetector(
          onTapDown: (_) => _handleLikePress(),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isLikePressed ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: isLikePressed
                        ? AppColors.primary.withValues(alpha: 0.9)
                        : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        spreadRadius: 2.0,
                        blurRadius: 15.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: 35.0,
                    color: AppColors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLikeReceivedButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Botón de rechazar
        GestureDetector(
          onTapDown: (_) => _handleReject(),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isDislikePressed ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        spreadRadius: 2.0,
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.close,
                    size: 40.0,
                    color: AppColors.primary,
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(width: 60.0),
        // Botón de aceptar (crear match)
        GestureDetector(
          onTapDown: (_) => _handleAccept(),
          child: AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: isLikePressed ? _scaleAnimation.value : 1.0,
                child: Container(
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: isLikePressed
                        ? AppColors.primary.withValues(alpha: 0.9)
                        : AppColors.primary,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        spreadRadius: 2.0,
                        blurRadius: 15.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.favorite,
                    size: 35.0,
                    color: AppColors.white,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMatchButtons() {
    return Center(
      child: GestureDetector(
        onTap: _handleMessage,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                spreadRadius: 2.0,
                blurRadius: 15.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.chat_bubble_outline, color: AppColors.white, size: 24),
              SizedBox(width: 12),
              Text(
                'Enviar mensaje',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _hasAnyDetail() {
    return widget.profile.altura != null ||
        widget.profile.signoZodiacal != null ||
        widget.profile.bebe != null ||
        widget.profile.fuma != null ||
        widget.profile.buscando != null;
  }

  Widget _buildInterestChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.primaryDarker,
          fontSize: AppDimens.fontSizeBody,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryDarker, size: 22.0),
        SizedBox(width: 12.0),
        Text(
          value,
          style: TextStyle(
            color: AppColors.primaryDarker,
            fontSize: AppDimens.fontSizeBody,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: 8.0),
        Text(
          label,
          style: TextStyle(
            color: AppColors.primaryDarker.withValues(alpha: 0.7),
            fontSize: AppDimens.fontSizeSmall,
          ),
        ),
      ],
    );
  }
}
