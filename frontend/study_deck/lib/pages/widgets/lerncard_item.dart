import 'dart:math';
import 'package:flutter/material.dart';
import 'package:study_deck/models/deckcard.dart';

class LerncardItem extends StatelessWidget {
  final DeckCard card;
  final bool isFlipped;
  final VoidCallback onTap;

  const LerncardItem({
    super.key,
    required this.card,
    required this.isFlipped,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textColor = Theme.of(context).textTheme.bodySmall?.color;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          final rotateAnim = Tween(begin: pi, end: 0.0).animate(animation);
          return AnimatedBuilder(
            animation: rotateAnim,
            child: child,
            builder: (context, child) {
              final isUnder = (ValueKey(isFlipped) != child?.key);
              var tilt = ((animation.value - 0.5).abs() - 0.5) * 0.003;
              tilt *= isUnder ? -1.0 : 1.0;
              final value = isUnder
                  ? min(rotateAnim.value, pi / 2)
                  : rotateAnim.value;
              return Transform(
                transform: Matrix4.rotationY(value)..setEntry(3, 0, tilt),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: isFlipped
            ? Container(
                key: ValueKey(true),
                decoration: BoxDecoration(
                  color: colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: colorScheme.secondary, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Antwort",
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.secondary,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      card.back,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                key: ValueKey(false),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Frage",
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor?.withValues(alpha: 0.2),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      card.front,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
