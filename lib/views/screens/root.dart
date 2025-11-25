import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/views/screens/profile.dart';
import 'package:social_agraria/views/screens/explorer.dart';
import 'package:social_agraria/views/screens/user_match.dart';
import 'package:social_agraria/views/screens/settings.dart';

class Root extends StatefulWidget {
  final int initialIndex;

  const Root({super.key, this.initialIndex = 0});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  late int selectedIndex;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
    pages = [Explorer(), UserMatch(), Profile(), Settings()];
  }

  void _onitemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: pages[selectedIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
        ),
        child: NavigationBar(
          backgroundColor: AppColors.white,
          selectedIndex: selectedIndex,
          onDestinationSelected: _onitemTapped,
          elevation: 0,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
            Set<WidgetState> states,
          ) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              );
            }
            return const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.accent,
            );
          }),
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.explore_outlined, color: AppColors.accent),
              selectedIcon: Icon(
                Icons.explore,
                color: AppColors.primary,
                size: 28.0,
              ),
              label: 'Explorar',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border, color: AppColors.accent),
              selectedIcon: Icon(
                Icons.favorite,
                color: AppColors.primary,
                size: 28.0,
              ),
              label: 'Matches',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: AppColors.accent),
              selectedIcon: Icon(
                Icons.person,
                color: AppColors.primary,
                size: 28.0,
              ),
              label: 'Perfil',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: AppColors.accent),
              selectedIcon: Icon(
                Icons.settings,
                color: AppColors.primary,
                size: 28.0,
              ),
              label: 'Ajustes',
            ),
          ],
        ),
      ),
    );
  }
}
