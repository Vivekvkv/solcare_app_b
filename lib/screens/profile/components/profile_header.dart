import 'package:flutter/material.dart';
import 'package:solcare_app4/models/profile_model.dart';

class ProfileHeader extends StatelessWidget {
  final ProfileModel profile;
  final bool isEditing;
  final VoidCallback onPickImage;

  const ProfileHeader({
    super.key,
    required this.profile,
    required this.isEditing,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          GestureDetector(
            onTap: isEditing ? onPickImage : null,
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: profile.profileImage != null
                      ? AssetImage(profile.profileImage!)
                      : null,
                  child: profile.profileImage == null
                      ? Text(
                          profile.name.isNotEmpty ? profile.name[0] : '?',
                          style: const TextStyle(fontSize: 40),
                        )
                      : null,
                ),
                if (isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (!isEditing)
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          if (!isEditing) const SizedBox(height: 4),
          if (!isEditing)
            Text(
              profile.email,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
        ],
      ),
    );
  }
}
