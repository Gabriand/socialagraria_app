import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_text_styles.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/match_detail.dart';
import 'package:social_agraria/models/services/supabase.dart';
import 'package:social_agraria/models/model.dart';
import 'package:social_agraria/widgets/skeleton_loader.dart';
import 'package:social_agraria/widgets/empty_states.dart';
import 'package:social_agraria/widgets/like_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserMatch extends StatefulWidget {
  const UserMatch({super.key});

  @override
  State<UserMatch> createState() => _UserMatchState();
}

class _UserMatchState extends State<UserMatch> with TickerProviderStateMixin {
  final _dbService = DatabaseService();
  List<UserProfile> _matches = [];
  List<UserProfile> _likesReceived = [];
  bool _isLoading = true;
  late TabController _tabController;

  // Para mostrar la animación de match
  bool _showMatchAnimation = false;
  String? _matchedUserName;
  String? _matchedUserPhoto;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    try {
      // Cargar matches y likes recibidos en paralelo
      final results = await Future.wait([
        _dbService.getUserMatches(user.id),
        _dbService.getLikesReceived(user.id),
      ]);

      if (mounted) {
        setState(() {
          _matches = results[0]
              .map((json) => UserProfile.fromJson(json))
              .toList();
          _likesReceived = results[1]
              .map((json) => UserProfile.fromJson(json))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _refresh() async {
    setState(() => _isLoading = true);
    await _loadData();
  }

  Future<void> _acceptLike(UserProfile profile) async {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    try {
      await _dbService.acceptLike(
        currentUserId: user.id,
        likerUserId: profile.id,
      );

      // Mostrar animación de match con confeti
      setState(() {
        _showMatchAnimation = true;
        _matchedUserName = profile.nombre;
        _matchedUserPhoto = profile.mainPhoto;
      });

      // Recargar datos después de aceptar
      await _loadData();
    } catch (e) {
      debugPrint('Error accepting like: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al aceptar. Intenta de nuevo.')),
        );
      }
    }
  }

  Future<void> _rejectLike(UserProfile profile) async {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    try {
      await _dbService.rejectLike(
        currentUserId: user.id,
        likerUserId: profile.id,
      );

      // Remover de la lista inmediatamente
      setState(() {
        _likesReceived.removeWhere((p) => p.id == profile.id);
      });

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Perfil descartado')));
      }
    } catch (e) {
      debugPrint('Error rejecting like: $e');
    }
  }

  void _dismissMatchAnimation() {
    setState(() {
      _showMatchAnimation = false;
      _matchedUserName = null;
      _matchedUserPhoto = null;
    });
    // Cambiar al tab de Matches para ver el nuevo match
    _tabController.animateTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Conexiones', style: AppTextStyles.titleMedium),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite_border, size: 18),
                  const SizedBox(width: 6),
                  const Text('Likes'),
                  if (_likesReceived.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_likesReceived.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Tab(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, size: 18),
                  const SizedBox(width: 6),
                  const Text('Matches'),
                  if (_matches.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${_matches.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: RefreshIndicator(
              onRefresh: _refresh,
              color: AppColors.primary,
              child: _isLoading
                  ? _buildSkeletonGrid()
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        // Tab 1: Likes recibidos
                        _likesReceived.isEmpty
                            ? const NoLikesReceivedEmptyState()
                            : _buildLikesGrid(_likesReceived),
                        // Tab 2: Matches
                        _matches.isEmpty
                            ? const NoMatchesEmptyState()
                            : _buildMatchGrid(_matches),
                      ],
                    ),
            ),
          ),

          // Animación de Match con confeti
          if (_showMatchAnimation)
            MatchAnimation(
              userName: _matchedUserName ?? '',
              userPhoto: _matchedUserPhoto,
              onComplete: _dismissMatchAnimation,
            ),
        ],
      ),
    );
  }

  Widget _buildSkeletonGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 6,
        itemBuilder: (context, index) => const MatchCardSkeleton(),
      ),
    );
  }

  Widget _buildLikesGrid(List<UserProfile> profiles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return LikeReceivedCard(
            name: profile.nombre,
            info: profile.academicInfo.isNotEmpty
                ? profile.academicInfo
                : (profile.affiliationInfo.isNotEmpty
                      ? profile.affiliationInfo
                      : ''),
            imageUrl: profile.mainPhoto,
            onTap: () {
              Navigator.of(context).push(
                PageTransitions.scale(
                  MatchDetail(
                    profile: profile,
                    context: ProfileContext.likeReceived,
                    onAccept: () => _acceptLike(profile),
                    onReject: () => _rejectLike(profile),
                  ),
                ),
              );
            },
            onAccept: () => _acceptLike(profile),
            onReject: () => _rejectLike(profile),
          );
        },
      ),
    );
  }

  Widget _buildMatchGrid(List<UserProfile> profiles) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: profiles.length,
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return MatchCard(
            name: profile.nombre,
            info: profile.academicInfo.isNotEmpty
                ? profile.academicInfo
                : (profile.affiliationInfo.isNotEmpty
                      ? profile.affiliationInfo
                      : ''),
            imageUrl: profile.mainPhoto,
            isMatch: true,
            onTap: () {
              Navigator.of(context).push(
                PageTransitions.scale(
                  MatchDetail(profile: profile, context: ProfileContext.match),
                ),
              );
            },
            onMessage: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Chat próximamente...')),
              );
            },
          );
        },
      ),
    );
  }
}

/// Card para likes recibidos con botones de aceptar/rechazar
class LikeReceivedCard extends StatelessWidget {
  final String name;
  final String info;
  final String? imageUrl;
  final VoidCallback onTap;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const LikeReceivedCard({
    super.key,
    required this.name,
    required this.info,
    this.imageUrl,
    required this.onTap,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagen de fondo
              imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.accent,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.accent,
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.accent,
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),

              // Badge de Like recibido
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, color: Colors.white, size: 12),
                      SizedBox(width: 4),
                      Text(
                        'Te dio like',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Gradiente inferior
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 120,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.9),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // Información del usuario
              Positioned(
                left: 12,
                right: 12,
                bottom: 55,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      info,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.95),
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Botones de aceptar/rechazar (redondos)
              Positioned(
                left: 0,
                right: 0,
                bottom: 12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón Rechazar (redondo)
                    GestureDetector(
                      onTap: onReject,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.primary,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Botón Aceptar (redondo)
                    GestureDetector(
                      onTap: onAccept,
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.favorite,
                          color: AppColors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MatchCard extends StatefulWidget {
  final String name;
  final String info;
  final String? imageUrl;
  final VoidCallback onTap;
  final VoidCallback? onMessage;
  final bool isMatch;

  const MatchCard({
    super.key,
    required this.name,
    required this.info,
    this.imageUrl,
    required this.onTap,
    this.onMessage,
    this.isMatch = false,
  });

  @override
  State<MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends State<MatchCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Imagen de fondo
              widget.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: widget.imageUrl!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: AppColors.accent,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: AppColors.accent,
                        child: const Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : Container(
                      color: AppColors.accent,
                      child: const Icon(
                        Icons.person,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),

              // Badge de Match
              if (widget.isMatch)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'Match',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // Gradiente inferior
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: widget.isMatch ? 100 : 80,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.85),
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
              ),

              // Información del usuario
              Positioned(
                left: 14,
                right: 14,
                bottom: widget.isMatch ? 50 : 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 3,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      widget.info,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withValues(alpha: 0.95),
                        shadows: const [
                          Shadow(
                            offset: Offset(0, 1),
                            blurRadius: 2,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Botón de mensaje para matches
              if (widget.isMatch && widget.onMessage != null)
                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 10,
                  child: GestureDetector(
                    onTap: widget.onMessage,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 6),
                          Text(
                            'Enviar mensaje',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
