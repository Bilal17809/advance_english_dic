import 'package:flutter/material.dart';

class NoResultsMessage extends StatelessWidget {
  final String searchText;
  const NoResultsMessage({
    super.key,
    required this.searchText,
  });
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sentiment_dissatisfied_rounded,
                size: 60,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                "No results found for \"${searchText}\".",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Please check your spelling or try another word.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}