import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/owner/pages/owner_home_tab.dart';
import 'package:glowguide/features/owner/pages/owner_my_clinics_tab.dart';
import 'package:glowguide/features/profile/presentation/pages/my_profile_tab.dart';

class OwnerTabsLayout extends StatefulWidget {
  const OwnerTabsLayout({super.key});

  @override
  State<OwnerTabsLayout> createState() => _OwnerTabsLayoutState();
}

class _OwnerTabsLayoutState extends State<OwnerTabsLayout> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = const [
    OwnerHomeTab(),
    OwnerMyClinicsTab(),
    MyProfileTab(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF7CAC8E),
        unselectedItemColor: const Color(0xFF78808B),
        iconSize: 25.w,
        showUnselectedLabels: true,
        selectedLabelStyle: AppTextStyles.footerSemiBold,
        items: [
          BottomNavigationBarItem(
            icon: Icon(_selectedIndex == 0 ? Icons.home : Icons.home_outlined),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 1 ? Icons.store : Icons.store_outlined,
            ),
            label: "My Clinics",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.person : Icons.person_outline,
            ),
            label: "My Profile",
          ),
        ],
      ),
    );
  }
}
