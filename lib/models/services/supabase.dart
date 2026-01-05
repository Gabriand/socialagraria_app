import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Servicio principal para manejar la conexión con Supabase
class SupabaseService {
  static SupabaseClient get client => Supabase.instance.client;

  /// Inicializa Supabase - Llamar en main.dart antes de runApp
  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");

    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
  }

  /// Obtiene el usuario actual
  static User? get currentUser => client.auth.currentUser;

  /// Verifica si hay sesión activa
  static bool get isAuthenticated => currentUser != null;

  /// Stream de cambios de autenticación
  static Stream<AuthState> get authStateChanges =>
      client.auth.onAuthStateChange;
}

/// Servicio de autenticación
class AuthService {
  final SupabaseClient _client = SupabaseService.client;

  /// Registro con email y contraseña
  Future<AuthResponse> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Error al registrar: $e');
    }
  }

  /// Inicio de sesión con email y contraseña
  Future<AuthResponse> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  /// Inicio de sesión con Google
  Future<AuthResponse> signInWithGoogle() async {
    try {
      // Web Client ID de Google Cloud Console
      const webClientId =
          '39736058091-4uml79b0f0cqdqpsrob3ckd2hqlc6lcd.apps.googleusercontent.com';

      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: webClientId,
        scopes: ['email', 'profile'],
      );

      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Inicio de sesión cancelado');
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null || idToken == null) {
        throw Exception('No se pudieron obtener los tokens de Google');
      }

      final response = await _client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      return response;
    } catch (e) {
      throw Exception('Error con Google Sign-In: $e');
    }
  }

  /// Recuperar contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Error al enviar email de recuperación: $e');
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Error al cerrar sesión: $e');
    }
  }
}

/// Servicio para almacenamiento de imágenes en Supabase Storage
class StorageService {
  final SupabaseClient _client = SupabaseService.client;

  // Nombre del bucket para fotos de perfil
  static const String profilePhotosBucket = 'profile-photos';

  /// Sube una imagen al storage de Supabase
  ///
  /// [file] - Archivo de imagen
  /// [userId] - ID del usuario para organizar las imágenes
  /// [index] - Índice de la foto (0-4 para tu caso)
  ///
  /// Retorna la URL pública de la imagen
  Future<String> uploadProfilePhoto({
    required File file,
    required String userId,
    required int index,
  }) async {
    try {
      final fileExtension = file.path.split('.').last.toLowerCase();
      final fileName = '${userId}_photo_$index.$fileExtension';
      final filePath = '$userId/$fileName';

      // Subir archivo
      await _client.storage
          .from(profilePhotosBucket)
          .upload(
            filePath,
            file,
            fileOptions: const FileOptions(
              cacheControl: '3600',
              upsert: true, // Sobrescribir si existe
            ),
          );

      // Obtener URL pública
      final publicUrl = _client.storage
          .from(profilePhotosBucket)
          .getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      throw Exception('Error al subir imagen: $e');
    }
  }

  /// Sube múltiples imágenes
  Future<List<String>> uploadMultiplePhotos({
    required List<File?> files,
    required String userId,
  }) async {
    final List<String> urls = [];

    for (int i = 0; i < files.length; i++) {
      if (files[i] != null) {
        final url = await uploadProfilePhoto(
          file: files[i]!,
          userId: userId,
          index: i,
        );
        urls.add(url);
      }
    }

    return urls;
  }

  /// Elimina una imagen del storage
  Future<void> deleteProfilePhoto({
    required String userId,
    required int index,
  }) async {
    try {
      // Intentar eliminar con diferentes extensiones comunes
      final extensions = ['jpg', 'jpeg', 'png', 'webp'];

      for (final ext in extensions) {
        try {
          final filePath = '$userId/${userId}_photo_$index.$ext';
          await _client.storage.from(profilePhotosBucket).remove([filePath]);
        } catch (_) {
          // Continuar si no existe con esta extensión
        }
      }
    } catch (e) {
      throw Exception('Error al eliminar imagen: $e');
    }
  }
}

/// Servicio para operaciones de base de datos (perfiles de usuario)
class DatabaseService {
  final SupabaseClient _client = SupabaseService.client;

  /// Crear perfil de usuario
  Future<void> createUserProfile({
    required String userId,
    required String email,
    required String nombre,
    required String apellido,
    required int edad,
    required String telefono,
    String? universidad,
    String? facultad,
    String? carrera,
    String? semestre,
    String? descripcion,
    List<String>? intereses,
    List<String>? photoUrls,
    int? altura,
    String? signoZodiacal,
    String? bebe,
    String? fuma,
    String? buscando,
    String? genero,
  }) async {
    try {
      await _client.from('profiles').insert({
        'id': userId,
        'email': email,
        'nombre': nombre,
        'apellido': apellido,
        'edad': edad,
        'telefono': telefono,
        'universidad': universidad,
        'facultad': facultad,
        'carrera': carrera,
        'semestre': semestre,
        'descripcion': descripcion,
        'intereses': intereses,
        'photo_urls': photoUrls,
        'altura': altura,
        'signo_zodiacal': signoZodiacal,
        'bebe': bebe,
        'fuma': fuma,
        'buscando': buscando,
        'genero': genero,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al crear perfil: $e');
    }
  }

  /// Actualizar perfil de usuario
  Future<void> updateUserProfile({
    required String userId,
    String? nombre,
    String? apellido,
    int? edad,
    String? telefono,
    String? universidad,
    String? facultad,
    String? carrera,
    String? semestre,
    String? descripcion,
    List<String>? intereses,
    List<String>? photoUrls,
    int? altura,
    String? signoZodiacal,
    String? bebe,
    String? fuma,
    String? buscando,
    String? genero,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'updated_at': DateTime.now().toIso8601String(),
      };

      if (nombre != null) updates['nombre'] = nombre;
      if (apellido != null) updates['apellido'] = apellido;
      if (edad != null) updates['edad'] = edad;
      if (telefono != null) updates['telefono'] = telefono;
      if (universidad != null) updates['universidad'] = universidad;
      if (facultad != null) updates['facultad'] = facultad;
      if (carrera != null) updates['carrera'] = carrera;
      if (semestre != null) updates['semestre'] = semestre;
      if (descripcion != null) updates['descripcion'] = descripcion;
      if (intereses != null) updates['intereses'] = intereses;
      if (photoUrls != null) updates['photo_urls'] = photoUrls;
      if (altura != null) updates['altura'] = altura;
      if (signoZodiacal != null) updates['signo_zodiacal'] = signoZodiacal;
      if (bebe != null) updates['bebe'] = bebe;
      if (fuma != null) updates['fuma'] = fuma;
      if (buscando != null) updates['buscando'] = buscando;
      if (genero != null) updates['genero'] = genero;

      await _client.from('profiles').update(updates).eq('id', userId);
    } catch (e) {
      throw Exception('Error al actualizar perfil: $e');
    }
  }

  /// Obtener perfil de usuario
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      throw Exception('Error al obtener perfil: $e');
    }
  }

  /// Obtener perfiles para explorar (matcheo)
  Future<List<Map<String, dynamic>>> getProfilesToExplore({
    required String currentUserId,
    int limit = 10,
  }) async {
    try {
      // Obtener IDs de perfiles ya swiped (like o dislike)
      final swipedResponse = await _client
          .from('swipes')
          .select('target_user_id')
          .eq('user_id', currentUserId);

      final swipedIds = (swipedResponse as List)
          .map((s) => s['target_user_id'] as String)
          .toList();

      // Obtener IDs de matches existentes
      final matchesResponse = await _client
          .from('matches')
          .select('user1_id, user2_id')
          .or('user1_id.eq.$currentUserId,user2_id.eq.$currentUserId');

      final matchedIds = <String>{};
      for (final match in matchesResponse as List) {
        if (match['user1_id'] == currentUserId) {
          matchedIds.add(match['user2_id'] as String);
        } else {
          matchedIds.add(match['user1_id'] as String);
        }
      }

      // Combinar todos los IDs a excluir
      final excludeIds = {...swipedIds, ...matchedIds, currentUserId}.toList();

      // Obtener perfiles que no estén en la lista de exclusión
      final response = await _client
          .from('profiles')
          .select()
          .not('id', 'in', excludeIds)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Error al obtener perfiles: $e');
    }
  }

  /// Registrar un swipe (like o dislike)
  /// Ya NO crea match automáticamente - el usuario debe aceptar desde "Likes recibidos"
  Future<void> recordSwipe({
    required String userId,
    required String targetUserId,
    required bool isLike,
  }) async {
    try {
      final action = isLike ? 'like' : 'dislike';
      debugPrint(
        '📱 Registrando swipe: $userId -> $targetUserId (action: $action)',
      );

      // Verificar si ya existe un swipe previo
      final existingSwipe = await _client
          .from('swipes')
          .select()
          .eq('user_id', userId)
          .eq('target_user_id', targetUserId)
          .maybeSingle();

      if (existingSwipe != null) {
        debugPrint('⚠️ Ya existe un swipe de $userId a $targetUserId');
        // Si ya existe, actualizar en lugar de insertar
        await _client
            .from('swipes')
            .update({
              'action': action,
              'created_at': DateTime.now().toIso8601String(),
            })
            .eq('user_id', userId)
            .eq('target_user_id', targetUserId);
        debugPrint('✅ Swipe actualizado correctamente');
      } else {
        // Insertar nuevo swipe
        await _client.from('swipes').insert({
          'user_id': userId,
          'target_user_id': targetUserId,
          'action': action,
        });
        debugPrint('✅ Swipe insertado correctamente');
      }
    } catch (e) {
      debugPrint('❌ Error al registrar swipe: $e');
      throw Exception('Error al registrar swipe: $e');
    }
  }

  /// Obtener likes recibidos (personas que te dieron like pero tú no has respondido)
  Future<List<Map<String, dynamic>>> getLikesReceived(String userId) async {
    try {
      debugPrint('💝 Obteniendo likes recibidos para: $userId');

      // Obtener todos los likes que me han dado
      final likesReceived = await _client
          .from('swipes')
          .select('user_id')
          .eq('target_user_id', userId)
          .eq('action', 'like');

      if ((likesReceived as List).isEmpty) {
        debugPrint('📭 No hay likes recibidos');
        return [];
      }

      // Obtener los IDs de quienes me dieron like
      final likerIds = likesReceived
          .map((s) => s['user_id'] as String)
          .toList();
      debugPrint('👥 Likes de: $likerIds');

      // Verificar cuáles ya tienen match (ya acepté)
      final existingMatches = await _client
          .from('matches')
          .select('user1_id, user2_id')
          .or('user1_id.eq.$userId,user2_id.eq.$userId');

      // Extraer IDs de usuarios con los que ya tengo match
      final matchedIds = <String>{};
      for (final match in existingMatches as List) {
        if (match['user1_id'] == userId) {
          matchedIds.add(match['user2_id']);
        } else {
          matchedIds.add(match['user1_id']);
        }
      }
      debugPrint('✅ Ya tengo match con: $matchedIds');

      // Filtrar: likes recibidos que NO tienen match aún
      final pendingLikerIds = likerIds
          .where((id) => !matchedIds.contains(id))
          .toList();
      debugPrint('⏳ Likes pendientes de: $pendingLikerIds');

      if (pendingLikerIds.isEmpty) {
        return [];
      }

      // Obtener perfiles de los que me dieron like pendiente
      final profiles = await _client
          .from('profiles')
          .select('*')
          .inFilter('id', pendingLikerIds);

      debugPrint(
        '📋 Perfiles de likes recibidos: ${(profiles as List).length}',
      );
      return List<Map<String, dynamic>>.from(profiles);
    } catch (e) {
      debugPrint('❌ Error al obtener likes recibidos: $e');
      throw Exception('Error al obtener likes recibidos: $e');
    }
  }

  /// Aceptar un like (crear match)
  Future<void> acceptLike({
    required String currentUserId,
    required String likerUserId,
  }) async {
    try {
      debugPrint('💕 Aceptando like de $likerUserId');

      // Verificar que no exista el match ya
      final existingMatch = await _client
          .from('matches')
          .select()
          .or(
            'and(user1_id.eq.$currentUserId,user2_id.eq.$likerUserId),and(user1_id.eq.$likerUserId,user2_id.eq.$currentUserId)',
          )
          .maybeSingle();

      if (existingMatch != null) {
        debugPrint('⚠️ El match ya existía');
        return;
      }

      // Crear el match
      await _client.from('matches').insert({
        'user1_id': likerUserId, // Quien dio like primero
        'user2_id': currentUserId, // Quien acepta
      });

      debugPrint('💕 ¡MATCH CREADO! $likerUserId <-> $currentUserId');
    } catch (e) {
      debugPrint('❌ Error al aceptar like: $e');
      throw Exception('Error al aceptar like: $e');
    }
  }

  /// Rechazar un like (registrar dislike de vuelta)
  Future<void> rejectLike({
    required String currentUserId,
    required String likerUserId,
  }) async {
    try {
      debugPrint('👎 Rechazando like de $likerUserId');

      // Registrar que rechazamos a esta persona
      await recordSwipe(
        userId: currentUserId,
        targetUserId: likerUserId,
        isLike: false,
      );

      debugPrint('✅ Like rechazado');
    } catch (e) {
      debugPrint('❌ Error al rechazar like: $e');
      throw Exception('Error al rechazar like: $e');
    }
  }

  /// Obtener matches del usuario
  Future<List<Map<String, dynamic>>> getUserMatches(String userId) async {
    try {
      debugPrint('🔍 Obteniendo matches para usuario: $userId');

      // Obtener matches donde el usuario es user1 o user2
      final response = await _client
          .from('matches')
          .select('*')
          .or('user1_id.eq.$userId,user2_id.eq.$userId')
          .order('created_at', ascending: false);

      debugPrint('📊 Matches encontrados: ${(response as List).length}');

      // Para cada match, obtener el perfil del otro usuario
      final List<Map<String, dynamic>> matches = [];
      for (final match in response) {
        final otherUserId = match['user1_id'] == userId
            ? match['user2_id']
            : match['user1_id'];

        debugPrint('👤 Obteniendo perfil de: $otherUserId');

        try {
          final profileResponse = await _client
              .from('profiles')
              .select('*')
              .eq('id', otherUserId)
              .maybeSingle();

          if (profileResponse != null) {
            matches.add(profileResponse);
            debugPrint('✅ Perfil obtenido: ${profileResponse['nombre']}');
          } else {
            debugPrint('⚠️ Perfil no encontrado para: $otherUserId');
          }
        } catch (e) {
          debugPrint('❌ Error al obtener perfil de match: $e');
        }
      }

      debugPrint('📋 Total de matches con perfil: ${matches.length}');
      return matches;
    } catch (e) {
      debugPrint('❌ Error al obtener matches: $e');
      throw Exception('Error al obtener matches: $e');
    }
  }

  /// Eliminar un match
  Future<void> deleteMatch({
    required String currentUserId,
    required String otherUserId,
  }) async {
    try {
      await _client
          .from('matches')
          .delete()
          .or(
            'and(user1_id.eq.$currentUserId,user2_id.eq.$otherUserId),and(user1_id.eq.$otherUserId,user2_id.eq.$currentUserId)',
          );
    } catch (e) {
      throw Exception('Error al eliminar match: $e');
    }
  }

  /// Obtener likes que el usuario ha dado (para "Tus Matches" antes de match mutuo)
  Future<List<Map<String, dynamic>>> getUserLikes(String userId) async {
    try {
      final response = await _client
          .from('swipes')
          .select('target_user_id, profiles!swipes_target_user_id_fkey(*)')
          .eq('user_id', userId)
          .eq('is_like', true)
          .order('created_at', ascending: false);

      return (response as List)
          .map((s) => s['profiles'] as Map<String, dynamic>)
          .toList();
    } catch (e) {
      throw Exception('Error al obtener likes: $e');
    }
  }

  // ============= NOTIFICACIONES =============

  /// Obtener notificaciones del usuario
  Future<List<Map<String, dynamic>>> getUserNotifications(String userId) async {
    try {
      final response = await _client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(50);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      throw Exception('Error al obtener notificaciones: $e');
    }
  }

  /// Crear una notificación
  Future<void> createNotification({
    required String userId,
    required String type,
    required String title,
    required String message,
    String? relatedUserId,
  }) async {
    try {
      await _client.from('notifications').insert({
        'user_id': userId,
        'type': type,
        'title': title,
        'message': message,
        'related_user_id': relatedUserId,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al crear notificación: $e');
    }
  }

  /// Marcar notificación como leída
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await _client
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notificationId);
    } catch (e) {
      throw Exception('Error al marcar notificación: $e');
    }
  }

  /// Eliminar notificación
  Future<void> deleteNotification(String notificationId) async {
    try {
      await _client.from('notifications').delete().eq('id', notificationId);
    } catch (e) {
      throw Exception('Error al eliminar notificación: $e');
    }
  }

  /// Contar notificaciones no leídas
  Future<int> getUnreadNotificationCount(String userId) async {
    try {
      final response = await _client
          .from('notifications')
          .select()
          .eq('user_id', userId)
          .eq('is_read', false);

      return (response as List).length;
    } catch (e) {
      return 0;
    }
  }
}
