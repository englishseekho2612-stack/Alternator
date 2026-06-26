import 'package:flutter/material.dart';
import '../../domain/models/user_profile.dart';
import '../controllers/dashboard_controller.dart';

class ProfileSettingsView extends StatefulWidget {
  final DashboardController controller;
  final String userId;

  const ProfileSettingsView({
    Key? key,
    required this.controller,
    required this.userId,
  }) : super(key: key);

  @override
  State<ProfileSettingsView> createState() => _ProfileSettingsViewState();
}

class _ProfileSettingsViewState extends State<ProfileSettingsView> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.controller.profile != null) {
      _nameController.text = widget.controller.profile!.displayName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final profile = widget.controller.profile;
        if (profile == null) {
          return const Scaffold(body: Center(child: Text('Profile not initialized.')));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Account Profile Settings'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Picture & Quick Details change
                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        backgroundImage: NetworkImage(profile.profilePictureUrl),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile picture upload simulation active.')),
                          );
                        },
                        icon: const Icon(Icons.camera_alt_outlined, size: 16),
                        label: const Text('Change Avatar'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Name Input Field
                const Text(
                  'Display Name',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Enter name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.save, size: 20),
                      onPressed: () async {
                        final success = await widget.controller.updateDisplayName(widget.userId, _nameController.text);
                        if (success && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Display name updated.')),
                          );
                        }
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Multi-Language Picker
                const Text(
                  'Preferred Language',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: profile.preferredLanguage,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      widget.controller.updatePreferredLanguage(widget.userId, val);
                    }
                  },
                ),

                const SizedBox(height: 24),

                // Notifications Preferences Section
                const Text(
                  'Notification Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Email Updates'),
                        subtitle: const Text('Get monthly trial/premium alerts and feature logs.'),
                        value: profile.emailNotificationsEnabled,
                        onChanged: (val) {
                          // Simulation hook
                        },
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Push Reminders'),
                        subtitle: const Text('Get real-time notification alerts before trial expires.'),
                        value: profile.pushNotificationsEnabled,
                        onChanged: (val) {
                          // Simulation hook
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Cloud synchronization toggle
                const Text(
                  'Data Sync & Offline Cloud Settings',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Cloud Synchronization'),
                        subtitle: const Text('Sync saved favorites and search histories across all devices.'),
                        value: profile.isCloudSyncActive,
                        onChanged: (val) {
                          widget.controller.toggleCloudSync(widget.userId, val);
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.cloud_sync, color: Colors.blue),
                        title: const Text('Sync Metadata Now'),
                        subtitle: Text('Last successful synchronization: ${profile.lastSyncedAt.toLocal().toString().split('.')[0]}'),
                        trailing: const Icon(Icons.arrow_right),
                        onTap: widget.controller.isSyncing
                            ? null
                            : () async {
                                final success = await widget.controller.syncNow(widget.userId);
                                if (success && mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Cloud storage synchronized successfully.')),
                                  );
                                }
                              },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Advanced actions: Clear Cache, Logout, About
                const Text(
                  'Application Controls',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const SizedBox(height: 6),
                Card(
                  color: Colors.red.shade50,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.delete_forever, color: Colors.red),
                        title: const Text('Clear Storage Cache', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                        subtitle: const Text('Reset local index caches and restore defaults.'),
                        onTap: () async {
                          await widget.controller.resetCache(widget.userId);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cache reset complete.')),
                            );
                          }
                        },
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.blueGrey),
                        title: const Text('Logout securely'),
                        subtitle: const Text('Sign out from all cloud sync sessions.'),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Signed out from Apps Alternator simulation.')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
