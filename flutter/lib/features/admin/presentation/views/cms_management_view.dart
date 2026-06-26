import 'package:flutter/material.dart';
import '../domain/models/cms_content.dart';
import '../controllers/admin_controller.dart';

class CmsManagementView extends StatefulWidget {
  final AdminController controller;
  final String adminUser;

  const CmsManagementView({
    Key? key,
    required this.controller,
    required this.adminUser,
  }) : super(key: key);

  @override
  State<CmsManagementView> createState() => _CmsManagementViewState();
}

class _CmsManagementViewState extends State<CmsManagementView> {
  final _appNameController = TextEditingController();
  final _originalAppController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _downloadUrlController = TextEditingController();

  @override
  void dispose() {
    _appNameController.dispose();
    _originalAppController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _downloadUrlController.dispose();
    super.dispose();
  }

  void _showAddFeaturedAppSheet() {
    _appNameController.clear();
    _originalAppController.clear();
    _descriptionController.clear();
    _categoryController.clear();
    _downloadUrlController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Promote Featured Software Alts',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _appNameController,
                  decoration: const InputDecoration(labelText: 'Alternative App Name (e.g., Krita)'),
                ),
                TextField(
                  controller: _originalAppController,
                  decoration: const InputDecoration(labelText: 'Original Proprietary App (e.g., Photoshop)'),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Promotional Pitch / Description'),
                ),
                TextField(
                  controller: _categoryController,
                  decoration: const InputDecoration(labelText: 'App Category'),
                ),
                TextField(
                  controller: _downloadUrlController,
                  decoration: const InputDecoration(labelText: 'Secure Download Reference URL'),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                  onPressed: () async {
                    if (_appNameController.text.isEmpty || _originalAppController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please specify alternative and target applications.')),
                      );
                      return;
                    }

                    final newApp = FeaturedApp(
                      appName: _appNameController.text,
                      originalApp: _originalAppController.text,
                      description: _descriptionController.text,
                      category: _categoryController.text,
                      downloadUrl: _downloadUrlController.text,
                    );

                    final success = await widget.controller.editFeaturedApp(newApp, widget.adminUser);
                    if (success && mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('CMS update successful for: ${newApp.appName}')),
                      );
                    }
                  },
                  child: const Text('Publish Alternative App'),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CMS & Featured Management'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFeaturedAppSheet,
        child: const Icon(Icons.add),
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          final apps = widget.controller.featuredApps;
          final help = widget.controller.helpArticles;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Featured App Recommendations (Active CMS Mappings)',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (apps.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('No featured apps on CMS server.', textAlign: TextAlign.center),
                )
              else
                ...apps.map((app) => Card(
                  child: ListTile(
                    title: Text('${app.appName} vs ${app.originalApp}', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${app.description}\nCategory: ${app.category}'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.edit, size: 16),
                    onTap: () {
                      _appNameController.text = app.appName;
                      _originalAppController.text = app.originalApp;
                      _descriptionController.text = app.description;
                      _categoryController.text = app.category;
                      _downloadUrlController.text = app.downloadUrl;
                      _showAddFeaturedAppSheet();
                    },
                  ),
                )),

              const SizedBox(height: 24),

              const Text(
                'Help Center / FAQ Articles',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...help.map((item) => Card(
                child: ListTile(
                  title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${item.content}\nCategory: ${item.category}'),
                  isThreeLine: true,
                ),
              )),
            ],
          );
        },
      ),
    );
  }
}
