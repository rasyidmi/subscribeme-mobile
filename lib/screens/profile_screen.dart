import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/constants/role.dart';
import 'package:subscribeme_mobile/commons/resources/icons.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/resources/locale_keys.g.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is LogoutSuccess) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(Routes.login, (route) => false);
      }
    }, builder: (context, state) {
      if (state is LoginSuccess) {
        return Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            left: 16.0,
            bottom: 12.0,
          ),
          child: Column(
            children: [
              const Spacer(flex: 1),
              SvgPicture.asset(SubsIcons.appBarLogo),
              const Spacer(flex: 1),
              if (state.user.avatar!.isEmpty) Image.asset(SubsImages.studentLarge),
              if (state.user.avatar!.isNotEmpty)
                CachedNetworkImage(
                  errorWidget: (context, _, __) =>
                      Image.asset(SubsImages.ujang),
                  imageUrl: state.user.avatar!,
                  imageBuilder: (context, imageProvider) => UnconstrainedBox(
                    child: Container(
                      width: 120.0,
                      height: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24.0),
              Text(state.user.name,
                  style: Theme.of(context).textTheme.subtitle1),
              const SizedBox(height: 8.0),
              Text(state.user.email),
              const SizedBox(height: 32.0),
              ProfileListTile(text: LocaleKeys.profile_screen_my_profile.tr()),
              if (state.user.role == Role.admin)
                ProfileListTile(
                    text: LocaleKeys.profile_screen_admin.tr(),
                    onTap: () {
                      Navigator.pushNamed(context, Routes.adminViewCourses);
                    }),
              ListTile(
                dense: true,
                leading: Text(
                  LocaleKeys.settings_screen_language.tr(),
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontWeight: FontWeight.normal),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: ColorPalettes.dark70,
                  size: 16.0,
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.setting);
                },
              ),
              const Spacer(flex: 4),
              SubsRoundedButton(
                onTap: () {
                  context.read<AuthBloc>().add(Logout());
                },
                buttonText: LocaleKeys.logout.tr(),
                buttonStyle: Theme.of(context).textButtonTheme.style!.copyWith(
                    backgroundColor: MaterialStateProperty.all(Colors.red)),
              ),
            ],
          ),
        );
      } else {
        return Container();
      }
    });
  }
}

class ProfileListTile extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  const ProfileListTile({
    Key? key,
    required this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .subtitle1!
            .copyWith(fontWeight: FontWeight.normal),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: ColorPalettes.dark70,
        size: 16.0,
      ),
      onTap: onTap,
    );
  }
}
