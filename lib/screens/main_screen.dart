import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:subscribeme_mobile/blocs/locale/locale_bloc.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/screens/screens.dart';
import 'package:subscribeme_mobile/widgets/primary_appbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
          appBar: _selectedPage == 3 ? null : const PrimaryAppbar(),
          body: PageView(
            controller: _pageViewController,
            children: [
              const HomeScreen(),
              const ListCoursesScreen(),
              MyClassScreen(
                pageController: _pageViewController,
              ),
              const ProfileScreen()
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
            child: BlocListener<LocaleBloc, LocaleState>(
              listener: (context, state) {
                if (state is NewLocaleSet) {
                  setState(() {});
                }
              },
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
                selectedLabelStyle:
                    const TextStyle(color: ColorPalettes.primary),
                selectedFontSize: 12,
                unselectedItemColor: ColorPalettes.dark70,
                unselectedLabelStyle:
                    const TextStyle(color: ColorPalettes.dark70),
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.home),
                      label: LocaleKeys.home.tr()),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.dns),
                      label: LocaleKeys.course.tr()),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.book),
                      label: LocaleKeys.attendance.tr()),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.account_circle),
                      label: LocaleKeys.profile.tr()),
                ],
              ),
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
