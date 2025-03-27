import 'package:flutter/material.dart';

class ServiceAppBar extends StatelessWidget {
  final String imageUrl;

  const ServiceAppBar({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: imageUrl.startsWith('http')
            ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
              )
            : Image.asset(
                imageUrl,
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
