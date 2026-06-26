import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/search_controller.dart';
import '../../domain/models/app_info.dart';

/// Modern responsive Search View utilizing Material 3 components
class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchControllerProvider);
    final controller = ref.read(searchControllerProvider.notifier);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Apps Alternator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_outlined),
            tooltip: 'Search History',
            onPressed: () => _showHistoryBottomSheet(context, state, controller),
          ),
          IconButton(
            icon: const Icon(Icons.favorite_outline),
            tooltip: 'Favorites',
            onPressed: () => _showFavoritesBottomSheet(context, state, controller),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                _buildSearchInput(theme, controller),
                const SizedBox(height: 16),
                if (state.error != null)
                  _buildErrorSection(theme, state.error!),
                if (state.isLoading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                else if (state.currentResult != null)
                  Expanded(
                    child: _buildSearchResultArea(theme, state.currentResult!, controller, state),
                  )
                else
                  Expanded(
                    child: _buildWelcomeState(theme),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchInput(ThemeData theme, AppSearchController controller) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search software (e.g. Photoshop, VS Code)',
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  controller.searchApp(value);
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic_none, color: Colors.grey),
              tooltip: 'Voice Search (Prepared)',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Voice Recognition is prepared for Phase 3.')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: () {
                controller.searchApp(_searchController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSection(ThemeData theme, String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeState(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.layers_outlined, size: 80, color: theme.colorScheme.secondary.withValues(alpha: 0.5)),
        const SizedBox(height: 16),
        Text(
          'Find Verified Software Alternatives',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 8),
        const Text(
          'Discover legitimate, secure, and open-source options for any premium software.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildSampleChip('Photoshop'),
            _buildSampleChip('VS Code'),
            _buildSampleChip('Canva'),
          ],
        )
      ],
    );
  }

  Widget _buildSampleChip(String text) {
    return ActionChip(
      label: Text(text),
      onPressed: () {
        _searchController.text = text;
        ref.read(searchControllerProvider.notifier).searchApp(text);
      },
    );
  }

  Widget _buildSearchResultArea(ThemeData theme, AppInfo app, AppSearchController controller, SearchState state) {
    final isFav = state.favorites.any((item) => item.query.toLowerCase() == app.name.toLowerCase());

    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        // Title block
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.name,
                    style: theme.textTheme.displayLarge?.copyWith(fontSize: 24),
                  ),
                  Text(
                    'by ${app.developer} • ${app.category}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : null,
                  ),
                  onPressed: () => controller.toggleFavoriteStatus(app.name),
                ),
                IconButton(
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Share URL copied to clipboard!')),
                    );
                  },
                ),
              ],
            )
          ],
        ),
        const SizedBox(height: 16),

        // Quick Overview Grid / Bento Layout
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 2.2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildBentoCard('Pricing & Trial', app.pricing, Icons.payments_outlined, theme),
            _buildBentoCard('Platforms', app.supportedPlatforms.join(', '), Icons.devices, theme),
            _buildBentoCard('Free Option', app.hasFreeVersion ? 'Yes, Available' : 'Trial Only', Icons.new_releases_outlined, theme),
            _buildBentoCard('Requirements', app.systemRequirements, Icons.settings_suggest_outlined, theme),
          ],
        ),
        const SizedBox(height: 16),

        // Pros and Cons Column Layout
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _buildListCard('Pros', app.pros, Colors.green, Icons.check_circle_outline, theme),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildListCard('Cons', app.cons, Colors.redAccent, Icons.highlight_off, theme),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Download Links & Official Trial
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verified Links', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                ListTile(
                  leading: const Icon(Icons.language, color: Colors.blue),
                  title: const Text('Official Product Website'),
                  subtitle: Text(app.officialWebsite, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.download, color: Colors.green),
                  title: const Text('Download Installer / Setup'),
                  subtitle: Text(app.officialDownloadLink, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.open_in_new, size: 18),
                  onTap: () {},
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Open Source Alternatives
        _buildAlternativesSection('Open Source Alternatives', app.openSourceAlternatives, theme, true),
        const SizedBox(height: 12),

        // Other Alternatives
        _buildAlternativesSection('Commercial Alternatives', app.similarApplications, theme, false),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildBentoCard(String label, String value, IconData icon, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(icon, size: 28, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListCard(String title, List<String> items, Color color, IconData icon, ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 8),
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(child: Text(item, style: const TextStyle(fontSize: 12))),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAlternativesSection(String heading, List<AppAlternative> list, ThemeData theme, bool isOpenSource) {
    if (list.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Row(
            children: [
              Icon(isOpenSource ? Icons.code : Icons.star_outline, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(heading, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        ...list.map((alt) => Card(
          child: ListTile(
            title: Text(alt.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            subtitle: Text('${alt.category} • Pricing: ${alt.pricing}', style: const TextStyle(fontSize: 12)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (alt.isOpenSource)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('OSI Approved', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                const Icon(Icons.open_in_new, size: 16),
              ],
            ),
            onTap: () {},
          ),
        )),
      ],
    );
  }

  void _showHistoryBottomSheet(BuildContext context, SearchState state, AppSearchController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Search History (Prepared)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (state.searchHistory.isEmpty)
              const Expanded(child: Center(child: Text('No searches yet.')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: state.searchHistory.length,
                  itemBuilder: (context, idx) {
                    final item = state.searchHistory[idx];
                    return ListTile(
                      leading: const Icon(Icons.history),
                      title: Text(item.query),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                      onTap: () {
                        _searchController.text = item.query;
                        controller.searchApp(item.query);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFavoritesBottomSheet(BuildContext context, SearchState state, AppSearchController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Saved Favorites (Prepared)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (state.favorites.isEmpty)
              const Expanded(child: Center(child: Text('No favorites saved yet.')))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: state.favorites.length,
                  itemBuilder: (context, idx) {
                    final item = state.favorites[idx];
                    return ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.red),
                      title: Text(item.query),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 12),
                      onTap: () {
                        _searchController.text = item.query;
                        controller.searchApp(item.query);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
