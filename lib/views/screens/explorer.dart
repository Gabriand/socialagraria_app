import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/filter.dart';
import 'package:social_agraria/views/screens/notifications.dart';
import 'package:social_agraria/views/screens/profile_detail.dart';

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
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleLikePress() {
    setState(() => isLikePressed = true);
    _animationController.forward().then((_) {
      _animationController.reverse();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) setState(() => isLikePressed = false);
      });
    });
  }

  void _handleDislikePress() {
    setState(() => isDislikePressed = true);
    _animationController.forward().then((_) {
      _animationController.reverse();
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) setState(() => isDislikePressed = false);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
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
          ],
        ),
        title: Text(
          'CampusConnect',
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).push(PageTransitions.scale(const ProfileDetail()));
              },
              child: Container(
                width: 350.0,
                height: 530.0,
                decoration: BoxDecoration(
                  color: AppColors.primaryDarkest,
                  image: DecorationImage(
                    image: AssetImage('assets/images/Erika.jpg'),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(40.0),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.transparent,
                      spreadRadius: 1.0,
                      blurRadius: 13.0,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(23.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Erika, 30',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppDimens.fontSizeTitleMedium,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: AppColors.transparent,
                              offset: Offset(0, 2),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3.0),
                      Text(
                        'Facultad de Computación',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: AppDimens.fontSizeSubtitle,
                          fontWeight: FontWeight.w400,
                          shadows: [
                            Shadow(
                              color: AppColors.transparent,
                              offset: Offset(0, 2),
                              blurRadius: 4.0,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),

                      // Gustos personales
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        spacing: 10.0,
                        children: [
                          Container(
                            width: 93.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              color: AppColors.transparent,
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusLarge,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.music_note, color: AppColors.white),
                                SizedBox(width: 5.0),
                                Text(
                                  'Música',
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 93.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              color: AppColors.transparent,
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusLarge,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.palette_outlined,
                                  color: AppColors.white,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  'Arte',
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 93.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              color: AppColors.transparent,
                              borderRadius: BorderRadius.circular(
                                AppDimens.radiusLarge,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.airplane_ticket_outlined,
                                  color: AppColors.white,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  'Viaje',
                                  style: TextStyle(color: AppColors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 6.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTapDown: (_) => _handleDislikePress(),
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: isDislikePressed ? _scaleAnimation.value : 1.0,
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusRound,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isDislikePressed
                                    ? AppColors.primary.withValues(alpha: 0.3)
                                    : Colors.black.withValues(alpha: 0.1),
                                spreadRadius: 2.0,
                                blurRadius: 10.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.clear,
                            size: 55.0,
                            color: isDislikePressed
                                ? AppColors.primary.withValues(alpha: 0.7)
                                : AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(width: 70.0),
                GestureDetector(
                  onTapDown: (_) => _handleLikePress(),
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: isLikePressed ? _scaleAnimation.value : 1.0,
                        child: Container(
                          width: 80.0,
                          height: 80.0,
                          decoration: BoxDecoration(
                            color: isLikePressed
                                ? AppColors.primary.withValues(alpha: 0.9)
                                : AppColors.primary,
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusRound,
                            ),
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
                            Icons.favorite_border,
                            size: 50.0,
                            color: AppColors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
