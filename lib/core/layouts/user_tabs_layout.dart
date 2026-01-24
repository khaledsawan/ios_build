import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/profile/presentation/pages/my_profile_tab.dart';
import 'package:glowguide/features/user/presentation/pages/user_favorites_tab.dart';
import 'package:glowguide/features/user/presentation/pages/user_home_tab.dart';
import 'package:glowguide/features/user/presentation/pages/user_offers_tab.dart';

class UserTabsLayout extends StatefulWidget {
  const UserTabsLayout({super.key});

  @override
  State<UserTabsLayout> createState() => _UserTabsLayoutState();
}

class _UserTabsLayoutState extends State<UserTabsLayout> {
  int _selectedIndex = 0;

  late final List<Widget> _screens = const [
    UserHomeTab(),
    UserOffersTab(),
    UserFavoritesTab(),
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
      body: IndexedStack(index: _selectedIndex, children: _screens),
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
              _selectedIndex == 1 ? Icons.discount : Icons.discount_outlined,
            ),
            label: "Offers",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 2 ? Icons.favorite : Icons.favorite_outline,
            ),
            label: "Favorites",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              _selectedIndex == 3 ? Icons.person : Icons.person_outline,
            ),
            label: "My Profile",
          ),
        ],
      ),
    );
  }
}
