import 'package:flutter/material.dart';
import 'package:social_agraria/models/model.dart';
import 'package:social_agraria/models/services/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Controller para manejar el estado del usuario y sus preferencias
class UserController extends ChangeNotifier {
  final _dbService = DatabaseService();
  final _authService = AuthService();

  UserProfile? _profile;
  bool _isLoading = false;
  String? _error;

  // Preferencias del usuario
  bool _soundsEnabled = true;
  bool _matchNotificationsEnabled = true;
  String _selectedLanguage = 'Español';

  // Getters
  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isLoggedIn => SupabaseService.currentUser != null;
  bool get hasProfile => _profile != null;

  // Preferencias getters
  bool get soundsEnabled => _soundsEnabled;
  bool get matchNotificationsEnabled => _matchNotificationsEnabled;
  String get selectedLanguage => _selectedLanguage;

  /// Inicializar el controller - cargar datos del usuario si está logueado
  Future<void> initialize() async {
    await _loadPreferences();
    if (isLoggedIn) {
      await loadProfile();
    }
  }

  /// Cargar el perfil del usuario actual
  Future<void> loadProfile() async {
    final user = SupabaseService.currentUser;
    if (user == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _dbService.getUserProfile(user.id);
      if (data != null) {
        _profile = UserProfile.fromJson(data);
      } else {
        _profile = null;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Crear perfil para usuario de Google (si no existe)
  Future<bool> ensureProfileExists() async {
    final user = SupabaseService.currentUser;
    if (user == null) return false;

    try {
      // Verificar si ya existe el perfil
      final existingProfile = await _dbService.getUserProfile(user.id);
      if (existingProfile != null) {
        _profile = UserProfile.fromJson(existingProfile);
        notifyListeners();
        return true;
      }

      // Crear perfil básico con datos de Google
      final metadata = user.userMetadata;
      final fullName = metadata?['full_name'] ?? metadata?['name'] ?? '';
      final nameParts = fullName.toString().split(' ');

      await _dbService.createUserProfile(
        userId: user.id,
        email: user.email ?? '',
        nombre: nameParts.isNotEmpty ? nameParts.first : 'Usuario',
        apellido: nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '',
        edad: 0,
        telefono: '',
      );

      // Cargar el perfil recién creado
      await loadProfile();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Actualizar perfil
  Future<bool> updateProfile({
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
  }) async {
    final user = SupabaseService.currentUser;
    if (user == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      await _dbService.updateUserProfile(
        userId: user.id,
        nombre: nombre,
        apellido: apellido,
        edad: edad,
        telefono: telefono,
        universidad: universidad,
        facultad: facultad,
        carrera: carrera,
        semestre: semestre,
        descripcion: descripcion,
        intereses: intereses,
        photoUrls: photoUrls,
      );

      // Recargar el perfil
      await loadProfile();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cerrar sesión
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      _profile = null;
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  /// Eliminar cuenta
  Future<bool> deleteAccount() async {
    final user = SupabaseService.currentUser;
    if (user == null) return false;

    try {
      // Eliminar perfil de la base de datos
      await SupabaseService.client.from('profiles').delete().eq('id', user.id);

      // Cerrar sesión
      await signOut();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // ============ PREFERENCIAS ============

  /// Cargar preferencias desde SharedPreferences
  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _soundsEnabled = prefs.getBool('sounds_enabled') ?? true;
      _matchNotificationsEnabled = prefs.getBool('match_notifications') ?? true;
      _selectedLanguage = prefs.getString('language') ?? 'Español';
      notifyListeners();
    } catch (e) {
      // Usar valores por defecto si hay error
    }
  }

  /// Guardar y actualizar sonidos
  Future<void> setSoundsEnabled(bool value) async {
    _soundsEnabled = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sounds_enabled', value);
  }

  /// Guardar y actualizar notificaciones de matches
  Future<void> setMatchNotificationsEnabled(bool value) async {
    _matchNotificationsEnabled = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('match_notifications', value);
  }

  /// Guardar y actualizar idioma
  Future<void> setLanguage(String value) async {
    _selectedLanguage = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', value);
  }

  /// Limpiar error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
