import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';

class SolarSystemInfoScreen extends StatefulWidget {
  const SolarSystemInfoScreen({Key? key}) : super(key: key);

  @override
  State<SolarSystemInfoScreen> createState() => _SolarSystemInfoScreenState();
}

class _SolarSystemInfoScreenState extends State<SolarSystemInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _systemSizeController;
  late TextEditingController _panelCountController;
  late TextEditingController _panelTypeController;
  late TextEditingController _inverterSizeController;
  late TextEditingController _panelBrandController;
  
  @override
  void initState() {
    super.initState();
    final profile = Provider.of<ProfileProvider>(context, listen: false).profile;
    
    _systemSizeController = TextEditingController(text: profile.solarSystemSize);
    _panelCountController = TextEditingController(text: profile.numberOfPanels);
    _panelTypeController = TextEditingController(text: profile.panelType);
    _inverterSizeController = TextEditingController(text: profile.inverterSize);
    _panelBrandController = TextEditingController(text: profile.panelBrand);
  }
  
  @override
  void dispose() {
    _systemSizeController.dispose();
    _panelCountController.dispose();
    _panelTypeController.dispose();
    _inverterSizeController.dispose();
    _panelBrandController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solar System Information'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // System illustration
            Container(
              height: 180,
              margin: const EdgeInsets.only(bottom: 24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              ),
              child: Center(
                child: Icon(
                  Icons.solar_power,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            
            _buildInfoField(
              controller: _systemSizeController,
              labelText: 'System Size (kW)',
              icon: Icons.power,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter system size';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            
            _buildInfoField(
              controller: _panelCountController,
              labelText: 'Number of Solar Panels',
              icon: Icons.grid_4x4,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter number of panels';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            
            _buildInfoField(
              controller: _panelTypeController,
              labelText: 'Panel Type',
              icon: Icons.view_module,
              hintText: 'e.g., Monocrystalline, Polycrystalline',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter panel type';
                }
                return null;
              },
            ),
            
            _buildInfoField(
              controller: _inverterSizeController,
              labelText: 'Inverter Size (kW)',
              icon: Icons.electric_bolt,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter inverter size';
                }
                return null;
              },
              keyboardType: TextInputType.number,
            ),
            
            _buildInfoField(
              controller: _panelBrandController,
              labelText: 'Panel Brand Name',
              icon: Icons.branding_watermark,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter panel brand';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 32),
            
            ElevatedButton(
              onPressed: _saveSystemInfo,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save System Information'),
            ),
            
            const SizedBox(height: 16),
            
            TextButton.icon(
              icon: const Icon(Icons.info_outline),
              label: const Text('Why is this information important?'),
              onPressed: () => _showInfoImportanceDialog(),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    String? hintText,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }
  
  void _saveSystemInfo() {
    if (_formKey.currentState!.validate()) {
      // In a real app, you would save this to the user's profile
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Solar system information updated')),
      );
      
      // Mock save to profile
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.updateSolarSystemInfo(
        systemSize: _systemSizeController.text,
        panelCount: _panelCountController.text,
        panelType: _panelTypeController.text,
        inverterSize: _inverterSizeController.text,
        panelBrand: _panelBrandController.text,
      );
      
      Navigator.pop(context);
    }
  }
  
  void _showInfoImportanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Why This Information Matters'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Providing accurate details about your solar system helps us:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text('• Provide more accurate maintenance recommendations'),
              Text('• Calculate appropriate service costs'),
              Text('• Suggest optimal cleaning schedules'),
              Text('• Recommend system upgrades when beneficial'),
              Text('• Track performance against similar systems'),
              SizedBox(height: 16),
              Text(
                'Your information is kept secure and private in accordance with our privacy policy.',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}
