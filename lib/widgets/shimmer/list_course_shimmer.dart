import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/widgets/shimmer/box_shimmer.dart';
import 'package:subscribeme_mobile/widgets/shimmer/rect_shimmer.dart';

class ListCourseShimmer extends StatelessWidget {
  const ListCourseShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ..._buildList(),
        ..._buildList(),
        ..._buildList(),
        ..._buildList(),
        ..._buildList(),
        ..._buildList(),
        ..._buildList(),
        ..._buildList(),
      ],
    );
  }

  List<Widget> _buildList() {
    return const [
      SizedBox(height: 16.0),
      UnconstrainedBox(
        alignment: Alignment.centerLeft,
        child: BoxShimmer(size: 24),
      ),
      SizedBox(height: 16.0),
      RectangleShimmer(
        height: 30,
        width: double.infinity,
      ),
    ];
  }
}
