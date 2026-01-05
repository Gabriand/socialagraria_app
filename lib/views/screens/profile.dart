import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/app_text_styles.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/edit_profile.dart';
import 'package:social_agraria/views/screens/photo_gallery.dart';
import 'package:social_agraria/controllers/user_controller.dart';
import 'package:social_agraria/widgets/photo_zoom_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  void initState() {
    super.initState();
    // Cargar perfil al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserController>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        final profile = userController.profile;

        if (userController.isLoading) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('Mi Perfil', style: AppTextStyles.titleMedium),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (profile == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('Mi Perfil', style: AppTextStyles.titleMedium),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 80, color: AppColors.accent),
                  const SizedBox(height: 16),
                  Text(
                    'No se encontró el perfil',
                    style: TextStyle(color: AppColors.primaryDarker),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => userController.loadProfile(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('Mi Perfil', style: AppTextStyles.titleMedium),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: AppDimens.espacioMedium),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if (profile.mainPhoto != null) {
                            PhotoZoomDialog.show(
                              context,
                              imageUrl: profile.mainPhoto!,
                              heroTag: 'profile_main_photo',
                            );
                          }
                        },
                        child: Hero(
                          tag: 'profile_main_photo',
                          child: Container(
                            width: 140.0,
                            height: 140.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary,
                                width: 3.0,
                              ),
                            ),
                            child: ClipOval(
                              child: profile.mainPhoto != null
                                  ? CachedNetworkImage(
                                      imageUrl: profile.mainPhoto!,
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
                                              size: 60,
                                              color: AppColors.primaryDarker,
                                            ),
                                          ),
                                    )
                                  : Container(
                                      color: AppColors.accent,
                                      child: Icon(
                                        Icons.person,
                                        size: 60,
                                        color: AppColors.primaryDarker,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),

                    Center(
                      child: Text(
                        profile.displayName,
                        style: TextStyle(
                          color: AppColors.primaryDarker,
                          fontSize: AppDimens.fontSizeTitleMedium,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),

                    if (profile.carrera != null || profile.semestre != null)
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.school_outlined,
                              color: AppColors.primaryDarker,
                              size: 20.0,
                            ),
                            SizedBox(width: 8.0),
                            Text(
                              profile.academicInfo,
                              style: TextStyle(
                                color: AppColors.primaryDarker,
                                fontSize: AppDimens.fontSizeBody,
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(height: 30.0),

                    Text(
                      'Mis Fotos',
                      style: TextStyle(
                        color: AppColors.primaryDarker,
                        fontSize: AppDimens.fontSizeTitleMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(3, (index) {
                        final hasPhoto = index < profile.photoUrls.length;
                        return GestureDetector(
                          onTap: hasPhoto
                              ? () {
                                  Navigator.push(
                                    context,
                                    PageTransitions.fade(
                                      PhotoGallery(
                                        imageUrls: profile.photoUrls,
                                        initialIndex: index,
                                        heroTag: 'my_photo',
                                      ),
                                    ),
                                  );
                                }
                              : null,
                          child: Hero(
                            tag: 'my_photo_$index',
                            child: Container(
                              width: 100.0,
                              height: 130.0,
                              decoration: BoxDecoration(
                                color: AppColors.accent,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusMedium,
                                ),
                              ),
                              child: hasPhoto
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        AppDimens.radiusMedium,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: profile.photoUrls[index],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                        errorWidget: (context, url, error) =>
                                            Icon(
                                              Icons.broken_image,
                                              color: AppColors.primaryDarker,
                                            ),
                                      ),
                                    )
                                  : Icon(
                                      Icons.camera_alt_outlined,
                                      color: AppColors.primaryDarker,
                                      size: 40.0,
                                    ),
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 30.0),

                    Text(
                      'Sobre mí',
                      style: TextStyle(
                        color: AppColors.primaryDarker,
                        fontSize: AppDimens.fontSizeTitleMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.0),

                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusLarge,
                        ),
                      ),
                      child: Text(
                        profile.descripcion ?? 'Sin descripción',
                        style: TextStyle(
                          color: AppColors.primaryDarker,
                          fontSize: AppDimens.fontSizeBody,
                          height: 1.5,
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0),

                    Text(
                      'Mis Intereses',
                      style: TextStyle(
                        color: AppColors.primaryDarker,
                        fontSize: AppDimens.fontSizeTitleMedium,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15.0),

                    Wrap(
                      spacing: 10.0,
                      runSpacing: 10.0,
                      children: profile.intereses.isEmpty
                          ? [
                              Text(
                                'Sin intereses',
                                style: TextStyle(
                                  color: AppColors.primaryDarker,
                                ),
                              ),
                            ]
                          : profile.intereses
                                .map((i) => _buildInterestChip(i))
                                .toList(),
                    ),
                    SizedBox(height: 30.0),

                    SizedBox(
                      width: double.infinity,
                      height: AppDimens.buttonHeightMedium,
                      child: ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            PageTransitions.slideFromRight(const EditProfile()),
                          );
                          // Recargar perfil después de editar
                          userController.loadProfile();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDarker,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusXLarge,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.edit_outlined,
                              color: AppColors.white,
                              size: 22.0,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                              'Editar Perfil',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: AppDimens.fontSizeSubtitle,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInterestChip(String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(AppDimens.radiusXLarge),
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
}
