import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';

class FavoritesView extends StatefulWidget {
  final DashboardController controller;
  final String userId;

  const FavoritesView({
    Key? key,
    required this.controller,
    required this.userId,
  }) : super(key: key);

  @override
  State<FavoritesView> createState() => _FavoritesViewState();
}

class _FavoritesViewState extends State<FavoritesView> {
  String _searchQuery = '';
  String _sortBy = 'name'; // name, date
  String _filterType = 'all'; // all, open_source, commercial

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        // Apply search query, filtering and sorting
        final filteredList = widget.controller.favorites.where((item) {
          final matchesSearch = item.appName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.originalApp.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.category.toLowerCase().contains(_searchQuery.toLowerCase());
          
          final matchesFilter = _filterType == 'all' || item.alternativeType == _filterType;

          return matchesSearch && matchesFilter;
        }).toList();

        // Apply Sorting
        if (_sortBy == 'name') {
          filteredList.sort((a, b) => a.appName.compareTo(b.appName));
        } else if (_sortBy == 'date') {
          filteredList.sort((a, b) => b.favoritedAt.compareTo(a.favoritedAt));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('My Saved Favorites'),
          ),
          body: Column(
            children: [
              // Search & Filter controls panel
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search saved favorites...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Filter / Sort row controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Filter dropdown
                        Row(
                          children: [
                            const Text('Filter: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            DropdownButton<String>(
                              value: _filterType,
                              style: const TextStyle(fontSize: 12, color: Colors.black),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _filterType = val;
                                  });
                                }
                              },
                              items: const [
                                DropdownMenuItem(value: 'all', child: Text('All Alternatives')),
                                DropdownMenuItem(value: 'open_source', child: Text('Open Source')),
                                DropdownMenuItem(value: 'commercial', child: Text('Commercial')),
                              ],
                            ),
                          ],
                        ),

                        // Sort dropdown
                        Row(
                          children: [
                            const Text('Sort: ', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            DropdownButton<String>(
                              value: _sortBy,
                              style: const TextStyle(fontSize: 12, color: Colors.black),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _sortBy = val;
                                  });
                                }
                              },
                              items: const [
                                DropdownMenuItem(value: 'name', child: Text('Name (A-Z)')),
                                DropdownMenuItem(value: 'date', child: Text('Date Saved')),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              // Favorites list builder
              Expanded(
                child: filteredList.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star_border, size: 48, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            Text(
                              'No favorites found matching filters.',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final item = filteredList[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: item.alternativeType == 'open_source'
                                    ? Colors.teal.shade100
                                    : Colors.blue.shade100,
                                child: Text(
                                  item.appName[0],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: item.alternativeType == 'open_source'
                                        ? Colors.teal.shade800
                                        : Colors.blue.shade800,
                                  ),
                                ),
                              ),
                              title: Text(item.appName, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text(
                                'Category: ${item.category} • alternative for ${item.originalApp}',
                                style: const TextStyle(fontSize: 11),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.star, color: Colors.amber),
                                tooltip: 'Remove from Favorites',
                                onPressed: () {
                                  widget.controller.toggleFavorite(widget.userId, item);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Removed ${item.appName} from favorites.')),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
