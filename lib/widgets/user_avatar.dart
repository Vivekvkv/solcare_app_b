import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final double radius;
  final Color? backgroundColor;
  final Color? textColor;

  const UserAvatar({
    Key? key,
    this.imageUrl,
    required this.name,
    this.radius = 20,
    this.backgroundColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor = Theme.of(context).primaryColor;
    
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: CachedNetworkImageProvider(imageUrl!),
      );
    }
    
    // Generate avatar from initials
    final initials = name.isNotEmpty ? name[0].toUpperCase() : '?';
    
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor ?? defaultBackgroundColor,
      child: Text(
        initials,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: radius * 0.7,
        ),
      ),
    );
  }
}
