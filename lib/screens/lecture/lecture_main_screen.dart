import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/screens/screens.dart';
import 'package:subscribeme_mobile/widgets/primary_appbar.dart';

class LectureMainScreen extends StatefulWidget {
  const LectureMainScreen({Key? key}) : super(key: key);

  @override
  State<LectureMainScreen> createState() => _LectureMainScreenState();
}

class _LectureMainScreenState extends State<LectureMainScreen> {
  final PageController _pageViewController = PageController(initialPage: 0);
  int _selectedPage = 0;

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: _selectedPage == 1 ? null : const PrimaryAppbar(),
          body: PageView(
            controller: _pageViewController,
            children: const [
              LectureClassScreen(),
              ProfileScreen(),
            ],
            onPageChanged: (index) {
              setState(() {
                _selectedPage = index;
              });
            },
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  offset: const Offset(0, -3),
                  blurRadius: 3,
                ),
              ],
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.white,
              currentIndex: _selectedPage,
              onTap: (index) {
                _pageViewController.jumpToPage(index);
              },
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              showUnselectedLabels: true,
              selectedItemColor: ColorPalettes.primary,
              selectedLabelStyle: const TextStyle(color: ColorPalettes.primary),
              selectedFontSize: 12,
              unselectedItemColor: ColorPalettes.dark70,
              unselectedLabelStyle:
                  const TextStyle(color: ColorPalettes.dark70),
              items: const [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: "Beranda"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_circle), label: "Profil"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget mainAppbar() {
    return const PrimaryAppbar();
  }
}
