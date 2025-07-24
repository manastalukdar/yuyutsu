import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  double _fontSize = AppConstants.defaultFontSize;
  String _selectedFont = AppConstants.defaultFontFamily;
  bool _fullScreenReading = true;
  bool _keepScreenOn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > AppConstants.tabletBreakpoint) {
            return _buildTabletLayout();
          } else {
            return _buildMobileLayout();
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: _buildSettingsSections(),
    );
  }

  Widget _buildTabletLayout() {
    return Row(
      children: [
        Container(
          width: 200,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: Colors.grey.shade300),
            ),
          ),
          child: ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.palette),
                title: const Text('Appearance'),
                selected: true,
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.text_fields),
                title: const Text('Reading'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Storage'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About'),
                onTap: () {},
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: _buildSettingsSections(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildSettingsSections() {
    return [
      _buildAppearanceSection(),
      const SizedBox(height: 24),
      _buildReadingSection(),
      const SizedBox(height: 24),
      _buildStorageSection(),
      const SizedBox(height: 24),
      _buildAboutSection(),
    ];
  }

  Widget _buildAppearanceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Appearance',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Dark Mode'),
              subtitle: const Text('Use dark theme for the app'),
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Theme'),
              subtitle: const Text('Choose app color theme'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showThemeSelection();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reading Settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Font Size'),
              subtitle: Text('${_fontSize.round()} pt'),
              trailing: SizedBox(
                width: 120,
                child: Slider(
                  value: _fontSize,
                  min: AppConstants.minFontSize,
                  max: AppConstants.maxFontSize,
                  divisions: ((AppConstants.maxFontSize - AppConstants.minFontSize) / 2).round(),
                  onChanged: (value) {
                    setState(() {
                      _fontSize = value;
                    });
                  },
                ),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Font Family'),
              subtitle: Text(_selectedFont),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showFontSelection();
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Full Screen Reading'),
              subtitle: const Text('Hide system UI when reading'),
              value: _fullScreenReading,
              onChanged: (value) {
                setState(() {
                  _fullScreenReading = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Keep Screen On'),
              subtitle: const Text('Prevent screen from sleeping while reading'),
              value: _keepScreenOn,
              onChanged: (value) {
                setState(() {
                  _keepScreenOn = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Storage',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Books Location'),
              subtitle: const Text('~/Documents/YuyutsuBooks'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                _showStorageSettings();
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Clear Cache'),
              subtitle: const Text('Free up storage space'),
              trailing: const Icon(Icons.delete_outline),
              onTap: () {
                _showClearCacheDialog();
              },
            ),
            const Divider(),
            const ListTile(
              title: Text('Used Space'),
              subtitle: Text('Books: 245 MB • Cache: 18 MB'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('App Version'),
              subtitle: const Text(AppConstants.appVersion),
            ),
            const Divider(),
            ListTile(
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () {
                // TODO: Open privacy policy
              },
            ),
            ListTile(
              title: const Text('Terms of Service'),
              trailing: const Icon(Icons.open_in_new),
              onTap: () {
                // TODO: Open terms of service
              },
            ),
            ListTile(
              title: const Text('Open Source Licenses'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                showLicensePage(context: context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('System Default'),
              value: 'system',
              groupValue: 'system',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Light'),
              value: 'light',
              groupValue: 'system',
              onChanged: (value) => Navigator.pop(context),
            ),
            RadioListTile<String>(
              title: const Text('Dark'),
              value: 'dark',
              groupValue: 'system',
              onChanged: (value) => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showFontSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Font'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: AppConstants.availableFonts.length,
            itemBuilder: (context, index) {
              final font = AppConstants.availableFonts[index];
              return RadioListTile<String>(
                title: Text(font, style: TextStyle(fontFamily: font)),
                value: font,
                groupValue: _selectedFont,
                onChanged: (value) {
                  setState(() {
                    _selectedFont = value!;
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showStorageSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Settings'),
        content: const Text('Choose where to store your books'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement storage location selection
            },
            child: const Text('Choose Folder'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will remove cached data to free up storage. Your books and settings will not be affected.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cache cleared successfully')),
              );
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}