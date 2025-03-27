import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solcare_app4/screens/services/providers/services_providers.dart';

class ServiceSearchBar extends ConsumerStatefulWidget {
  final Function(String) onSearch;
  final bool autofocus;
  
  const ServiceSearchBar({
    super.key,
    required this.onSearch,
    this.autofocus = false,
  });

  @override
  ConsumerState<ServiceSearchBar> createState() => _ServiceSearchBarState();
}

class _ServiceSearchBarState extends ConsumerState<ServiceSearchBar> {
  late TextEditingController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    // Initialize controller with current query
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final query = ref.read(searchQueryProvider);
      _controller.text = query;
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  void _handleSearch(String query) {
    // Update the provider state
    ref.read(searchQueryProvider.notifier).state = query;
    // Call the callback
    widget.onSearch(query);
  }
  
  @override
  Widget build(BuildContext context) {
    // Watch the provider for changes from elsewhere
    final searchQuery = ref.watch(searchQueryProvider);
    
    // Update controller if provider changed externally
    if (_controller.text != searchQuery) {
      _controller.text = searchQuery;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          hintText: 'Search for solar services...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    _handleSearch('');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
        onChanged: _handleSearch,
        onSubmitted: _handleSearch,
      ),
    );
  }
}
