import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/reel_model.dart';
import '../../services/reels_service.dart';
import 'comment_bottom_sheet.dart';

class FullScreenReelView extends StatefulWidget {
  final List<ReelModel> reels;
  final int initialIndex;

  const FullScreenReelView({
    Key? key,
    required this.reels,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<FullScreenReelView> createState() => _FullScreenReelViewState();
}

class _FullScreenReelViewState extends State<FullScreenReelView> {
  late PageController _pageController;
  late List<VideoPlayerController?> _controllers;
  final ReelsService _reelsService = ReelsService();
  int _currentIndex = 0;
  Map<String, bool> _isLiked = {};
  Map<String, bool> _isFollowing = {};
  bool _isDoubleTapping = false;
  
  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _controllers = List.generate(widget.reels.length, (_) => null);
    
    _initializeControllers();
    _checkLikeStatus();
    _checkFollowingStatus();
  }
  
  Future<void> _initializeControllers() async {
    // Initialize current, previous and next controllers
    for (int i = _currentIndex - 1; i <= _currentIndex + 1; i++) {
      if (i >= 0 && i < widget.reels.length) {
        await _initializeController(i);
      }
    }
    
    if (_controllers[_currentIndex] != null) {
      _controllers[_currentIndex]!.play();
    }
  }
  
  Future<void> _initializeController(int index) async {
    if (_controllers[index] == null) {
      final controller = VideoPlayerController.network(widget.reels[index].videoUrl);
      _controllers[index] = controller;
      
      try {
        await controller.initialize();
        await controller.setLooping(true);
        
        // Add a listener to update UI when video is playing
        controller.addListener(() {
          if (mounted) setState(() {});
        });
        
        if (mounted) setState(() {});
      } catch (e) {
        debugPrint("Error initializing video controller: $e");
      }
    }
  }
  
  Future<void> _disposeController(int index) async {
    if (_controllers[index] != null) {
      await _controllers[index]!.dispose();
      _controllers[index] = null;
    }
  }
  
  Future<void> _checkLikeStatus() async {
    for (int i = 0; i < widget.reels.length; i++) {
      final reel = widget.reels[i];
      final isLiked = await _reelsService.checkIfLiked(reel.id);
      if (mounted) {
        setState(() {
          _isLiked[reel.id] = isLiked;
        });
      }
    }
  }
  
  Future<void> _checkFollowingStatus() async {
    for (int i = 0; i < widget.reels.length; i++) {
      final reel = widget.reels[i];
      final isFollowing = await _reelsService.checkIfFollowing(reel.userId);
      if (mounted) {
        setState(() {
          _isFollowing[reel.userId] = isFollowing;
        });
      }
    }
  }
  
  void _onPageChanged(int index) async {
    final oldIndex = _currentIndex;
    setState(() {
      _currentIndex = index;
    });
    
    // Pause previous video
    if (_controllers[oldIndex] != null) {
      _controllers[oldIndex]!.pause();
    }
    
    // Play current video
    if (_controllers[index] != null) {
      _controllers[index]!.play();
    } else {
      await _initializeController(index);
      if (_controllers[index] != null) {
        _controllers[index]!.play();
      }
    }
    
    // Pre-load next and dispose previous controllers
    if (index > oldIndex) {
      // Going forward, initialize next and dispose far previous
      if (index + 1 < widget.reels.length) {
        _initializeController(index + 1);
      }
      if (oldIndex < index - 1) {
        _disposeController(oldIndex);
      }
    } else {
      // Going backward, initialize previous and dispose far next
      if (index - 1 >= 0) {
        _initializeController(index - 1);
      }
      if (oldIndex > index + 1) {
        _disposeController(oldIndex);
      }
    }
  }
  
  Future<void> _toggleLike(String reelId) async {
    final newStatus = await _reelsService.toggleLikeReel(reelId);
    if (mounted) {
      setState(() {
        _isLiked[reelId] = newStatus;
      });
    }
  }
  
  Future<void> _toggleFollow(String userId) async {
    final newStatus = await _reelsService.toggleFollowUser(userId);
    if (mounted) {
      setState(() {
        _isFollowing[userId] = newStatus;
      });
    }
  }
  
  void _showComments(BuildContext context, String reelId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CommentBottomSheet(reelId: reelId),
    );
  }
  
  void _showShareOptions(BuildContext context, ReelModel reel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Share Reel',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _shareOption(context, Icons.chat_bubble, 'Messages'),
                _shareOption(context, Icons.facebook, 'Facebook'),
                _shareOption(context, Icons.link, 'Copy Link'),
                _shareOption(context, Icons.more_horiz, 'More'),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
  
  Widget _shareOption(BuildContext context, IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[200],
          child: Icon(icon, color: Colors.black),
        ),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }
  
  void _showReportDialog(BuildContext context, String reelId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Report Reel'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Why are you reporting this reel?'),
            SizedBox(height: 16),
            _reportOption(context, reelId, 'Inappropriate content'),
            _reportOption(context, reelId, 'Spam'),
            _reportOption(context, reelId, 'Violence'),
            _reportOption(context, reelId, 'False information'),
            _reportOption(context, reelId, 'I just don\'t like it'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
  
  Widget _reportOption(BuildContext context, String reelId, String reason) {
    return InkWell(
      onTap: () {
        _reelsService.reportReel(reelId, reason);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Report submitted')),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(reason),
      ),
    );
  }
  
  void _handleDoubleTap(String reelId) {
    if (!_isDoubleTapping) {
      setState(() {
        _isDoubleTapping = true;
      });
      
      if (_isLiked[reelId] != true) {
        _toggleLike(reelId);
      }
      
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            _isDoubleTapping = false;
          });
        }
      });
    }
  }
  
  @override
  void dispose() {
    for (var controller in _controllers) {
      if (controller != null) {
        controller.dispose();
      }
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.reels.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final reel = widget.reels[index];
          final controller = _controllers[index];
          final bool isLiked = _isLiked[reel.id] ?? false;
          final bool isFollowing = _isFollowing[reel.userId] ?? false;
          
          return Stack(
            fit: StackFit.expand,
            children: [
              // Video
              GestureDetector(
                onDoubleTap: () => _handleDoubleTap(reel.id),
                child: controller != null && controller.value.isInitialized
                    ? VideoPlayer(controller)
                    : Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
              ),
              
              // Double tap like animation
              if (_isDoubleTapping && _isLiked[reel.id] == true)
                Center(
                  child: AnimatedOpacity(
                    opacity: _isDoubleTapping ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 100,
                    ),
                  ),
                ),
              
              // Controls and Info Overlay
              SafeArea(
                child: Column(
                  children: [
                    // Top bar with close button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                          IconButton(
                            icon: Icon(Icons.more_vert, color: Colors.white),
                            onPressed: () => _showReportDialog(context, reel.id),
                          ),
                        ],
                      ),
                    ),
                    
                    Spacer(),
                    
                    // Right side action buttons
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Left side (user info and caption)
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // User info
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 16,
                                      backgroundImage: CachedNetworkImageProvider(
                                        reel.userAvatar.isNotEmpty
                                            ? reel.userAvatar
                                            : 'https://ui-avatars.com/api/?name=${reel.username}',
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      reel.username,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _toggleFollow(reel.userId),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.white),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Text(
                                          isFollowing ? 'Following' : 'Follow',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                
                                SizedBox(height: 8),
                                
                                // Caption
                                Text(
                                  reel.caption,
                                  style: TextStyle(color: Colors.white),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                SizedBox(height: 8),
                                
                                // Hashtags
                                if (reel.hashtags.isNotEmpty)
                                  Text(
                                    reel.hashtags.map((tag) => '#$tag').join(' '),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                
                                SizedBox(height: 8),
                                
                                // Audio info
                                Row(
                                  children: [
                                    Icon(
                                      Icons.music_note,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                    SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        reel.audioName,
                                        style: TextStyle(color: Colors.white),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Right side (action buttons)
                          Column(
                            children: [
                              // Like button
                              IconButton(
                                icon: Icon(
                                  isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: isLiked ? Colors.red : Colors.white,
                                  size: 30,
                                ),
                                onPressed: () => _toggleLike(reel.id),
                              ),
                              Text(
                                '${reel.likesCount}',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 16),
                              
                              // Comment button
                              IconButton(
                                icon: Icon(
                                  Icons.chat_bubble_outline,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () => _showComments(context, reel.id),
                              ),
                              Text(
                                '${reel.commentsCount}',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 16),
                              
                              // Share button
                              IconButton(
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () => _showShareOptions(context, reel),
                              ),
                              Text(
                                'Share',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(height: 16),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Loading/buffering indicator
              if (controller != null && 
                  controller.value.isInitialized && 
                  controller.value.isBuffering)
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
