/// Modelo para almacenar los datos de registro del usuario
/// Se pasa entre pantallas durante el proceso de registro
class RegistrationData {
  String email;
  String password;
  String nombre;
  String apellido;
  int? edad;
  String? telefono;
  String? universidad;
  String? facultad;
  String? descripcion;
  List<String> intereses;
  List<String> photoUrls;

  // Campos adicionales de detalles personales
  int? altura; // en cm
  String? signoZodiacal;
  String? bebe;
  String? fuma;
  String? buscando;
  String? genero;

  RegistrationData({
    this.email = '',
    this.password = '',
    this.nombre = '',
    this.apellido = '',
    this.edad,
    this.telefono,
    this.universidad,
    this.facultad,
    this.descripcion,
    this.intereses = const [],
    this.photoUrls = const [],
    this.altura,
    this.signoZodiacal,
    this.bebe,
    this.fuma,
    this.buscando,
    this.genero,
  });

  /// Verifica si los datos básicos están completos
  bool get hasBasicInfo =>
      nombre.isNotEmpty &&
      apellido.isNotEmpty &&
      edad != null &&
      telefono != null &&
      telefono!.isNotEmpty;

  /// Verifica si tiene datos de afiliación
  bool get hasAffiliationInfo =>
      universidad != null &&
      universidad!.isNotEmpty &&
      facultad != null &&
      facultad!.isNotEmpty;
}
