import 'package:flutter/material.dart';
import 'package:subscribeme_mobile/widgets/shimmer/rect_shimmer.dart';

class ListShimmer extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  const ListShimmer({Key? key, this.itemCount = 8, this.itemHeight = 24.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: itemCount,
      itemBuilder: ((context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: RectangleShimmer(height: itemHeight, width: double.infinity),
          )),
    );
  }
}
