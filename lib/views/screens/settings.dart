import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/app_text_styles.dart';
import 'package:social_agraria/core/page_transitions.dart';
import 'package:social_agraria/models/services/supabase.dart';
import 'package:social_agraria/views/screens/simple_text.dart';
import 'package:social_agraria/views/screens/welcome.dart';
import 'package:social_agraria/widgets/background_card.dart';
import 'package:social_agraria/widgets/horizontal_separator.dart';
import 'package:social_agraria/controllers/user_controller.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, userController, child) {
        final profile = userController.profile;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
            centerTitle: true,
            title: Text('Ajustes', style: AppTextStyles.titleMedium),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferencias',
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontWeight: FontWeight.bold,
                      fontSize: AppDimens.fontSizeSubtitle,
                    ),
                  ),
                  CardWidget(
                    height: 70.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Idioma',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: AppColors.primaryDarker,
                                ),
                              ),
                              DropdownButton<String>(
                                value: userController.selectedLanguage,
                                underline: const SizedBox(),
                                dropdownColor: AppColors.white,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.radiusSmall,
                                ),
                                menuMaxHeight: 220.0,
                                menuWidth: 100.0,
                                icon: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: AppColors.primaryDarker,
                                ),
                                style: TextStyle(
                                  color: AppColors.primaryDarker.withAlpha(160),
                                  fontSize: 16.0,
                                ),
                                onChanged: (value) {
                                  if (value != null) {
                                    userController.setLanguage(value);
                                  }
                                },
                                items: const ['Español', 'Inglés']
                                    .map(
                                      (lang) => DropdownMenuItem(
                                        value: lang,
                                        child: Text(lang),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Notificaciones',
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  CardWidget(
                    height: 70.0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 0.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Nuevos Matches',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: AppColors.primaryDarker,
                            ),
                          ),
                          Switch(
                            activeTrackColor: AppColors.primary,
                            value: userController.matchNotificationsEnabled,
                            onChanged: (bool newValue) {
                              userController.setMatchNotificationsEnabled(
                                newValue,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    'Cuenta',
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  CardWidget(
                    height: 170.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    color: AppColors.primaryDarker,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: AppColors.primaryDarker,
                                    ),
                                  ),
                                ],
                              ),
                              Flexible(
                                child: Text(
                                  profile?.email ?? 'No configurado',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.primaryDarker.withAlpha(
                                      160,
                                    ),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SeparatorhWidget(width: double.infinity),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.verified_user_outlined,
                                    color: AppColors.primaryDarker,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Estado',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: AppColors.primaryDarker,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withAlpha(30),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Verificado',
                                  style: TextStyle(
                                    fontSize: 14.0,
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SeparatorhWidget(width: double.infinity),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 14.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: AppColors.primaryDarker,
                                    size: 20,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Miembro desde',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      color: AppColors.primaryDarker,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                _formatMemberSince(profile?.createdAt),
                                style: TextStyle(
                                  fontSize: 14.0,
                                  color: AppColors.primaryDarker.withAlpha(160),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Cambiar contraseña
                  CardWidget(
                    margin: const EdgeInsets.only(top: 0.0, bottom: 10.0),
                    height: 60.0,
                    child: InkWell(
                      onTap: () => _showChangePasswordDialog(context),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lock_outline,
                                  color: AppColors.primaryDarker,
                                  size: 22,
                                ),
                                SizedBox(width: 12),
                                Text(
                                  'Cambiar contraseña',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: AppColors.primaryDarker,
                                  ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: AppColors.primaryDarker,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  CardWidget(
                    margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                    height: 60.0,
                    child: InkWell(
                      onTap: () async {
                        await userController.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            PageTransitions.fade(const Welcome()),
                            (route) => false,
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          'Cerrar Sesión',
                          style: TextStyle(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CardWidget(
                    margin: const EdgeInsets.only(top: 10.0, bottom: 16.0),
                    height: 60.0,
                    child: InkWell(
                      onTap: () =>
                          _showDeleteAccountDialog(context, userController),
                      child: Center(
                        child: Text(
                          'Eliminar Cuenta',
                          style: TextStyle(
                            color: AppColors.error,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Legal',
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  CardWidget(
                    height: 129.0,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Términos y Condiciones',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: AppColors.primaryDarker,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: AppColors.primaryDarker,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    PageTransitions.slideFromRight(
                                      const SimpleText(
                                        title: 'Términos y Condiciones',
                                        body:
                                            'Aquí van los términos y condiciones...',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        SeparatorhWidget(width: double.infinity),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Política de Privacidad',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: AppColors.primaryDarker,
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_right_rounded,
                                  color: AppColors.primaryDarker,
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(
                                    PageTransitions.slideFromRight(
                                      const SimpleText(
                                        title: 'Política de Privacidad',
                                        body: 'Aquí van las Políticas...',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
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
      },
    );
  }

  String _formatMemberSince(DateTime? date) {
    if (date == null) return 'Reciente';
    final months = [
      'Ene',
      'Feb',
      'Mar',
      'Abr',
      'May',
      'Jun',
      'Jul',
      'Ago',
      'Sep',
      'Oct',
      'Nov',
      'Dic',
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool isLoading = false;
    bool obscureCurrent = true;
    bool obscureNew = true;
    bool obscureConfirm = true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.background,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Row(
              children: [
                Icon(Icons.lock_outline, color: AppColors.primaryDarker),
                SizedBox(width: 10),
                Text(
                  'Cambiar contraseña',
                  style: TextStyle(
                    color: AppColors.primaryDarker,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: currentPasswordController,
                    obscureText: obscureCurrent,
                    decoration: InputDecoration(
                      labelText: 'Contraseña actual',
                      labelStyle: TextStyle(color: AppColors.primaryDarker),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureCurrent
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primaryDarker,
                        ),
                        onPressed: () => setDialogState(
                          () => obscureCurrent = !obscureCurrent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: newPasswordController,
                    obscureText: obscureNew,
                    decoration: InputDecoration(
                      labelText: 'Nueva contraseña',
                      labelStyle: TextStyle(color: AppColors.primaryDarker),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureNew ? Icons.visibility_off : Icons.visibility,
                          color: AppColors.primaryDarker,
                        ),
                        onPressed: () =>
                            setDialogState(() => obscureNew = !obscureNew),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirm,
                    decoration: InputDecoration(
                      labelText: 'Confirmar contraseña',
                      labelStyle: TextStyle(color: AppColors.primaryDarker),
                      filled: true,
                      fillColor: AppColors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureConfirm
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: AppColors.primaryDarker,
                        ),
                        onPressed: () => setDialogState(
                          () => obscureConfirm = !obscureConfirm,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: isLoading ? null : () => Navigator.pop(context),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: AppColors.primaryDarker),
                ),
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        // Validaciones
                        if (newPasswordController.text.isEmpty ||
                            confirmPasswordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Por favor completa todos los campos',
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        if (newPasswordController.text.length < 6) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'La contraseña debe tener al menos 6 caracteres',
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        if (newPasswordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Las contraseñas no coinciden'),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }

                        setDialogState(() => isLoading = true);

                        try {
                          await SupabaseService.client.auth.updateUser(
                            UserAttributes(
                              password: newPasswordController.text,
                            ),
                          );

                          if (context.mounted) {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Contraseña actualizada correctamente',
                                ),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        } catch (e) {
                          setDialogState(() => isLoading = false);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Error al cambiar contraseña: $e',
                                ),
                                backgroundColor: AppColors.error,
                              ),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text('Cambiar', style: TextStyle(color: AppColors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteAccountDialog(
    BuildContext context,
    UserController userController,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withAlpha(30),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.warning_amber_rounded,
                color: AppColors.error,
                size: 28,
              ),
            ),
            SizedBox(width: 12),
            Text(
              '¿Eliminar cuenta?',
              style: TextStyle(
                color: AppColors.error,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Esta acción es permanente y no se puede deshacer.',
              style: TextStyle(color: AppColors.primaryDarker, fontSize: 15),
            ),
            SizedBox(height: 12),
            Text(
              'Se eliminarán:',
              style: TextStyle(
                color: AppColors.primaryDarker,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 8),
            _buildDeleteItem('Tu perfil y fotos'),
            _buildDeleteItem('Todos tus matches'),
            _buildDeleteItem('Historial de conversaciones'),
            _buildDeleteItem('Preferencias guardadas'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: AppColors.primaryDarker,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              final success = await userController.deleteAccount();
              if (success && context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  PageTransitions.fade(const Welcome()),
                  (route) => false,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Sí, eliminar',
              style: TextStyle(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeleteItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Icon(
            Icons.remove_circle_outline,
            size: 16,
            color: AppColors.error.withAlpha(180),
          ),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: AppColors.primaryDarker.withAlpha(180),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
