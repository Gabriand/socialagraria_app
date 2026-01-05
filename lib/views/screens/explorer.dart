import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/core/utils/haptic_service.dart';
import 'package:social_agraria/views/screens/filter.dart';
import 'package:social_agraria/views/screens/notifications.dart';
import 'package:social_agraria/views/screens/profile_detail.dart';
import 'package:social_agraria/models/services/supabase.dart';
import 'package:social_agraria/models/model.dart';
import 'package:social_agraria/widgets/skeleton_loader.dart';
import 'package:social_agraria/widgets/empty_states.dart';
import 'package:social_agraria/widgets/like_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Explorer extends StatefulWidget {
  const Explorer({super.key});

  @override
  State<Explorer> createState() => _ExplorerState();
}

class _ExplorerState extends State<Explorer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool isLikePressed = false;
  bool isDislikePressed = false;
  bool _showLikeAnimation = false;
  bool _showDislikeAnimation = false;

  int _currentPhotoIndex = 0;

  final _dbService = DatabaseService();
  List<UserProfile> _profiles = [];
  int _currentIndex = 0;
  bool _isLoading = true;

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
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    try {
      final data = await _dbService.getProfilesToExplore(
        currentUserId: user.id,
        limit: 20,
      );

      if (mounted) {
        setState(() {
          _profiles = data.map((json) => UserProfile.fromJson(json)).toList();
          _isLoading = false;
          _currentIndex = 0;
          _currentPhotoIndex = 0;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _onRefresh() async {
    await _loadProfiles();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLikePress() async {
    if (_currentProfile == null) return;

    HapticService.likeVibration();
    final profile = _currentProfile!;

    setState(() {
      isLikePressed = true;
      _showLikeAnimation = true;
    });

    final user = SupabaseService.currentUser;
    if (user != null) {
      try {
        // Registrar el like - el match se crea automáticamente si es mutuo
        await _dbService.recordSwipe(
          userId: user.id,
          targetUserId: profile.id,
          isLike: true,
        );
        // No mostramos confeti aquí - se mostrará cuando el otro usuario
        // acepte desde "Mis Matches"
      } catch (e) {
        debugPrint('Error al registrar like: $e');
      }
    }

    _animationController.forward().then((_) {
      _animationController.reverse();
      Future.delayed(const Duration(milliseconds: 400), () {
        if (mounted) {
          setState(() {
            isLikePressed = false;
            _showLikeAnimation = false;
            _currentPhotoIndex = 0;
            if (_currentIndex < _profiles.length - 1) {
              _currentIndex++;
            } else {
              _profiles.clear();
            }
          });
        }
      });
    });
  }

  void _handleDislikePress() async {
    if (_currentProfile == null) return;

    HapticService.dislikeVibration();
    final profile = _currentProfile!;

    setState(() {
      isDislikePressed = true;
      _showDislikeAnimation = true;
    });

    final user = SupabaseService.currentUser;
    if (user != null) {
      try {
        await _dbService.recordSwipe(
          userId: user.id,
          targetUserId: profile.id,
          isLike: false,
        );
      } catch (e) {
        debugPrint('Error al registrar dislike: $e');
      }
    }

    _animationController.forward().then((_) {
      _animationController.reverse();
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) {
          setState(() {
            isDislikePressed = false;
            _showDislikeAnimation = false;
            _currentPhotoIndex = 0;
            if (_currentIndex < _profiles.length - 1) {
              _currentIndex++;
            } else {
              _profiles.clear();
            }
          });
        }
      });
    });
  }

  void _handleDoubleTap() {
    _handleLikePress();
  }

  void _nextPhoto() {
    final photos = _currentProfile?.photoUrls ?? [];
    if (_currentPhotoIndex < photos.length - 1) {
      setState(() => _currentPhotoIndex++);
    }
  }

  void _previousPhoto() {
    if (_currentPhotoIndex > 0) {
      setState(() => _currentPhotoIndex--);
    }
  }

  UserProfile? get _currentProfile =>
      _profiles.isNotEmpty && _currentIndex < _profiles.length
      ? _profiles[_currentIndex]
      : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Icon(
            Icons.tune_outlined,
            color: AppColors.primaryDarker,
            size: 30.0,
          ),
          onPressed: () {
            Navigator.of(
              context,
            ).push(PageTransitions.slideFromBottom(const Filter()));
          },
        ),
        title: Text(
          'Social Agraria',
          style: TextStyle(
            color: AppColors.primaryDarker,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: AppColors.primaryDarker,
              size: 30.0,
            ),
            onPressed: () {
              Navigator.of(
                context,
              ).push(PageTransitions.slideFromRight(const Notifications()));
            },
          ),
        ],
      ),
      body: _isLoading
          ? _buildSkeletonLoader()
          : RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.primary,
              child: _profiles.isEmpty || _currentProfile == null
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: NoProfilesEmptyState(onRefresh: _loadProfiles),
                      ),
                    )
                  : _buildProfileCard(),
            ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const ProfileCardSkeleton(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SkeletonLoader(width: 70, height: 70, borderRadius: 35),
              const SizedBox(width: 50),
              SkeletonLoader(width: 70, height: 70, borderRadius: 35),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final profile = _currentProfile!;
    final photos = profile.photoUrls;
    final currentPhoto = photos.isNotEmpty && _currentPhotoIndex < photos.length
        ? photos[_currentPhotoIndex]
        : profile.mainPhoto;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular altura de la tarjeta: altura total - botones (65) - spacing (16)
        final cardHeight = (constraints.maxHeight - 81).clamp(400.0, 600.0);

        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: GestureDetector(
                      onDoubleTap: _handleDoubleTap,
                      onTap: () async {
                        final result = await Navigator.of(context).push<String>(
                          PageTransitions.scale(
                            ProfileDetail(
                              profile: profile,
                              onLike: () {},
                              onDislike: () {},
                            ),
                          ),
                        );
                        if (result == 'like') {
                          _handleLikePress();
                        } else if (result == 'dislike') {
                          _handleDislikePress();
                        }
                      },
                      child: Container(
                        width: 340.0,
                        constraints: BoxConstraints(maxHeight: cardHeight),
                        decoration: BoxDecoration(
                          color: AppColors.primaryDarkest,
                          borderRadius: BorderRadius.circular(35.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              spreadRadius: 1.0,
                              blurRadius: 13.0,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35.0),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              currentPhoto != null
                                  ? CachedNetworkImage(
                                      imageUrl: currentPhoto,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Container(
                                        color: AppColors.accent,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            color: AppColors.accent,
                                            child: Icon(
                                              Icons.person,
                                              size: 100,
                                              color: AppColors.primaryDarker,
                                            ),
                                          ),
                                    )
                                  : Container(
                                      color: AppColors.accent,
                                      child: Icon(
                                        Icons.person,
                                        size: 100,
                                        color: AppColors.primaryDarker,
                                      ),
                                    ),

                              // Indicadores de fotos
                              if (photos.length > 1)
                                Positioned(
                                  top: 12,
                                  left: 16,
                                  right: 16,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      photos.length,
                                      (index) => Expanded(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                            horizontal: 2,
                                          ),
                                          height: 3,
                                          decoration: BoxDecoration(
                                            color: _currentPhotoIndex == index
                                                ? AppColors.white
                                                : AppColors.white.withValues(
                                                    alpha: 0.4,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              2,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              // Zonas táctiles para cambiar foto
                              if (photos.length > 1)
                                Positioned(
                                  left: 0,
                                  top: 0,
                                  bottom: 100,
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: _previousPhoto,
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),
                              if (photos.length > 1)
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  bottom: 100,
                                  width: 80,
                                  child: GestureDetector(
                                    onTap: _nextPhoto,
                                    behavior: HitTestBehavior.translucent,
                                    child: Container(color: Colors.transparent),
                                  ),
                                ),

                              // Gradiente
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.7),
                                    ],
                                  ),
                                ),
                              ),

                              // Info del perfil
                              Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      profile.displayName,
                                      style: TextStyle(
                                        color: AppColors.white,
                                        fontSize: AppDimens.fontSizeTitleMedium,
                                        fontWeight: FontWeight.bold,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black54,
                                            offset: const Offset(0, 2),
                                            blurRadius: 4.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    if (profile.academicInfo.isNotEmpty)
                                      Text(
                                        profile.academicInfo,
                                        style: TextStyle(
                                          color: AppColors.white,
                                          fontSize:
                                              AppDimens.fontSizeSubtitle - 1,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black54,
                                              offset: const Offset(0, 2),
                                              blurRadius: 4.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    if (profile.intereses.isNotEmpty)
                                      Wrap(
                                        spacing: 6.0,
                                        runSpacing: 6.0,
                                        children: profile.intereses.take(3).map(
                                          (interes) {
                                            return Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 5,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withValues(
                                                  alpha: 0.2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                interes,
                                                style: const TextStyle(
                                                  color: AppColors.white,
                                                  fontSize: 11,
                                                ),
                                              ),
                                            );
                                          },
                                        ).toList(),
                                      ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTapDown: (_) => _handleDislikePress(),
                      child: AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: isDislikePressed
                                ? _scaleAnimation.value
                                : 1.0,
                            child: Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    spreadRadius: 2.0,
                                    blurRadius: 10.0,
                                    offset: const Offset(0, 4),
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
                    const SizedBox(width: 40.0),
                    GestureDetector(
                      onTapDown: (_) => _handleLikePress(),
                      child: AnimatedBuilder(
                        animation: _scaleAnimation,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: isLikePressed ? _scaleAnimation.value : 1.0,
                            child: Container(
                              width: 65.0,
                              height: 65.0,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.4,
                                    ),
                                    spreadRadius: 2.0,
                                    blurRadius: 15.0,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
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
                ),
                const SizedBox(height: 16),
              ],
            ),
            if (_showLikeAnimation)
              const Positioned.fill(child: Center(child: LikeAnimation())),
            if (_showDislikeAnimation)
              const Positioned.fill(child: Center(child: DislikeAnimation())),
          ],
        );
      },
    );
  }
}
