import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final VoidCallback? onSearchPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final double titleFontSize;
  
  const AppHeader({
    super.key,
    required this.title,
    this.actions,
    this.onSearchPressed,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.titleFontSize = 24,
  });
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Theme.of(context).colorScheme.primary,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            // App logo
            Text(
              'Solcare',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const Spacer(),
            // Search button
            IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onSearchPressed,
            ),
            // Notifications button
            IconButton(
              icon: Icon(
                Icons.notifications_none_rounded,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: onNotificationPressed,
            ),
            // User profile avatar
            GestureDetector(
              onTap: onProfilePressed,
              child: const CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage('assets/images/placeholder.jpg'),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          child: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize,
            ),
          ),
        ),
      ),
      actions: actions,
    );
  }
  
  @override
  Size get preferredSize => const Size.fromHeight(104); // 64 for AppBar + 40 for bottom widget
}
