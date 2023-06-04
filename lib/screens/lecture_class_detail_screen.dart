import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/widgets/class_info_container.dart';
import 'package:subscribeme_mobile/widgets/subs_list_tile.dart';

class LectureClassDetailScreen extends StatelessWidget {
  const LectureClassDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 24),
          const CustomAppBar(
            title: "Kelas APAP - A",
            subTitle: "Aristektur Pemrograman dan Aplikasi Perusahaan",
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClassInfoContainer(
                      courseCode: "CSGE604099",
                      lectureName: [
                        {"name": "Hafiz Bhadrika Alamsyah S.Kom"}
                      ],
                      credit: 6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Divider(
                      height: 0,
                      thickness: 2,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Text(
                          "Daftar Absensi",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const Spacer(),
                        Text(
                          "+ Tambah Absen",
                          style:
                              Theme.of(context).textTheme.subtitle2!.copyWith(
                                    color: ColorPalettes.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: 10,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: SubsListTile(
                            title: "Kamis, 27 Desember 2023 - 10:00",
                            secondLine: "0/40 Mahasiswa",
                            secondLineStyle:
                                Theme.of(context).textTheme.subtitle2,
                            thirdLine: "oleh Hafiz Bhadrika Alamsyah S.Kom",
                            thirdLineStyle: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: ColorPalettes.gray),
                            onTap: () {},
                            isActive: true,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget {
  final String title;
  final String? subTitle;
  const CustomAppBar({
    Key? key,
    required this.title,
    this.subTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 16.0),
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              border: Border.all(color: ColorPalettes.whiteGray),
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              iconSize: 16.0,
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_outlined),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .headline6!
                      .copyWith(color: ColorPalettes.primary),
                ),
                if (subTitle != null) Text(subTitle!)
              ],
            ),
          )
        ],
      ),
    );
  }
}
