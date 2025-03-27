import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:solcare_app4/providers/reel_provider.dart';
import 'package:solcare_app4/screens/home/components/reel_card.dart';
import 'package:solcare_app4/screens/upload/upload_reel_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SolcareShortsSectionHeader extends StatelessWidget {
  final VoidCallback onUploadPressed;

  const SolcareShortsSectionHeader({
    Key? key,
    required this.onUploadPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Solcare Shorts',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton.icon(
            icon: const Icon(Icons.upload),
            label: const Text('Upload'),
            onPressed: onUploadPressed,
          ),
        ],
      ),
    );
  }
}

class SolcareShortsSection extends StatefulWidget {
  const SolcareShortsSection({Key? key}) : super(key: key);

  @override
  State<SolcareShortsSection> createState() => _SolcareShortsSectionState();
}

class _SolcareShortsSectionState extends State<SolcareShortsSection> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, bool> _visibleReels = {};
  int _currentActiveIndex = 0;
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _uploadReel() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const UploadReelScreen(),
      ),
    );
  }

  void _updateVisibility(int index, bool isVisible) {
    setState(() {
      _visibleReels[index] = isVisible;
      if (isVisible) {
        _currentActiveIndex = index;
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ReelProvider>(
      builder: (context, reelProvider, child) {
        if (reelProvider.isLoading && reelProvider.reels.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (reelProvider.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Failed to load shorts: ${reelProvider.errorMessage}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => reelProvider.refreshReels(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (reelProvider.reels.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Icon(Icons.video_library, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No shorts available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _uploadReel,
                    child: const Text('Upload Your First Short'),
                  ),
                ],
              ),
            ),
          );
        }

        // Calculate the appropriate item width to show 3-4 reels
        final screenWidth = MediaQuery.of(context).size.width;
        final itemWidth = screenWidth / 3.2; // Show approximately 3 reels at once

        return Column(
          children: [
            SolcareShortsSectionHeader(
              onUploadPressed: _uploadReel,
            ),
            SizedBox(
              height: 320, // Slightly increased height
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(
                  decelerationRate: ScrollDecelerationRate.fast,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                itemCount: reelProvider.reels.length,
                itemBuilder: (context, index) {
                  final reel = reelProvider.reels[index];
                  return VisibilityDetector(
                    key: Key('reel-$index'),
                    onVisibilityChanged: (info) {
                      // Auto-play when at least 60% visible, pause otherwise
                      if (info.visibleFraction > 0.6 && 
                          (_visibleReels[index] == null || !_visibleReels[index]!)) {
                        _updateVisibility(index, true);
                      } else if (info.visibleFraction < 0.3 && 
                                (_visibleReels[index] != null && _visibleReels[index]!)) {
                        _updateVisibility(index, false);
                      }
                    },
                    child: Container(
                      width: itemWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ReelCard(
                        reel: reel,
                        isActive: _visibleReels[index] ?? false,
                        gridFormat: true,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (reelProvider.isLoading)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              )
            else
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () => reelProvider.loadMoreReels(),
                  child: const Text('Load More Shorts'),
                ),
              ),
          ],
        );
      },
    );
  }
}
