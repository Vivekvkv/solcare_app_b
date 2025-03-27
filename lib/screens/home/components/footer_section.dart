import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class FooterSection extends StatefulWidget {
  const FooterSection({Key? key}) : super(key: key);

  @override
  State<FooterSection> createState() => _FooterSectionState();
}

class _FooterSectionState extends State<FooterSection> with SingleTickerProviderStateMixin {
  final PageController _eventsController = PageController();
  late Timer _autoScrollTimer;
  int _currentEventIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool _isSubscribed = false;
  final TextEditingController _emailController = TextEditingController();
  bool _isEmailValid = false;

  // Upcoming events data
  final List<Map<String, dynamic>> _events = [
    {
      'title': 'Solar Technology Expo',
      'date': '15 May 2023',
      'location': 'Mumbai',
      'icon': Icons.event,
    },
    {
      'title': 'Green Energy Workshop',
      'date': '22 June 2023',
      'location': 'Delhi',
      'icon': Icons.lightbulb,
    },
    {
      'title': 'Solar Maintenance Day',
      'date': '10 July 2023',
      'location': 'Bangalore',
      'icon': Icons.build,
    },
    {
      'title': 'Energy Conference',
      'date': '5 August 2023',
      'location': 'Hyderabad',
      'icon': Icons.eco,
    },
  ];

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controller with lower frame rate for mobile
    _animationController = AnimationController(
      duration: const Duration(seconds: 3), // Slower animation
      vsync: this,
    );
    
    // Create animation
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    
    // Start animation
    _animationController.repeat(reverse: true);
    
    // Start auto-scrolling timer
    _startAutoScroll();
    
    // Listen for changes in the email field
    _emailController.addListener(_validateEmail);
  }

  void _validateEmail() {
    final email = _emailController.text;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    setState(() {
      _isEmailValid = emailRegex.hasMatch(email);
    });
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_eventsController.hasClients) {
        _currentEventIndex = (_currentEventIndex + 1) % _events.length;
        _eventsController.animateToPage(
          _currentEventIndex,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _handleSubscribe() {
    final email = _emailController.text.trim();
    if (email.isNotEmpty && _isEmailValid) {
      // Give haptic feedback for mobile users
      HapticFeedback.mediumImpact();
      
      setState(() {
        _isSubscribed = true;
      });
      _emailController.clear();
      
      // Show confirmation and reset after some time
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _isSubscribed = false;
          });
        }
      });
    }
  }

  void _launchURL(String url) async {
    // Give haptic feedback for mobile users
    HapticFeedback.selectionClick();
    
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      debugPrint('Could not launch $url: $e');
    }
  }

  @override
  void dispose() {
    _autoScrollTimer.cancel();
    _animationController.dispose();
    _emailController.dispose();
    _eventsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1565C0), // Deep vibrant blue
            const Color(0xFF0D47A1), // Darker blue
          ],
        ),
      ),
      // Setting constraints to avoid overflow
      constraints: BoxConstraints(minHeight: isMobile ? 150 : 200),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // Make sure this is set to min to prevent overflow
        mainAxisSize: MainAxisSize.min,
        children: [
          // Curved top edge with wave pattern - make smaller
          ClipPath(
            clipper: FooterWaveClipper(),
            child: Container(
              height: isMobile ? 10 : 30, // Further reduced height 
              width: double.infinity,
              color: Colors.white,
            ),
          ),
          
          // Upcoming events auto-scrolling section - even more compact
          if (isMobile)
            SizedBox(
              height: 40, // Further reduced height for mobile
              child: _buildCompactEventsCarousel(isMobile),
            )
          else
            _buildEventsCarousel(isMobile),
          
          // Main footer content with horizontal layout - adjust padding to prevent overflow
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              // Reduce vertical padding further
              vertical: isMobile ? 4 : 16, 
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Make content tight
              children: [
                // Fully horizontal layout for mobile
                Wrap(
                  spacing: 0,
                  runSpacing: isMobile ? 16 : 24,
                  alignment: WrapAlignment.spaceBetween,
                  children: [
                    // Company Info - more compact
                    SizedBox(
                      width: isMobile ? MediaQuery.of(context).size.width * 0.45 - 16 : null,
                      child: _buildCompactCompanyInfo(isMobile),
                    ),
                    
                    // Quick Links - more compact
                    SizedBox(
                      width: isMobile ? MediaQuery.of(context).size.width * 0.45 - 16 : null,
                      child: _buildCompactQuickLinks(isMobile),
                    ),
                    
                    // Newsletter - full width on wrap but compact
                    _buildCompactNewsletterSignup(isMobile),
                  ],
                ),
                
                // Only show animation on desktop
                if (!isMobile) _buildSolarAnimation(),
                
                SizedBox(height: isMobile ? 8 : 16), // Reduced spacing
                
                // Divider with glow effect
                Container(
                  height: 1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                    // Remove box shadow to save space
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.white.withOpacity(0.2),
                    //     blurRadius: 8,
                    //     spreadRadius: 2,
                    //   ),
                    // ],
                  ),
                ),
                
                // Further reduced spacing
                SizedBox(height: isMobile ? 2 : 8),
                
                // Even more compact bottom bar
                _buildCompactBottomBar(isMobile),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Ultra-compact events carousel for saving height
  Widget _buildCompactEventsCarousel(bool isMobile) {
    return Container(
      height: 40, // Even smaller height
      margin: EdgeInsets.symmetric(
        vertical: 4, 
        horizontal: 16
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Minimal icon-only heading
          Container(
            width: 30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
            ),
            child: const Icon(Icons.event_note, color: Colors.white, size: 16),
          ),
          
          // Events carousel - full width and more compact
          Expanded(
            child: PageView.builder(
              controller: _eventsController,
              itemCount: _events.length,
              onPageChanged: (index) {
                setState(() {
                  _currentEventIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final event = _events[index];
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Event: ${event['title']}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Row(
                      children: [
                        Icon(event['icon'], color: Colors.white, size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                event['title'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${event['date']} • ${event['location']}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Compact company info with horizontal layout
  Widget _buildCompactCompanyInfo(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Logo and name in one line
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.solar_power,
                color: Color(0xFF1565C0),
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SOLCARE',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'Solar Panel Maintenance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        
        // Contact info in a horizontal wrap layout
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildCompactContactItem(Icons.location_on, 'Indore'),
            _buildCompactContactItem(Icons.phone, '+91 881-888-0540'),
            _buildCompactContactItem(Icons.email, 'support@solcare.co.in'),
          ],
        ),
      ],
    );
  }

  // Update compact contact items to prevent overflow
  Widget _buildCompactContactItem(IconData icon, String text) {
    return GestureDetector(
      onTap: () {
        if (icon == Icons.phone || icon == Icons.email) {
          final textToCopy = icon == Icons.phone
              ? '+918818880540'
              : 'support@solcare.co.in';
          
          Clipboard.setData(ClipboardData(text: textToCopy));
          HapticFeedback.selectionClick();
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$text copied to clipboard'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2), // Reduced padding
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8), // Smaller border radius
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white70, size: 10), // Smaller icon
            const SizedBox(width: 2), // Smaller spacing
            Text(
              text.length > 10 ? text.substring(0, 10) + '...' : text, // Shorter text limit
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 9, // Smaller font
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Compact quick links in a horizontal grid
  Widget _buildCompactQuickLinks(bool isMobile) {
    final links = [
      {'name': 'About Us', 'url': '#'},
      {'name': 'Services', 'url': '#'},
      {'name': 'Pricing', 'url': '#'},
      {'name': 'FAQs', 'url': '#'},
      {'name': 'Contact', 'url': '#'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        
        // Horizontal wrapping layout for links
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: links.map((link) {
            return InkWell(
              onTap: () => _launchURL(link['url']!),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  link['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Compact newsletter with a horizontal layout
  Widget _buildCompactNewsletterSignup(bool isMobile) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Row(
                children: [
                  Text(
                    'Subscribe',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Get updates & offers',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              // Compact subscription form
              Container(
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Your email',
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 0,
                          ),
                          hintStyle: TextStyle(fontSize: 12),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: _isEmailValid ? _handleSubscribe : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: Colors.grey,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: const Size(0, 36),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                      ),
                      child: const Text(
                        'GO',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              
              if (_isSubscribed)
                Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 10),
                      SizedBox(width: 4),
                      Text(
                        'Subscribed!',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        
        // Social links in a small horizontal bar
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Follow us',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildMiniSocialButton(FontAwesomeIcons.facebook, 'https://facebook.com'),
                _buildMiniSocialButton(FontAwesomeIcons.twitter, 'https://twitter.com'),
                _buildMiniSocialButton(FontAwesomeIcons.instagram, 'https://instagram.com'),
                _buildMiniSocialButton(FontAwesomeIcons.linkedin, 'https://linkedin.com'),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // Ultra-compact social buttons
  Widget _buildMiniSocialButton(IconData icon, String url) {
    return Container(
      margin: const EdgeInsets.only(left: 6),
      child: InkWell(
        onTap: () => _launchURL(url),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: FaIcon(
            icon, 
            color: Colors.white, 
            size: 10,
          ),
        ),
      ),
    );
  }

  // Update compact bottom bar to be even more compact
  Widget _buildCompactBottomBar(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Copyright text - made smaller
        Flexible(
          child: Text(
            '© ${DateTime.now().year}',  // Shorter copyright text
            style: const TextStyle(color: Colors.white70, fontSize: 8),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        
        // Terms link and badges - more compact
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero, // Remove padding
                minimumSize: const Size(0, 20), // Smaller height
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Terms',
                style: TextStyle(color: Colors.white70, fontSize: 8), // Smaller font
              ),
            ),
            _buildMicroBadge('ISO'),
            // Remove one badge to save space
          ],
        ),
      ],
    );
  }

  // Make micro badges even smaller
  Widget _buildMicroBadge(String text) {
    return Container(
      margin: const EdgeInsets.only(left: 2), // Smaller margin
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1), // Smaller padding
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(2), // Smaller border radius
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 6), // Smaller font
      ),
    );
  }

  Widget _buildEventsCarousel(bool isMobile) {
    // Simplified event carousel for mobile
    return Container(
      height: isMobile ? 100 : 80,
      margin: EdgeInsets.symmetric(
        vertical: isMobile ? 8 : 16, 
        horizontal: 16
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Heading - Simplified on mobile
          if (!isMobile)
            Container(
              width: 120,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_note, color: Colors.white),
                  SizedBox(height: 4),
                  Text(
                    'Upcoming Events',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          
          // Mobile version of heading
          if (isMobile)
            Container(
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
              ),
              child: const Icon(Icons.event_note, color: Colors.white),
            ),
          
          // Events carousel - Full width on mobile
          Expanded(
            child: PageView.builder(
              controller: _eventsController,
              itemCount: _events.length,
              onPageChanged: (index) {
                setState(() {
                  _currentEventIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final event = _events[index];
                return GestureDetector(
                  onTap: () {
                    // Haptic feedback on tap
                    HapticFeedback.selectionClick();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Event: ${event['title']}'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Icon(event['icon'], color: Colors.white),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                event['title'],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: isMobile ? 14 : 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${event['date']} • ${event['location']}',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: isMobile ? 10 : 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (!isMobile) const SizedBox(width: 8),
                        if (!isMobile)
                          IconButton(
                            icon: const Icon(Icons.calendar_today, color: Colors.white, size: 20),
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Added ${event['title']} to your calendar'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            tooltip: 'Add to calendar',
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyInfo(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo and name
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.solar_power,
                color: Color(0xFF1565C0),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SOLCARE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'Solar Panel Maintenance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Company description - Shorter on mobile
        const Text(
          'India\'s leading solar panel maintenance and optimization service, helping customers maximize their solar investment.',
          style: TextStyle(
            color: Colors.white70,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        
        // Contact info - Bigger touch targets on mobile
        _buildContactItem(Icons.location_on, 'PoloGround, Indore', isMobile),
        _buildContactItem(Icons.phone, '+91 881-888-0540', isMobile),
        _buildContactItem(Icons.email, 'support@solcare.co.in', isMobile),
        _buildContactItem(Icons.access_time, 'Mon-Sat: 9AM-6PM', isMobile),
      ],
    );
  }

  Widget _buildContactItem(IconData icon, String text, bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: isMobile ? 8.0 : 6.0),
      child: GestureDetector(
        onTap: () {
          // Copy to clipboard with feedback on mobile
          if (icon == Icons.phone || icon == Icons.email) {
            final textToCopy = icon == Icons.phone
                ? '+918818880540' // Clean format for dialing
                : 'support@solcare.co.in';
            
            Clipboard.setData(ClipboardData(text: textToCopy));
            HapticFeedback.selectionClick();
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('$text copied to clipboard'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: isMobile ? 20 : 16),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isMobile ? 14 : 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickLinks(bool isMobile) {
    final links = [
      {'name': 'About Us', 'url': '#'},
      {'name': 'Services', 'url': '#'},
      {'name': 'Pricing', 'url': '#'},
      {'name': 'Testimonials', 'url': '#'},
      {'name': 'FAQs', 'url': '#'},
      {'name': 'Contact', 'url': '#'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Links',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        // Mobile uses a grid layout for better space utilization
        isMobile
            ? GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 16,
                childAspectRatio: 2.5,
                children: links.map((link) {
                  return InkWell(
                    onTap: () {
                      _launchURL(link['url']!);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.arrow_right,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          link['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: links.map((link) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: InkWell(
                      onTap: () => _launchURL(link['url']!),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_right,
                            color: Colors.white,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            link['name']!,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildNewsletterSignup(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subscribe to Newsletter',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Stay updated with the latest news and special offers.',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Your email address',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: isMobile ? 16 : 12, // Taller input on mobile
                    ),
                    hintStyle: TextStyle(color: Colors.grey[400]),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(fontSize: isMobile ? 16 : 14),
                ),
              ),
              ElevatedButton(
                onPressed: _isEmailValid ? _handleSubscribe : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 18 : 16,
                    horizontal: isMobile ? 20 : 16,
                  ),
                ),
                child: Text(
                  'SUBSCRIBE',
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 12,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        
        // Subscription confirmation
        if (_isSubscribed)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Thank you for subscribing!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          
        const SizedBox(height: 20),
        
        // Social links - Bigger for mobile
        SizedBox(
          height: isMobile ? 44 : 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _buildSocialButton(FontAwesomeIcons.facebook, 'https://facebook.com', isMobile),
              _buildSocialButton(FontAwesomeIcons.twitter, 'https://twitter.com', isMobile),
              _buildSocialButton(FontAwesomeIcons.instagram, 'https://instagram.com', isMobile),
              _buildSocialButton(FontAwesomeIcons.linkedin, 'https://linkedin.com', isMobile),
              _buildSocialButton(FontAwesomeIcons.youtube, 'https://youtube.com', isMobile),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String url, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () => _launchURL(url),
        icon: FaIcon(
          icon, 
          color: Colors.white, 
          size: isMobile ? 20 : 18,
        ),
        tooltip: url.split('.com')[0].replaceAll('https://', ''),
        iconSize: isMobile ? 20 : 18,
        padding: EdgeInsets.all(isMobile ? 10 : 8),
        constraints: BoxConstraints(
          minWidth: isMobile ? 44 : 36,
          minHeight: isMobile ? 44 : 36,
        ),
      ),
    );
  }

  Widget _buildSolarAnimation() {
    return SizedBox(
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Sun
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.yellow,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.8),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),
          
          // Solar panel
          Positioned(
            bottom: 10,
            child: Container(
              width: 200,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blue[900],
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white.withOpacity(0.5)),
              ),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                itemCount: 24,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Container(
                    color: Colors.blue[800],
                  );
                },
              ),
            ),
          ),
          
          // Energy flow animation - Simplified to reduce resources
          ...List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                final delay = index * 0.2;
                final progress = (_animationController.value - delay) % 1.0;
                
                // Only show when progress is positive
                if (progress < 0) return const SizedBox();
                
                return Positioned(
                  bottom: 60 + progress * 35,
                  child: Opacity(
                    opacity: 1.0 - progress,
                    child: Container(
                      width: 4,
                      height: 10,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isMobile) {
    // Stack layout on mobile for better spacing
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Certifications - Make it wrap on smaller screens
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  _buildCertificationBadge('ISO Certified'),
                  _buildCertificationBadge('Green Business'),
                ],
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Terms & Privacy',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(height: 4),
              // Copyright with better text wrapping
              Text(
                '© ${DateTime.now().year} Solcare. All rights reserved.',
                style: const TextStyle(color: Colors.white70, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  '© ${DateTime.now().year} Solcare. All rights reserved.',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              // Certifications
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCertificationBadge('ISO Certified'),
                  _buildCertificationBadge('Green Business'),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Terms & Privacy',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          );
  }

  Widget _buildCertificationBadge(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}

// Custom clipper for wave pattern
class FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    
    // First wave
    final firstControlPoint = Offset(size.width / 4, 30);
    final firstEndPoint = Offset(size.width / 2, 20);
    path.quadraticBezierTo(
      firstControlPoint.dx, firstControlPoint.dy, 
      firstEndPoint.dx, firstEndPoint.dy
    );
    
    // Second wave
    final secondControlPoint = Offset(size.width * 3 / 4, 10);
    final secondEndPoint = Offset(size.width, 30);
    path.quadraticBezierTo(
      secondControlPoint.dx, secondControlPoint.dy, 
      secondEndPoint.dx, secondEndPoint.dy
    );
    
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
