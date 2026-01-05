import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/core/app_dimens.dart';
import 'package:social_agraria/core/app_text_styles.dart';
import 'package:social_agraria/models/services/supabase.dart';
import 'package:social_agraria/widgets/empty_states.dart';
import 'package:timeago/timeago.dart' as timeago;

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final _dbService = DatabaseService();
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    timeago.setLocaleMessages('es', timeago.EsMessages());
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() => _isLoading = true);

    try {
      final user = SupabaseService.currentUser;
      if (user == null) {
        setState(() => _isLoading = false);
        return;
      }

      final notifications = await _dbService.getUserNotifications(user.id);
      if (mounted) {
        setState(() {
          _notifications = notifications;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar notificaciones: $e')),
        );
      }
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    try {
      await _dbService.markNotificationAsRead(notificationId);
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> _deleteNotification(int index, String notificationId) async {
    final removedNotification = _notifications[index];
    setState(() {
      _notifications.removeAt(index);
    });

    try {
      await _dbService.deleteNotification(notificationId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Notificación eliminada'),
            duration: const Duration(seconds: 2),
            backgroundColor: AppColors.primaryDarker,
            action: SnackBarAction(
              label: 'Deshacer',
              textColor: AppColors.white,
              onPressed: () {
                setState(() {
                  _notifications.insert(index, removedNotification);
                });
              },
            ),
          ),
        );
      }
    } catch (e) {
      // Restaurar si falla
      if (mounted) {
        setState(() {
          _notifications.insert(index, removedNotification);
        });
      }
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'match':
        return Icons.favorite;
      case 'message':
        return Icons.message;
      case 'like':
        return Icons.thumb_up;
      case 'visit':
        return Icons.visibility;
      case 'system':
        return Icons.info_outline;
      default:
        return Icons.notifications;
    }
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'match':
        return AppColors.primary;
      case 'message':
        return AppColors.primaryDarker;
      case 'like':
        return Colors.pink;
      case 'visit':
        return Colors.orange;
      case 'system':
        return Colors.blue;
      default:
        return AppColors.primaryDarker;
    }
  }

  String _formatTime(DateTime dateTime) {
    return timeago.format(dateTime, locale: 'es');
  }

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
        actions: [
          if (_notifications.isNotEmpty)
            IconButton(
              icon: Icon(Icons.done_all, color: AppColors.primaryDarker),
              onPressed: () async {
                for (var notification in _notifications) {
                  if (notification['is_read'] == false) {
                    await _markAsRead(notification['id']);
                  }
                }
                _loadNotifications();
              },
              tooltip: 'Marcar todas como leídas',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadNotifications,
              color: AppColors.primary,
              child: _notifications.isEmpty
                  ? SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: const NoNotificationsEmptyState(),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _notifications.length,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: AppDimens.espacioSmall),
                      itemBuilder: (context, index) {
                        final notification = _notifications[index];
                        final type = notification['type'] ?? 'system';
                        final isNew = notification['is_read'] == false;
                        final createdAt = notification['created_at'] != null
                            ? DateTime.parse(notification['created_at'])
                            : DateTime.now();

                        return Dismissible(
                          key: Key('notification_${notification['id']}'),
                          direction: DismissDirection.endToStart,
                          onDismissed: (direction) {
                            _deleteNotification(index, notification['id']);
                          },
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20.0),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: const Icon(
                              Icons.delete_outline,
                              color: AppColors.white,
                              size: 32.0,
                            ),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (isNew) {
                                _markAsRead(notification['id']);
                                setState(() {
                                  notification['is_read'] = true;
                                });
                              }
                            },
                            child: _buildNotificationCard(
                              icon: _getIconForType(type),
                              iconColor: _getColorForType(type),
                              title: notification['title'] ?? 'Notificación',
                              message: notification['message'] ?? '',
                              time: _formatTime(createdAt),
                              isNew: isNew,
                            ),
                          ),
                        );
                      },
                    ),
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
      padding: const EdgeInsets.all(16.0),
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
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          color: AppColors.primaryDarker,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isNew)
                      Container(
                        width: 10.0,
                        height: 10.0,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  message,
                  style: TextStyle(
                    color: AppColors.primaryDarker,
                    fontSize: 14.0,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6.0),
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
