import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_styles.dart';

class BackIconButton extends StatelessWidget {
  const BackIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        height: 32,
        width: 32,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: kWhite,
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_circle_left_outlined,
            color: kBlue,
            size: 22,
          ),
        ),
      ),
    );
  }
}


class CardIcon extends StatelessWidget {
  final String icon;
  const CardIcon({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: roundedDecoration,
      padding: const EdgeInsets.all(8),
      child: Center(
        child: Image.asset(
          icon,
          height: 40,
          width: 40,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

class MenuIcon extends StatelessWidget {
  const MenuIcon({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.menu,color: Colors.white,size: 30,);
  }
}
