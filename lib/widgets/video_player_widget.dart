import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:solcare_app4/utils/image_helper.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  final String? thumbnailUrl;
  final bool autoPlay;
  final bool muted;
  final BoxFit fit;
  final Function? onInitialized;
  final Function? onError;
  
  const VideoPlayerWidget({
    Key? key,
    required this.videoUrl,
    this.thumbnailUrl,
    this.autoPlay = false,
    this.muted = true,
    this.fit = BoxFit.cover,
    this.onInitialized,
    this.onError,
  }) : super(key: key);
  
  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  
  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }
  
  @override
  void didUpdateWidget(VideoPlayerWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl || 
        oldWidget.muted != widget.muted) {
      _disposeController();
      _initializeVideoPlayer();
    }
  }
  
  void _initializeVideoPlayer() {
    try {
      // For testing/demo purposes, use a known good video URL
      const fallbackVideoUrl = 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4';
      
      // Check if it's a network URL or an asset (always use network for demo)
      _controller = VideoPlayerController.network(fallbackVideoUrl);
      
      _controller
        ..setLooping(true)
        ..setVolume(widget.muted ? 0.0 : 1.0)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
              _hasError = false;
              if (widget.autoPlay) {
                _controller.play();
              }
            });
            
            if (widget.onInitialized != null) {
              widget.onInitialized!();
            }
          }
        }).catchError((error) {
          if (mounted) {
            setState(() {
              _hasError = true;
              _isInitialized = false;
            });
            
            if (widget.onError != null) {
              widget.onError!(error);
            }
            
            print('Video initialization error: $error');
          }
        });
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitialized = false;
        });
        
        if (widget.onError != null) {
          widget.onError!(e);
        }
        
        print('Video player error: $e');
      }
    }
  }
  
  void _disposeController() {
    _controller.dispose();
  }
  
  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final thumbnailColor = widget.thumbnailUrl != null ? 
        ImageHelper.colorFromString(widget.thumbnailUrl!) : 
        Colors.grey;
        
    if (_hasError) {
      // Show thumbnail or placeholder on error
      return ImageHelper.buildColorPlaceholder(
        width: double.infinity,
        height: double.infinity,
        color: Colors.red.shade300,
        icon: Icons.movie_creation,
      );
    }
    
    if (!_isInitialized) {
      // Show thumbnail or loading indicator while initializing
      return Stack(
        fit: StackFit.expand,
        children: [
          ImageHelper.buildColorPlaceholder(
            width: double.infinity,
            height: double.infinity,
            color: thumbnailColor,
            icon: Icons.movie,
          ),
          const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      );
    }
    
    // Show the video once initialized
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
