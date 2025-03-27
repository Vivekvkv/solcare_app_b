import 'package:flutter/material.dart';

class AppVersionInfo extends StatelessWidget {
  final String version;

  const AppVersionInfo({
    Key? key,
    required this.version,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: Text(
          'Version $version',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
