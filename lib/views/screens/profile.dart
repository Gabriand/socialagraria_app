import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/app_text_styles.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/views/screens/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
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
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/images/Erika.jpg'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: AppColors.primary, width: 3.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),

                Center(
                  child: Text(
                    'Erika, 30',
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontSize: AppDimens.fontSizeTitleMedium,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),

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
                        'Facultad de Computación',
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
                  children: [
                    Container(
                      width: 100.0,
                      height: 130.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusMedium,
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/images/Erika.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: 100.0,
                      height: 130.0,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusMedium,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.primaryDarker,
                        size: 40.0,
                      ),
                    ),
                    Container(
                      width: 100.0,
                      height: 130.0,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusMedium,
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.primaryDarker,
                        size: 40.0,
                      ),
                    ),
                  ],
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
                    borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                  ),
                  child: Text(
                    'Amante de los libros, el café con leche y los paseos por el Retiro. Busco a alguien con quien compartir risas y descubrir nuevas series en Netflix. 📚🎬',
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
                  children: [
                    _buildInterestChip('Música'),
                    _buildInterestChip('Cine'),
                    _buildInterestChip('Viajar'),
                    _buildInterestChip('Arte'),
                  ],
                ),
                SizedBox(height: 30.0),

                SizedBox(
                  width: double.infinity,
                  height: AppDimens.buttonHeightMedium,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageTransitions.slideFromRight(const EditProfile()),
                      );
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
