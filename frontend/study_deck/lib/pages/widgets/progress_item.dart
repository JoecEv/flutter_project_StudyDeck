import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProgressViewItem extends StatelessWidget {
  final int correctCount;
  final int totalCards;

  const ProgressViewItem({
    super.key,
    required this.correctCount,
    required this.totalCards,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black;
    final progress = totalCards == 0 ? 0.0 : correctCount / totalCards;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events,
            size: 80,
            color: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(height: 24),
          Text(
            "Geschafft!",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          SizedBox(height: 16),
          Text(
            "Du wusstest $correctCount von $totalCards Karten.",
            style: TextStyle(
              fontSize: 18,
              color: textColor.withValues(alpha: 0.8),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Fortschritt: ${(progress * 100).toStringAsFixed(0)}%",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              context.go('/home');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: Size(250, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Zurück zur Übersicht",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
