import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String? subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ListTile(
        leading: Icon(
          icon,
          color: Theme.of(context).textTheme.bodySmall?.color,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        trailing: CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: Theme.of(context).colorScheme.secondary,
        ),
      ),
    );
  }
}
