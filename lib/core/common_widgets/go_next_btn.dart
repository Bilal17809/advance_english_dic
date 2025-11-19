import 'package:flutter/cupertino.dart';

class SettingItem extends StatelessWidget {
  final String title;
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final Function()? onTap;
  final String? value;

  const SettingItem({
    super.key,
    required this.title,
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    this.onTap, // Nullable
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // padding: const EdgeInsets.symmetric(vertical:2),
        // decoration: BoxDecoration(
        //   color: AppColors.kNotSet2Color,
        //   borderRadius: BorderRadius.circular(35),
        // ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Centered Title Text
            // Expanded(
            //   child: Center(
            //     child: Text(
            //       title,
            //       style: const TextStyle(
            //         fontSize: 17,
            //         fontWeight: FontWeight.w500,
            //         color: Colors.white,
            //       ),
            //       textAlign: TextAlign.center,
            //     ),
            //   ),
            // ),
            // Circular Icon
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                // shape: BoxShape.circle,
                borderRadius: BorderRadius.circular(30),
                color: bgColor,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 45, // Adjusted size
              ),
            ),
          ],
        ),
      ),
    );
  }
}