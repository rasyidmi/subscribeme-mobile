import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16.0),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: ColorPalettes.primary,
                    child: Center(
                      child: Text(
                        '3',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deadline Hari Ini',
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: ColorPalettes.primary),
                      ),
                      Text(
                        '23 April 2022',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              SubsListTile(
                title: 'Tugas Kelompok 1',
                secondLine: 'E Commerce - A',
                thirdLine: 'Hari Ini - 21.00',
                isActive: true,
                onTap: () {},
              ),
              const SizedBox(height: 16.0),
              const SubsListTile(
                title: 'Tugas Individu 1',
                secondLine: 'APAP - C',
                thirdLine: 'Hari Ini - 23.55',
                actionButtons: [
                  Icon(Icons.check_box, color: ColorPalettes.lightRed)
                ],
              ),
              const SizedBox(height: 16.0),
              SubsListTile(
                title: 'Tugas Kelompok 1',
                secondLine: 'E Commerce - A',
                thirdLine: 'Hari Ini - 21.00',
                isActive: true,
                onTap: () {},
              ),
              const SizedBox(height: 16.0),
              Text(
                'Deadline 7 Hari ke Depan!',
                style: Theme.of(context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: ColorPalettes.primary),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
