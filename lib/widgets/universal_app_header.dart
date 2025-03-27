import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:solcare_app4/providers/theme_provider.dart';
import 'package:solcare_app4/providers/profile_provider.dart';
import 'package:solcare_app4/screens/profile/profile_screen.dart';

enum AppHeaderType {
  home,
  services,
  bookings,
  cart,
  profile
}

class UniversalAppHeader extends StatefulWidget {
  final AppHeaderType headerType;
  final TextEditingController searchController;
  final Function(String) onSearch;
  final ScrollController? scrollController;
  final List<String>? searchSuggestions;
  final bool showSearchBar;
  final String? customTitle;

  const UniversalAppHeader({
    super.key,
    required this.headerType,
    required this.searchController,
    required this.onSearch,
    this.scrollController,
    this.searchSuggestions,
    this.showSearchBar = true,
    this.customTitle,
  });

  @override
  State<UniversalAppHeader> createState() => _UniversalAppHeaderState();
}

class _UniversalAppHeaderState extends State<UniversalAppHeader> {
  bool scrolled = false;
  bool showVoiceSearch = false;
  bool isSearchFocused = false;
  
  // For voice search functionality
  bool isListening = false;

  @override
  void initState() {
    super.initState();
    if (widget.scrollController != null) {
      widget.scrollController!.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    if (widget.scrollController != null) {
      widget.scrollController!.removeListener(_onScroll);
    }
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController == null) return;
    
    final newScrolled = widget.scrollController!.offset > 10;
    if (scrolled != newScrolled) {
      setState(() {
        scrolled = newScrolled;
      });
    }
  }
  
  // Simulate voice search
  void _startVoiceSearch() {
    HapticFeedback.mediumImpact();
    setState(() {
      isListening = true;
    });
    
    // Simulate voice processing (in a real app, use speech_to_text or similar)
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          isListening = false;
          widget.searchController.text = _getRandomSearchTerm();
          widget.onSearch(widget.searchController.text);
        });
      }
    });
  }
  
  // Just for demo purposes
  String _getRandomSearchTerm() {
    final terms = widget.headerType == AppHeaderType.services 
        ? ['Solar panel cleaning', 'Inverter repair', 'System check'] 
        : ['Maintenance', 'Installation', 'Solar efficiency'];
    return terms[DateTime.now().millisecond % terms.length];
  }
  
  String _getPlaceholderText() {
    switch (widget.headerType) {
      case AppHeaderType.home:
        return 'Search services, maintenance tips...';
      case AppHeaderType.services:
        return 'Search for services...';
      case AppHeaderType.bookings:
        return 'Search your bookings...';
      case AppHeaderType.cart:
        return 'Search items in cart...';
      case AppHeaderType.profile:
        return 'Search settings, history...';
    }
  }
  
  String _getScreenTitle() {
    if (widget.customTitle != null) return widget.customTitle!;
    
    switch (widget.headerType) {
      case AppHeaderType.home:
        return 'SolCare';
      case AppHeaderType.services:
        return 'Services';
      case AppHeaderType.bookings:
        return 'My Bookings';
      case AppHeaderType.cart:
        return 'My Cart';
      case AppHeaderType.profile:
        return 'Profile';
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final profileProvider = Provider.of<ProfileProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    
    // Fix: Use a mock notification indicator or derive it from existing data
    // This is a temporary solution - in a real app, add hasUnreadNotifications to ProfileProvider
    final hasNotifications = profileProvider.profile.rewardPoints > 0;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: scrolled ? 70 : (widget.showSearchBar ? 130 : 70),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.indigo[900]!, Colors.blue[900]!]
              : [Colors.blue[500]!, Colors.teal[300]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top row: Logo, Title, Icons
            Row(
              children: [
                // Left section - Logo & App name
                Row(
                  children: [
                    const Icon(
                      Icons.solar_power,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _getScreenTitle(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Right section - Notification & Profile
                Stack(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Handle notifications
                      },
                    ),
                    if (hasNotifications)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.person_outline,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            
            // Search bar (conditionally shown)
            if (widget.showSearchBar) ...[
              const SizedBox(height: 10),
              Container(
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Focus(
                  onFocusChange: (hasFocus) {
                    setState(() {
                      isSearchFocused = hasFocus;
                    });
                  },
                  child: TextField(
                    controller: widget.searchController,
                    onChanged: widget.onSearch,
                    decoration: InputDecoration(
                      hintText: _getPlaceholderText(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.searchController.text.isNotEmpty)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              iconSize: 20,
                              onPressed: () {
                                setState(() {
                                  widget.searchController.clear();
                                  widget.onSearch('');
                                });
                              },
                            ),
                          IconButton(
                            icon: Icon(
                              isListening ? Icons.mic : Icons.mic_none,
                              color: isListening ? Colors.red : null,
                            ),
                            onPressed: _startVoiceSearch,
                          ),
                        ],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
