import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/constants/role.dart';
import 'package:subscribeme_mobile/commons/constants/sizes.dart';
import 'package:subscribeme_mobile/commons/resources/icons.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/routes.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(Routes.login, (route) => false);
        }
      },
      buildWhen: (previous, current) => current is LoginSuccess,
      builder: (context, state) {
        if (state is LoginSuccess) {
          return Padding(
            padding: const EdgeInsets.only(
              right: 16.0,
              left: 16.0,
              bottom: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 17),
                Center(child: SvgPicture.asset(SubsIcons.appBarLogo)),
                const Spacer(flex: 1),
                Center(
                  child: Image.asset(
                    SubsImages.studentLarge,
                    height: getScreenSize(context).height / 5,
                  ),
                ),
                const SizedBox(height: 24.0),
                const Text("Nama Lengkap"),
                const SizedBox(height: 6.0),
                Text(
                  state.user.name,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 16),
                ),
                const SizedBox(height: 22.0),
                Text(state.user.role == Role.lecturer ? "NIM" : "NPM"),
                const SizedBox(height: 6.0),
                Text(
                  state.user.npm,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 16),
                ),
                const SizedBox(height: 22.0),
                const Text("Email"),
                const SizedBox(height: 6.0),
                Text(
                  '${state.user.username}@ui.ac.id',
                  style: Theme.of(context)
                      .textTheme
                      .subtitle1!
                      .copyWith(fontSize: 16),
                ),
                const SizedBox(height: 34.0),
                SubsRoundedButton(
                  onTap: () async {
                    context.read<AuthBloc>().add(Logout());
                  },
                  textStyle: Theme.of(context)
                      .textTheme
                      .button!
                      .copyWith(color: ColorPalettes.alertButtonText),
                  buttonText: "Keluar",
                  buttonStyle: Theme.of(context)
                      .textButtonTheme
                      .style!
                      .copyWith(
                          backgroundColor: MaterialStateProperty.all(
                              ColorPalettes.alertButton)),
                ),
                const Spacer(flex: 4),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
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
