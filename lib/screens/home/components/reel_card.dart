import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:solcare_app4/models/reel_model.dart';
import 'package:solcare_app4/providers/reel_provider.dart';

class ReelCard extends StatefulWidget {
  final ReelModel reel;
  final bool isActive;
  final bool gridFormat; // New flag for grid layout
  
  const ReelCard({
    Key? key,
    required this.reel,
    required this.isActive,
    this.gridFormat = false, // Default to full-screen format
  }) : super(key: key);
  
  @override
  State<ReelCard> createState() => _ReelCardState();
}

class _ReelCardState extends State<ReelCard> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _hasError = false;
  bool _isLikeAnimating = false;
  
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }
  
  @override
  void didUpdateWidget(ReelCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Handle active state changes
    if (widget.isActive != oldWidget.isActive) {
      widget.isActive ? _playVideo() : _pauseVideo();
    }
  }
  
  Future<void> _initializeVideoPlayer() async {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.reel.videoUrl),
      );
      
      await _controller.initialize();
      await _controller.setLooping(true);
      
      // Only set initialized if widget is still mounted
      if (mounted) {
        setState(() {
          _isInitialized = true;
          
          // Auto-play if active
          if (widget.isActive) {
            _playVideo();
          }
        });
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
        });
      }
    }
  }
  
  void _playVideo() {
    if (_isInitialized && !_isPlaying) {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
    }
  }
  
  void _pauseVideo() {
    if (_isInitialized && _isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    }
  }
  
  void _togglePlayPause() {
    if (_isInitialized) {
      if (_isPlaying) {
        _pauseVideo();
      } else {
        _playVideo();
      }
    }
  }
  
  void _handleDoubleTap() {
    if (!_isLikeAnimating) {
      final reelProvider = Provider.of<ReelProvider>(context, listen: false);
      setState(() {
        _isLikeAnimating = true;
      });
      
      // Toggle like
      reelProvider.toggleLike(widget.reel.id);
      
      // Reset animation state after delay
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _isLikeAnimating = false;
          });
        }
      });
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    // Different layouts based on grid format flag
    return widget.gridFormat 
      ? _buildGridFormat() 
      : _buildFullScreenFormat();
  }
  
  Widget _buildGridFormat() {
    // Grid layout (thumbnail view)
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Thumbnail or first frame
            if (_isInitialized)
              VideoPlayer(_controller)
            else
              _hasError 
                ? Image.asset('assets/images/placeholder.jpg', fit: BoxFit.cover)
                : const Center(child: CircularProgressIndicator()),
                
            // Play button overlay
            if (!_isPlaying)
              const Center(
                child: Icon(Icons.play_circle_fill, color: Colors.white, size: 48),
              ),
                
            // Like count & username overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.reel.username,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.favorite, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.reel.likesCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 12),
                        const SizedBox(width: 4),
                        Text(
                          '${widget.reel.commentsCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
                
            // Clickable overlay
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _togglePlayPause,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFullScreenFormat() {
    // Full screen layout with all controls
    return VisibilityDetector(
      key: Key('reel-${widget.reel.id}'),
      onVisibilityChanged: (info) {
        // Play only when visible and active
        if (info.visibleFraction >= 0.8 && widget.isActive) {
          _playVideo();
        } else {
          _pauseVideo();
        }
      },
      child: GestureDetector(
        onDoubleTap: _handleDoubleTap,
        child: Container(
          color: Colors.black,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Video
              _isInitialized
                ? GestureDetector(
                    onTap: _togglePlayPause,
                    child: VideoPlayer(_controller),
                  )
                : _hasError
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, color: Colors.white, size: 48),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load video',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    
              // Play/pause overlay
              if (!_isPlaying && _isInitialized)
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 48),
                  ),
                ),
                
              // Double tap like animation
              if (_isLikeAnimating)
                Positioned.fill(
                  child: Center(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: _isLikeAnimating ? 1.0 : 0.0,
                      child: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 100,
                      ),
                    ),
                  ),
                ),
                
              // Info overlay
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Username and avatar
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.grey,
                            child: Text(
                              widget.reel.username.isNotEmpty ? 
                                widget.reel.username[0].toUpperCase() : 
                                '?',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            widget.reel.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          _FollowButton(reelId: widget.reel.id),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Caption
                      Text(
                        widget.reel.caption,
                        style: const TextStyle(color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      
                      // Hashtags
                      if (widget.reel.hashtags.isNotEmpty)
                        Wrap(
                          spacing: 4,
                          children: widget.reel.hashtags.map((tag) => 
                            Text(
                              '#$tag',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ).toList(),
                        ),
                        
                      const SizedBox(height: 12),
                      
                      // Stats
                      Row(
                        children: [
                          // Likes
                          _StatButton(
                            icon: Icons.favorite,
                            count: widget.reel.likesCount,
                            isActive: widget.reel.isLiked,
                            onTap: () {
                              Provider.of<ReelProvider>(context, listen: false)
                                .toggleLike(widget.reel.id);
                            },
                          ),
                          const SizedBox(width: 16),
                          
                          // Comments
                          _StatButton(
                            icon: Icons.chat_bubble_outline,
                            count: widget.reel.commentsCount,
                            onTap: () {
                              // Show comments bottom sheet
                            },
                          ),
                          const SizedBox(width: 16),
                          
                          // Share
                          _StatButton(
                            icon: Icons.send,
                            count: widget.reel.sharesCount,
                            onTap: () {
                              // Show share options
                            },
                          ),
                          const Spacer(),
                          
                          // More options
                          IconButton(
                            icon: const Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () {
                              // Show more options
                            },
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
      ),
    );
  }
}

class _StatButton extends StatelessWidget {
  final IconData icon;
  final int count;
  final bool isActive;
  final VoidCallback onTap;
  
  const _StatButton({
    required this.icon,
    required this.count,
    this.isActive = false,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: isActive ? Colors.red : Colors.white,
            size: 20,
          ),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _FollowButton extends StatelessWidget {
  final String reelId;
  
  const _FollowButton({required this.reelId});
  
  @override
  Widget build(BuildContext context) {
    final reelProvider = Provider.of<ReelProvider>(context);
    final index = reelProvider.reels.indexWhere((reel) => reel.id == reelId);
    
    if (index == -1) return const SizedBox();
    
    final isFollowing = reelProvider.reels[index].isFollowing;
    
    return GestureDetector(
      onTap: () {
        reelProvider.toggleFollow(reelId);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          isFollowing ? 'Following' : 'Follow',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
