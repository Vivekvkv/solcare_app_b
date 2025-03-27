import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/models/profile_model.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'dart:io';

class UserInfoCard extends StatelessWidget {
  final ProfileModel profile;

  const UserInfoCard({
    Key? key,
    required this.profile,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User avatar with edit option
            GestureDetector(
              onTap: () => _showImagePickerOptions(context),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      image: profile.profileImage != null && profile.profileImage!.isNotEmpty
                          ? DecorationImage(
                              image: NetworkImage(profile.profileImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: profile.profileImage == null || profile.profileImage!.isEmpty
                        ? Icon(
                            Icons.person,
                            size: 60,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : null,
                  ),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // User name
            Text(
              profile.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Mobile number with edit option
            _buildEditableField(
              context: context,
              icon: Icons.phone,
              label: 'Mobile Number',
              value: profile.phone,
              onEdit: () => _showEditMobileDialog(context),
            ),
            
            const SizedBox(height: 16),
            
            // Email with edit option
            _buildEditableField(
              context: context,
              icon: Icons.email,
              label: 'Email Address',
              value: profile.email,
              onEdit: () => _showEditEmailDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.edit, size: 18),
          onPressed: onEdit,
        ),
      ],
    );
  }

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);
      
      if (image != null) {
        // In a real app, you would upload this image to storage
        // For now, we'll just show a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showEditMobileDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: profile.phone);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Mobile Number'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: 'Enter your mobile number',
              prefixIcon: Icon(Icons.phone),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  Provider.of<ProfileProvider>(context, listen: false)
                      .updatePhone(controller.text.trim());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mobile number updated')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Mobile number cannot be empty')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showEditEmailDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: profile.email);
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Email Address'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email address',
              prefixIcon: Icon(Icons.email),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Email can be optional, so we don't check if it's empty
                Provider.of<ProfileProvider>(context, listen: false)
                    .updateEmail(controller.text.trim());
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Email address updated')),
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
