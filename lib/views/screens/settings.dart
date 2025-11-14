import 'package:flutter/material.dart';
import 'package:tinder_agro/core/app_colors.dart';
import 'package:tinder_agro/widgets/background_card.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
      body: Padding(
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
              height: 200.0,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Sonidos de la App',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      Switch(
                        value: false,
                        onChanged: (bool newValue) {
                          setState(() {
                            newValue = true;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Idioma', style: TextStyle(fontSize: 18.0)),
                      DropdownMenu(
                        label: Text('Español'),
                        textAlign: TextAlign.center,
                        dropdownMenuEntries: <DropdownMenuEntry<String>>[
                          DropdownMenuEntry(value: 'Español', label: 'Español'),
                          DropdownMenuEntry(value: 'Ingles', label: 'Ingles'),
                        ],
                      ),
                    ],
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
            Text(
              'Cuenta',
              style: TextStyle(
                color: AppColors.primaryDarker,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
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
          ],
        ),
      ),
    );
  }
}
