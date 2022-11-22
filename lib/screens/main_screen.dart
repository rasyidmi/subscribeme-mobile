import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/extensions/string_extension.dart';

import 'package:subscribeme_mobile/commons/resources/icons.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/screens/screens.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 4);

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_selectedIndex != _tabController.animation!.value.round()) {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          appBar: _selectedIndex == 3 ? null : mainAppbar(),
          body: TabBarView(
            controller: _tabController,
            children: const [
              HomeScreen(),
              ListCoursesScreen(),
              Text(
                'Kelas Saya',
              ),
              ProfileScreen()
            ],
          ),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(
              color: ColorPalettes.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  offset: const Offset(0, -8),
                  blurRadius: 8,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                _buildTabBar('Beranda', SubsIcons.home, 0),
                _buildTabBar('Mata Kuliah', SubsIcons.course, 1),
                _buildTabBar('Kelas Saya', SubsIcons.classIcon, 2),
                _buildTabBar('Profil', SubsIcons.accountCircle, 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar mainAppbar() {
    return AppBar(
      title: SvgPicture.asset(
        SubsIcons.appBarLogo,
      ),
      actions: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is LoginSuccess) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: state.user.avatar!.isEmpty
                    ? Image.asset(SubsImages.ujang)
                    : CachedNetworkImage(
                        errorWidget: (context, _, __) =>
                            Image.asset(SubsImages.ujang),
                        imageUrl: state.user.avatar!,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 35.0,
                          height: 35.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.fill),
                          ),
                        ),
                      ),
              );
            } else {
              return Image.asset(SubsImages.ujang);
            }
          },
        ),
      ],
    );
  }

  bool _isSelected(int index) {
    return index == _selectedIndex;
  }

  Tab _buildTabBar(String label, String iconData, int index) {
    return Tab(
      height: 61.0,
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          SvgPicture.asset(
            iconData,
            color: _isSelected(index)
                ? ColorPalettes.primary
                : ColorPalettes.dark50,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyText2!.copyWith(
                  color: _isSelected(index)
                      ? ColorPalettes.primary
                      : ColorPalettes.dark50,
                  fontWeight:
                      _isSelected(index) ? FontWeight.bold : FontWeight.normal,
                ),
          ),
        ],
      ),
    );
  }
}
