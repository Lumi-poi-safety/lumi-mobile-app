import 'package:flutter/material.dart';
import 'package:lumi/features/in_app/explore/explore_screen/home_search_screen.dart';
import 'package:lumi/features/in_app/main_nav_bar/lumi_bottom_nav.dart';
import 'package:lumi/features/in_app/profile/profile_screen/profile_screen.dart';
import 'package:lumi/features/in_app/saved_poi/saved_poi_screen/saved_poi_screen.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  int _index = 0;

  final _pages = const [HomeSearchScreen(), SavedScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: LumiBottomNav(
        index: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [Icons.home_outlined, Icons.bookmark_border, Icons.person_outline],
      ),
    );
  }
}
