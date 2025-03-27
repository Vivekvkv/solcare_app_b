import 'package:flutter/material.dart';

class SwitchMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final bool value;
  final Function(bool) onChanged;

  const SwitchMenuTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Theme.of(context).colorScheme.primary,
      ),
      onTap: () => onChanged(!value),
    );
  }
}
