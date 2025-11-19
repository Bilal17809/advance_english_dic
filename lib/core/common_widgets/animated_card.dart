import 'package:electricity_app/extension/extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../animation/animation_games.dart';
import '../theme/app_styles.dart';


class AnimatedForwardCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AnimatedForwardCard({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: roundedDecoration,
      margin: const EdgeInsets.all(8),
      child: Stack(
        children: [
          ListTile(
            title: Text(title,style: context.textTheme.labelMedium,),
            onTap:onTap,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical:8),
          ),
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: AnimatedForwardArrow2(),
            ),
          ),
        ],
      ),
    );
  }
}



