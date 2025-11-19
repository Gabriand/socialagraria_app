import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/views/screens/simple_text.dart';
import 'package:social_agraria/widgets/background_card.dart';
import 'package:social_agraria/widgets/horizontal_separator.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool _appSoundsEnabled = true;
  bool _appMatchesEnabled = true;
  String _selectedLanguage = 'Español';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ajustes',
          style: TextStyle(
            color: AppColors.primaryDarker,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
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
                            'Sonidos de la App',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: AppColors.primaryDarker,
                            ),
                          ),
                          Switch(
                            activeTrackColor: AppColors.primary,
                            value: _appSoundsEnabled,
                            onChanged: (bool newValue) {
                              setState(() {
                                _appSoundsEnabled = newValue;
                              });
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
                            'Idioma',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: AppColors.primaryDarker,
                            ),
                          ),
                          DropdownButton<String>(
                            value: _selectedLanguage,
                            underline: const SizedBox(),
                            dropdownColor: AppColors.white,
                            borderRadius: BorderRadius.circular(12.0),
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
                                setState(() => _selectedLanguage = value);
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
                        value: _appMatchesEnabled,
                        onChanged: (bool newValue) {
                          setState(() {
                            _appMatchesEnabled = newValue;
                          });
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
                height: 114.0,
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
                          Text(
                            'Número de Teléfono',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: AppColors.primaryDarker,
                            ),
                          ),
                          Text(
                            '0987654321',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: AppColors.primaryDarker.withAlpha(160),
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
                          Text(
                            'Universidad',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: AppColors.primaryDarker,
                            ),
                          ),
                          Text(
                            'Universidad Agraria',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: AppColors.primaryDarker.withAlpha(160),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              CardWidget(
                margin: const EdgeInsets.only(top: 0.0, bottom: 0.0),
                height: 60.0,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        // Acción para cerrar sesión
                      });
                    },
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
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        // Acción para eliminar la cuenta
                      });
                    },
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
                                MaterialPageRoute(
                                  builder: (_) => const SimpleText(
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
                                MaterialPageRoute(
                                  builder: (_) => const SimpleText(
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
  }
}
