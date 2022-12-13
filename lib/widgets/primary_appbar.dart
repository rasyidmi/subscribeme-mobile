import 'package:cached_network_image/cached_network_image.dart';
import "package:flutter/material.dart";
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subscribeme_mobile/blocs/auth/auth_bloc.dart';
import 'package:subscribeme_mobile/commons/resources/icons.dart';
import 'package:subscribeme_mobile/commons/resources/images.dart';

class PrimaryAppbar extends StatelessWidget implements PreferredSizeWidget {
  const PrimaryAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
  
  @override
  Size get preferredSize => AppBar().preferredSize;
}
