import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/models/services/supabase.dart';
import 'package:social_agraria/controllers/user_controller.dart';
import 'package:social_agraria/core/utils/push_notification_service.dart';
import 'package:social_agraria/views/screens/welcome.dart';
import 'package:social_agraria/views/screens/root.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseService.initialize();

  await PushNotificationService().initialize();

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserController()..initialize(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social Agro',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
        appBarTheme: AppBarTheme(elevation: 0),
      ),
      home: SupabaseService.isAuthenticated ? const Root() : const Welcome(),
    );
  }
}
