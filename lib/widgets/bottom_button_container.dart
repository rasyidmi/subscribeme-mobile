import 'package:flutter/material.dart';

class BottomContainer extends StatelessWidget {
  final Widget child;
  const BottomContainer({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, -1),
              blurRadius: 24,
              spreadRadius: 0.5,
              color: Colors.black.withOpacity(0.15),
            ),
          ]),
      padding: EdgeInsets.only(
        bottom: bottomPadding,
        top: 16,
        right: 24,
        left: 24,
      ),
      child: child,
    );
  }
}