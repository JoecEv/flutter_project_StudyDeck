import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_deck/provider/theme_provider.dart';
import 'package:study_deck/theme/app_theme.dart';

class DeckViewCard extends StatelessWidget {
  final String title;
  final double progress;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const DeckViewCard({
    super.key,
    required this.title,
    required this.progress,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeMode = context.watch<ThemeProvider>().themeMode;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 18, 8, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_outline_rounded,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                        size: 22,
                      ),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ),
              Container(
                height: 5,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress.clamp(0, 1),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppTheme.getAppBarGradient(themeMode),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
