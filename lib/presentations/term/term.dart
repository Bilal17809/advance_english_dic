import 'package:flutter/material.dart';

class TermScreen extends StatelessWidget {
  const TermScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 55, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Text(
                    'Terms of Use',
                    style: TextStyle(
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                Positioned(
                  right: -10,
                  child: IconButton(
                    icon: Icon(
                      Icons.cancel,
                      size: 37,
                      color: textColor,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Advance AI Dictionary is designed to enhance your English skills with smart tools powered by AI.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, color: textColor),
              ),
            ),
            const SizedBox(height: 17),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                featureRow(context, 'Dictionary'),
                const SizedBox(height: 7),
                featureRow(context, 'Conversations'),
                const SizedBox(height: 7),
                featureRow(context, 'Words'),
                const SizedBox(height: 7),
                featureRow(context, 'Speak & Text'),
                const SizedBox(height: 7),
                featureRow(context, 'Quiz'),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Lifetime Subscription:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enjoy a one-time purchase that unlocks all premium features of Advance AI Dictionary for life. '
                  'This includes an ad-free experience and full access to all tools and updates without any recurring charges.',
              style: TextStyle(fontSize: 16, color: textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget featureRow(BuildContext context, String text) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
            ),
            child: const Padding(
              padding: EdgeInsets.all(4.0),
              child: Icon(Icons.done_outline_sharp, color: Colors.green),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 17,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

