/// Modelo de perfil de usuario
class UserProfile {
  final String id;
  final String email;
  final String nombre;
  final String apellido;
  final int? edad;
  final String? telefono;
  final String? universidad;
  final String? facultad;
  final String? carrera;
  final String? semestre;
  final String? descripcion;
  final List<String> intereses;
  final List<String> photoUrls;
  final DateTime? createdAt;

  // Campos adicionales de detalles personales
  final int? altura; // en cm
  final String? signoZodiacal;
  final String? bebe;
  final String? fuma;
  final String? buscando;
  final String? genero;

  UserProfile({
    required this.id,
    required this.email,
    required this.nombre,
    required this.apellido,
    this.edad,
    this.telefono,
    this.universidad,
    this.facultad,
    this.carrera,
    this.semestre,
    this.descripcion,
    this.intereses = const [],
    this.photoUrls = const [],
    this.createdAt,
    this.altura,
    this.signoZodiacal,
    this.bebe,
    this.fuma,
    this.buscando,
    this.genero,
  });

  /// Nombre completo
  String get fullName => '$nombre $apellido';

  /// Nombre con edad
  String get displayName =>
      edad != null && edad! > 0 ? '$nombre, $edad' : nombre;

  /// Primera foto o null
  String? get mainPhoto => photoUrls.isNotEmpty ? photoUrls.first : null;

  /// Verifica si los datos básicos están completos
  bool get hasBasicInfo =>
      nombre.isNotEmpty && apellido.isNotEmpty && edad != null && edad! > 0;

  /// Verifica si tiene datos de afiliación
  bool get hasAffiliationInfo => universidad != null && universidad!.isNotEmpty;

  /// Info académica resumida (carrera y semestre)
  String get academicInfo {
    final parts = <String>[];
    if (carrera != null && carrera!.isNotEmpty) parts.add(carrera!);
    if (semestre != null && semestre!.isNotEmpty) parts.add(semestre!);
    return parts.join(' • ');
  }

  /// Info de afiliación completa
  String get affiliationInfo {
    final parts = <String>[];
    if (universidad != null && universidad!.isNotEmpty) parts.add(universidad!);
    if (facultad != null && facultad!.isNotEmpty) parts.add(facultad!);
    return parts.join(' - ');
  }

  /// Altura formateada (ej: "1,68 m")
  String? get alturaFormateada {
    if (altura == null) return null;
    final metros = altura! / 100;
    return '${metros.toStringAsFixed(2).replaceAll('.', ',')} m';
  }

  /// Crear desde JSON de Supabase
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      nombre: json['nombre'] ?? '',
      apellido: json['apellido'] ?? '',
      edad: json['edad'],
      telefono: json['telefono'],
      universidad: json['universidad'],
      facultad: json['facultad'],
      carrera: json['carrera'],
      semestre: json['semestre'],
      descripcion: json['descripcion'],
      intereses: json['intereses'] != null
          ? List<String>.from(json['intereses'])
          : [],
      photoUrls: json['photo_urls'] != null
          ? List<String>.from(json['photo_urls'])
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      altura: json['altura'],
      signoZodiacal: json['signo_zodiacal'],
      bebe: json['bebe'],
      fuma: json['fuma'],
      buscando: json['buscando'],
      genero: json['genero'],
    );
  }

  /// Convertir a JSON para Supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    };
  }
}
