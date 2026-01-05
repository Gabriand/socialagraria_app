import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Servicio para manejar Notificaciones Locales y escuchar eventos de Supabase
class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();
  factory PushNotificationService() => _instance;
  PushNotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  RealtimeChannel? _matchesChannel1;
  RealtimeChannel? _matchesChannel2;
  RealtimeChannel? _messagesChannel;

  /// Canal de notificaciones para Android
  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'campus_connect_channel',
    'UniMatch Notifications',
    description: 'Notificaciones de matches, mensajes y más',
    importance: Importance.high,
    playSound: true,
    enableVibration: true,
  );

  /// Inicializar el servicio de notificaciones
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Configurar notificaciones locales
      await _setupLocalNotifications();

      _isInitialized = true;
      debugPrint('✅ Notificaciones locales inicializadas');
    } catch (e) {
      debugPrint('❌ Error inicializando notificaciones: $e');
    }
  }

  /// Configurar notificaciones locales
  Future<void> _setupLocalNotifications() async {
    // Configuración para Android
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    // Configuración para iOS
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Crear canal de notificaciones en Android
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(_channel);
    }

    // Solicitar permisos en Android 13+
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  /// Handler cuando se toca notificación local
  void _onNotificationTapped(NotificationResponse response) {
    debugPrint('👆 Notificación tocada: ${response.payload}');
    // Navegar según el payload
    _navigateFromNotification(response.payload);
  }

  /// Navegar según datos de notificación
  void _navigateFromNotification(String? payload) {
    if (payload == null) return;

    final parts = payload.split(':');
    final type = parts[0];
    final targetId = parts.length > 1 ? parts[1] : null;

    switch (type) {
      case 'match':
        debugPrint('Navegar a match: $targetId');
        break;
      case 'message':
        debugPrint('Navegar a chat: $targetId');
        break;
      case 'like':
        debugPrint('Navegar a likes');
        break;
    }
  }

  /// Suscribirse a eventos de Supabase Realtime para un usuario
  Future<void> subscribeToUserEvents(String userId) async {
    final supabase = Supabase.instance.client;

    // Escuchar nuevos matches donde el usuario es user1
    _matchesChannel1 = supabase
        .channel('matches_user1_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'matches',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user1_id',
            value: userId,
          ),
          callback: (payload) {
            debugPrint(
              '🎉 Nuevo match detectado (user1): ${payload.newRecord}',
            );
            _handleNewMatch(payload.newRecord, userId);
          },
        )
        .subscribe();

    // Escuchar nuevos matches donde el usuario es user2
    _matchesChannel2 = supabase
        .channel('matches_user2_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'matches',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user2_id',
            value: userId,
          ),
          callback: (payload) {
            debugPrint(
              '🎉 Nuevo match detectado (user2): ${payload.newRecord}',
            );
            _handleNewMatch(payload.newRecord, userId);
          },
        )
        .subscribe();

    debugPrint('📡 Suscrito a eventos de matches para $userId');
  }

  /// Manejar nuevo match
  Future<void> _handleNewMatch(
    Map<String, dynamic> matchData,
    String currentUserId,
  ) async {
    try {
      // Obtener el ID del otro usuario
      final otherUserId = matchData['user1_id'] == currentUserId
          ? matchData['user2_id']
          : matchData['user1_id'];

      // Obtener nombre del otro usuario
      final supabase = Supabase.instance.client;
      final profile = await supabase
          .from('profiles')
          .select('nombre')
          .eq('id', otherUserId)
          .single();

      final matchName = profile['nombre'] ?? 'Alguien';

      // Mostrar notificación
      await showMatchNotification(matchName: matchName);
    } catch (e) {
      debugPrint('Error obteniendo datos del match: $e');
      await showMatchNotification(matchName: 'Alguien especial');
    }
  }

  /// Desuscribirse de eventos
  Future<void> unsubscribeFromUserEvents() async {
    await _matchesChannel1?.unsubscribe();
    await _matchesChannel2?.unsubscribe();
    await _messagesChannel?.unsubscribe();
    _matchesChannel1 = null;
    _matchesChannel2 = null;
    _messagesChannel = null;
    debugPrint('📡 Desuscrito de eventos de usuario');
  }

  /// Mostrar notificación local
  Future<void> _showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    final androidDetails = AndroidNotificationDetails(
      _channel.id,
      _channel.name,
      channelDescription: _channel.description,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
      color: const Color(0xFF588157), // AppColors.primary
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(id, title, body, details, payload: payload);
  }

  /// Mostrar notificación de match
  Future<void> showMatchNotification({required String matchName}) async {
    await _showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: '🎉 ¡Nuevo Match!',
      body: '¡Tú y $matchName se gustan mutuamente!',
      payload: 'match',
    );
  }

  /// Mostrar notificación de mensaje
  Future<void> showMessageNotification({
    required String senderName,
    required String message,
    String? chatId,
  }) async {
    await _showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: senderName,
      body: message,
      payload: 'message:$chatId',
    );
  }

  /// Mostrar notificación de like
  Future<void> showLikeNotification() async {
    await _showLocalNotification(
      id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title: '💚 ¡Alguien te dio like!',
      body: 'Sigue explorando para descubrir quién es',
      payload: 'like',
    );
  }

  /// Verificar si las notificaciones están habilitadas
  Future<bool> areNotificationsEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('notifications_enabled') ?? true;
  }

  /// Habilitar/deshabilitar notificaciones
  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
  }

  /// Cancelar todas las notificaciones
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  /// Cancelar una notificación específica
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }
}
