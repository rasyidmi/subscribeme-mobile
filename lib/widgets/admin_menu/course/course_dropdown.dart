import 'package:flutter/material.dart';

class AddCourseDropdown extends StatelessWidget {
  final Object? value;
  final List<String> dropdownItem;
  final Function(Object?) onChanged;

  const AddCourseDropdown({
    Key? key,
    this.value,
    required this.dropdownItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
    // return DropdownButtonHideUnderline(
    //   child: DropdownButton2(
    //     iconOnClick: const FaIcon(FontAwesomeIcons.angleUp),
    //     isExpanded: true,
    //     hint: Text(
    //       '- ${LocaleKeys.choose_major.tr()} -',
    //       style: Theme.of(context).textTheme.bodyText2,
    //     ),
    //     items: dropdownItem
    //         .map((item) => DropdownMenuItem<String>(
    //               value: item,
    //               child: Text(
    //                 item,
    //                 style: Theme.of(context).textTheme.bodyText2,
    //                 overflow: TextOverflow.ellipsis,
    //               ),
    //             ))
    //         .toList(),
    //     value: value,
    //     onChanged: onChanged,
    //     icon: const FaIcon(FontAwesomeIcons.angleDown),
    //     iconSize: 14,
    //     iconEnabledColor: ColorPalettes.dark70,
    //     buttonHeight: 50,
    //     buttonWidth: getScreenSize(context).width,
    //     buttonPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    //     buttonDecoration: BoxDecoration(
    //       borderRadius: BorderRadius.circular(8),
    //       border: Border.all(color: ColorPalettes.whiteGray),
    //     ),
    //     itemHeight: 35,
    //     itemPadding: const EdgeInsets.symmetric(horizontal: 16.0),
    //     dropdownMaxHeight: 200,
    //     dropdownWidth: getScreenSize(context).width - 32,
    //     dropdownDecoration:
    //         BoxDecoration(borderRadius: BorderRadius.circular(8)),
    //     dropdownElevation: 4,
    //   ),
    // );
  }
}
