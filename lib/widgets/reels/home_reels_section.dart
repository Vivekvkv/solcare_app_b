import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../models/reel_model.dart';
import '../../services/reels_service.dart';
import '../../screens/reel_upload_screen.dart';
import 'full_screen_reel_view.dart';
import 'reel_thumbnail.dart';

class HomeReelsSection extends StatefulWidget {
  const HomeReelsSection({Key? key}) : super(key: key);

  @override
  State<HomeReelsSection> createState() => _HomeReelsSectionState();
}

class _HomeReelsSectionState extends State<HomeReelsSection> {
  final ReelsService _reelsService = ReelsService();
  List<ReelModel> _reels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReels();
  }

  Future<void> _loadReels() async {
    try {
      final reels = await _reelsService.getReelsForHomeScreen();
      if (mounted) {
        setState(() {
          _reels = reels;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _openFullScreenReels(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenReelView(
          reels: _reels,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  void _navigateToUploadScreen() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => const ReelUploadScreen(),
      ),
    ).then((_) => _loadReels()); // Refresh reels when returning from upload
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        height: 220,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_reels.isEmpty) {
      return SizedBox(
        height: 220,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('No shorts available at the moment'),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _navigateToUploadScreen,
                child: Text('Upload Your First Short'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
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
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: _navigateToUploadScreen,
                    tooltip: 'Upload new short',
                  ),
                  TextButton(
                    onPressed: () {
                      _openFullScreenReels(0);
                    },
                    child: const Text('See All'),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _reels.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  left: index == 0 ? 16.0 : 8.0,
                  right: index == _reels.length - 1 ? 16.0 : 8.0,
                ),
                child: ReelThumbnail(
                  reel: _reels[index],
                  onTap: () => _openFullScreenReels(index),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
