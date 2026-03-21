import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';
import '../widgets/gradient_background.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _endpointController;

  @override
  void initState() {
    super.initState();
    final storage = context.read<StorageService>();
    _endpointController = TextEditingController(text: storage.endpoint);
  }

  @override
  void dispose() {
    _endpointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = context.watch<StorageService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.transparent,
      ),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // API Endpoint
            const _SectionHeader(title: 'AI Configuration'),
            const SizedBox(height: 12),
            TextFormField(
              controller: _endpointController,
              decoration: const InputDecoration(
                labelText: 'API Endpoint',
                prefixIcon: Icon(Icons.link_rounded),
              ),
              onChanged: (v) => storage.setEndpoint(v),
            ),
            const SizedBox(height: 16),

            // Model selection
            DropdownButtonFormField<String>(
              value: storage.model,
              decoration: const InputDecoration(
                labelText: 'AI Model',
                prefixIcon: Icon(Icons.smart_toy_rounded),
              ),
              items: AppConstants.availableModels
                  .map((m) => DropdownMenuItem(value: m, child: Text(m)))
                  .toList(),
              onChanged: (v) {
                if (v != null) storage.setModel(v);
              },
            ),

            const SizedBox(height: 32),
            const _SectionHeader(title: 'Appearance'),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.dark_mode_rounded,
              title: 'Dark Theme',
              subtitle: storage.isDarkTheme ? 'On' : 'Off',
              trailing: Switch(
                value: storage.isDarkTheme,
                onChanged: (_) => storage.toggleTheme(),
                activeColor: Colors.indigoAccent,
              ),
            ),

            const SizedBox(height: 32),
            const _SectionHeader(title: 'Data'),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.star_rounded,
              title: 'Favorites',
              subtitle: '${storage.favorites.length} saved items',
            ),
            const SizedBox(height: 8),
            _SettingsTile(
              icon: Icons.delete_outline_rounded,
              title: 'Clear All Data',
              subtitle: 'Reset favorites, settings, and onboarding',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Clear All Data?'),
                    content: const Text(
                      'This will delete all favorites, reset settings, and show onboarding again.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          storage.clearAll();
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('All data cleared')),
                          );
                        },
                        child: const Text('Clear', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
            const _SectionHeader(title: 'About'),
            const SizedBox(height: 12),
            _SettingsTile(
              icon: Icons.info_outline_rounded,
              title: AppConstants.appName,
              subtitle: 'Version ${AppConstants.appVersion}',
            ),
            const SizedBox(height: 8),
            _SettingsTile(
              icon: Icons.code_rounded,
              title: 'Powered by AI',
              subtitle: 'Model: ${storage.model}',
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.white.withOpacity(0.5),
        letterSpacing: 1,
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.white70),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
