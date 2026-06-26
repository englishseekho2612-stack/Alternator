import 'package:flutter/material.dart';
import '../../domain/models/user_profile.dart';
import '../controllers/dashboard_controller.dart';
import 'profile_settings_view.dart';
import 'favorites_view.dart';

class DashboardView extends StatefulWidget {
  final DashboardController controller;
  final String userId;

  const DashboardView({
    Key? key,
    required this.controller,
    required this.userId,
  }) : super(key: key);

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.loadDashboardData(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apps Alternator Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sync Cloud Data',
            onPressed: widget.controller.isSyncing
                ? null
                : () async {
                    final success = await widget.controller.syncNow(widget.userId);
                    if (success && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cloud synchronization complete.')),
                      );
                    }
                  },
          ),
          IconButton(
            icon: const Icon(Icons.manage_accounts),
            tooltip: 'Profile & Settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileSettingsView(
                    controller: widget.controller,
                    userId: widget.userId,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          if (widget.controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final profile = widget.controller.profile;
          if (profile == null) {
            return const Center(child: Text('Unable to load profile data'));
          }

          // Welcome text based on language setting
          const String welcomeText = 'Welcome back,';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Error Alert Banner
                if (widget.controller.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            widget.controller.errorMessage!,
                            style: TextStyle(color: Colors.red.shade900),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: widget.controller.clearError,
                        ),
                      ],
                    ),
                  ),

                // Welcome Header section with Profile card
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          backgroundImage: NetworkImage(profile.profilePictureUrl),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                welcomeText,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.7),
                                ),
                              ),
                              Text(
                                profile.displayName,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Email: ${profile.email}',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Bento-Grid Layout Section
                const Text(
                  'Quick Overview',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    // Cloud Sync Grid Card
                    _buildBentoItem(
                      context,
                      title: 'Cloud Synchronization',
                      subtitle: profile.isCloudSyncActive ? 'ACTIVE' : 'DISABLED',
                      icon: Icons.cloud_done_outlined,
                      color: profile.isCloudSyncActive ? Colors.green.shade50 : Colors.grey.shade100,
                      iconColor: profile.isCloudSyncActive ? Colors.green : Colors.grey,
                      onTap: () {
                        widget.controller.toggleCloudSync(widget.userId, !profile.isCloudSyncActive);
                      },
                    ),

                    // Language Settings Grid Card
                    _buildBentoItem(
                      context,
                      title: 'App Language',
                      subtitle: profile.preferredLanguage.toUpperCase(),
                      icon: Icons.g_translate,
                      color: Colors.blue.shade50,
                      iconColor: Colors.blue,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileSettingsView(
                              controller: widget.controller,
                              userId: widget.userId,
                            ),
                          ),
                        );
                      },
                    ),

                    // Saved Favorites Counter Card
                    _buildBentoItem(
                      context,
                      title: 'Saved Favorites',
                      subtitle: '${widget.controller.favorites.length} Apps',
                      icon: Icons.star_border,
                      color: Colors.amber.shade50,
                      iconColor: Colors.amber.shade800,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoritesView(
                              controller: widget.controller,
                              userId: widget.userId,
                            ),
                          ),
                        );
                      },
                    ),

                    // AI Conversations Saved Lists
                    _buildBentoItem(
                      context,
                      title: 'AI Companion Chats',
                      subtitle: '${widget.controller.conversations.length} Saved',
                      icon: Icons.forum_outlined,
                      color: Colors.deepPurple.shade50,
                      iconColor: Colors.deepPurple,
                      onTap: () {
                        // Triggers transition back to Companion Chat tab
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Opening AI Chats History...')),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Favorites Horizontal Carousel preview
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Favorite Applications',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FavoritesView(
                              controller: widget.controller,
                              userId: widget.userId,
                            ),
                          ),
                        );
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (widget.controller.favorites.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    alignment: Alignment.center,
                    child: Text(
                      'No saved favorites yet.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  )
                else
                  SizedBox(
                    height: 90,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.controller.favorites.length,
                      itemBuilder: (context, index) {
                        final fav = widget.controller.favorites[index];
                        return Card(
                          margin: const EdgeInsets.only(right: 12),
                          elevation: 1,
                          child: Container(
                            width: 160,
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  fav.appName,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Alternative for ${fav.originalApp}',
                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 24),

                // Recent searches list
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recent Searches',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    if (widget.controller.searchHistory.isNotEmpty)
                      TextButton(
                        onPressed: () => widget.controller.clearAllSearchHistory(widget.userId),
                        child: const Text('Clear All'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                if (widget.controller.searchHistory.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text('Your recent queries will appear here.', style: TextStyle(color: Colors.grey.shade600)),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.controller.searchHistory.length > 3 ? 3 : widget.controller.searchHistory.length,
                    itemBuilder: (context, index) {
                      final item = widget.controller.searchHistory[index];
                      return ListTile(
                        leading: const Icon(Icons.history, size: 20),
                        title: Text(item.query),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          onPressed: () => widget.controller.removeHistoryItem(widget.userId, item.query),
                        ),
                        onTap: () {
                          // Relaunches search alternatives
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Searching alternative for "${item.query}"...')),
                          );
                        },
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBentoItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: iconColor.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
