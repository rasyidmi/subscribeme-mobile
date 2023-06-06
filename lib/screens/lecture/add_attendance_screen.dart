import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/commons/styles/color_palettes.dart';
import 'package:subscribeme_mobile/widgets/bottom_button_container.dart';
import 'package:subscribeme_mobile/widgets/secondary_appbar.dart';
import 'package:subscribeme_mobile/widgets/subs_rounded_button.dart';
import 'package:subscribeme_mobile/widgets/subs_text_field.dart';

class AddAttendanceScreen extends StatefulWidget {
  const AddAttendanceScreen({Key? key}) : super(key: key);

  @override
  State<AddAttendanceScreen> createState() => _AddAttendanceScreenState();
}

class _AddAttendanceScreenState extends State<AddAttendanceScreen> {
  bool isGeo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const SecondaryAppbar(
        title: "Absensi Mahasiswa",
        subTitle: "Ubah/Tambah Informasi",
      ),
      bottomSheet: BottomContainer(
        child: SubsRoundedButton(
          buttonText: "Simpan Mata Kuliah Terpilih",
          onTap: () {},
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            Text(
              "Waktu Buka Absensi",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: ColorPalettes.whiteGray),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Text(
                    "Pilih waktu buka absensi",
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(color: ColorPalettes.gray),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.date_range,
                    color: ColorPalettes.primary,
                  )
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Durasi Absensi (Menit)",
              style: Theme.of(context)
                  .textTheme
                  .subtitle2!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const SubsTextField(
              hintText: "Tentukan durasi absensi dalam menit",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 32),
            const Divider(
              height: 0,
              thickness: 1,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Aktifkan Lokasi Mahasiswa",
                  style: Theme.of(context)
                      .textTheme
                      .subtitle2!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                CupertinoSwitch(
                  value: isGeo,
                  activeColor: ColorPalettes.primary,
                  onChanged: (bool value) {
                    setState(() {
                      isGeo = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            isGeo
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Radius Lokasi (Meter)",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  )
                : const SizedBox(),
            const SizedBox(height: 12),
            isGeo
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SubsTextField(
                      hintText: "Tentukan radius lokasi dalam meter",
                      keyboardType: TextInputType.number,
                    ),
                  )
                : const SizedBox(),
            // const Spacer(),
            // BottomContainer(
            //   child: SubsRoundedButton(
            //     buttonText: "Simpan Absensi",
            //     onTap: () {
            //       // _subscribeCourse(context);
            //     },
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
