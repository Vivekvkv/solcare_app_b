import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../models/reel_model.dart';

// Remove the ReelModel class definition since we're now importing it

class ReelSection extends StatefulWidget {
  final List<ReelModel> reels;

  const ReelSection({super.key, required this.reels});

  @override
  State<ReelSection> createState() => _ReelSectionState();
}

class _ReelSectionState extends State<ReelSection> {
  int _currentIndex = 0;
  late PageController _pageController;
  late List<VideoPlayerController?> _videoControllers;

  @override
  void initState() {
    super.initState();

    _pageController = PageController();

    // Initialize video controllers
    _videoControllers = widget.reels.map((reel) {
      if (reel.videoUrl.isNotEmpty) {
        return VideoPlayerController.networkUrl(
          Uri.parse(reel.videoUrl),
        )..initialize().then((_) {
            setState(() {});
          });
      }
      return null;
    }).toList();
  }

  @override
  void dispose() {
    _pageController.dispose();

    // Dispose of video controllers
    for (var controller in _videoControllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  void _playCurrentVideo(int index) {
    for (var i = 0; i < _videoControllers.length; i++) {
      if (i == index) {
        _videoControllers[i]?.play();
      } else {
        _videoControllers[i]?.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Header Section
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Solcare Shorts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to full reels screen
                },
                child: const Text('See All'),
              ),
            ],
          ),
        ),

        /// Reels Horizontal List
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.reels.length,
            itemBuilder: (context, index) {
              final reel = widget.reels[index];
              final controller = _videoControllers[index];

              return GestureDetector(
                onTap: () {
                  _currentIndex = index;
                  _playCurrentVideo(index);
                },
                child: Container(
                  width: 120,
                  margin: EdgeInsets.only(
                    left: index == 0 ? 16 : 8,
                    right: index == widget.reels.length - 1 ? 16 : 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Video or Placeholder
                      controller != null && controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: controller.value.aspectRatio,
                              child: VideoPlayer(controller),
                            )
                          : Container(color: Colors.grey[800]),

                      // Play Button Overlay
                      if (controller == null ||
                          !controller.value.isInitialized ||
                          !controller.value.isPlaying)
                        const Center(
                          child: Icon(
                            Icons.play_circle_outline,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),

                      // Reel Info
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.8),
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reel.username,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                reel.caption,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 10,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.favorite,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${reel.likesCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
