import 'package:flutter/material.dart';
import 'package:social_agraria/core/app_colors.dart';
import 'package:social_agraria/views/screens/explorer.dart';
import 'package:social_agraria/views/screens/settings.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  int selectedIndex = 0;

  late final List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pages = [Explorer(), Settings()];
  }

  void _onitemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
