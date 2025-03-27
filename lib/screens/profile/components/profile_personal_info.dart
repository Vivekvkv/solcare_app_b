import 'package:flutter/material.dart';
import 'package:solcare_app4/models/profile_model.dart';
import 'info_item.dart';

class ProfilePersonalInfo extends StatelessWidget {
  final ProfileModel profile;

  const ProfilePersonalInfo({
    super.key,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Personal Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        InfoItem(
          icon: Icons.phone,
          label: 'Phone',
          value: profile.phone,
        ),
        InfoItem(
          icon: Icons.home,
          label: 'Address',
          value: profile.address,
        ),
      ],
    );
  }
}
