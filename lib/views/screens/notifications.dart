import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/app_text_styles.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final List<Map<String, dynamic>> notifications = [
    {
      'icon': Icons.favorite,
      'iconColor': AppColors.primary,
      'title': '¡Nuevo Match!',
      'message': 'Tienes un nuevo match con Laura. ¡Empieza a conversar!',
      'time': 'Hace 2 horas',
      'isNew': true,
    },
    {
      'icon': Icons.message,
      'iconColor': AppColors.primaryDarker,
      'title': 'Nuevo mensaje',
      'message': 'Carlos te ha enviado un mensaje: "¡Hola! ¿Cómo estás?"',
      'time': 'Hace 5 horas',
      'isNew': true,
    },
    {
      'icon': Icons.person_add,
      'iconColor': AppColors.accent,
      'title': 'Te han visitado',
      'message': 'Ana ha visto tu perfil',
      'time': 'Ayer',
      'isNew': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primaryDarker),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: Text('Notificaciones', style: AppTextStyles.titleMedium),
      ),
      body: notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80.0,
                    color: AppColors.accent,
                  ),
                  SizedBox(height: AppDimens.espacioMedium),
                  Text(
                    'No tienes notificaciones',
                    style: TextStyle(
                      color: AppColors.primaryDarker,
                      fontSize: AppDimens.fontSizeSubtitle,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16.0),
              itemCount: notifications.length,
              separatorBuilder: (context, index) =>
                  SizedBox(height: AppDimens.espacioSmall),
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return Dismissible(
                  key: Key('notification_$index'),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    setState(() {
                      notifications.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Notificación eliminada'),
                        duration: Duration(seconds: 2),
                        backgroundColor: AppColors.primaryDarker,
                      ),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: AppColors.white,
                      size: 32.0,
                    ),
                  ),
                  child: _buildNotificationCard(
                    icon: notification['icon'],
                    iconColor: notification['iconColor'],
                    title: notification['title'],
                    message: notification['message'],
                    time: notification['time'],
                    isNew: notification['isNew'],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String message,
    required String time,
    required bool isNew,
  }) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isNew ? AppColors.white : AppColors.white.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(
          color: isNew
              ? AppColors.primary.withValues(alpha: 0.3)
              : AppColors.accent.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28.0),
          ),
          SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.primaryDarker,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isNew)
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 6.0),
                Text(
                  message,
                  style: TextStyle(
                    color: AppColors.primaryDarker,
                    fontSize: 14.0,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 6.0),
                Text(
                  time,
                  style: TextStyle(
                    color: AppColors.primaryDarker.withValues(alpha: 0.6),
                    fontSize: 12.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
