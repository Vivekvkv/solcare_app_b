import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/models/profile_model.dart';
import 'package:solcare_app4/screens/profile/components/index.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileProvider>(context, listen: false).profile;
    _nameController = TextEditingController(text: profile.name);
    _emailController = TextEditingController(text: profile.email);
    _phoneController = TextEditingController(text: profile.phone);
    _addressController = TextEditingController(text: profile.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      Provider.of<ProfileProvider>(context, listen: false)
          .updateProfileImage(image.path);
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      final currentProfile = Provider.of<ProfileProvider>(context, listen: false).profile;
      Provider.of<ProfileProvider>(context, listen: false).updateProfile(
        ProfileModel(
          id: currentProfile.id, // Added the required id parameter
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          profileImage: currentProfile.profileImage,
          rewardPoints: currentProfile.rewardPoints,
          savedLocations: currentProfile.savedLocations,
          paymentMethods: currentProfile.paymentMethods,
          subscriptionType: currentProfile.subscriptionType,
          subscriptionExpiry: currentProfile.subscriptionExpiry,
          solarSystemSize: currentProfile.solarSystemSize,
          numberOfPanels: currentProfile.numberOfPanels,
          panelType: currentProfile.panelType,
          inverterSize: currentProfile.inverterSize,
          panelBrand: currentProfile.panelBrand,
          subscriptionPlan: currentProfile.subscriptionPlan,
        ),
      );
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profile = Provider.of<ProfileProvider>(context).profile;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: () {
              setState(() {
                if (_isEditing) {
                  _saveProfile();
                } else {
                  _isEditing = true;
                }
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            ProfileHeader(
              profile: profile,
              isEditing: _isEditing,
              onPickImage: _pickImage,
            ),

            const SizedBox(height: 24),

            // Profile Form when editing
            if (_isEditing)
              ProfileEditForm(
                formKey: _formKey,
                nameController: _nameController,
                emailController: _emailController,
                phoneController: _phoneController,
                addressController: _addressController,
              ),

            if (!_isEditing) ...[
              // Personal Information
              ProfilePersonalInfo(profile: profile),

              const SizedBox(height: 24),

              // Saved Locations
              SavedLocationsSection(savedLocations: profile.savedLocations),

              const SizedBox(height: 24),

              // Payment Methods
              PaymentMethodsSection(paymentMethods: profile.paymentMethods),

              const SizedBox(height: 24),

              // Subscription
              SubscriptionSection(profile: profile),

              const SizedBox(height: 24),

              // Reward Points
              RewardPointsSection(rewardPoints: profile.rewardPoints),
            ],
          ],
        ),
      ),
    );
  }
}
