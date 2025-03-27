import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import '../services/reels_service.dart';

class ReelUploadScreen extends StatefulWidget {
  const ReelUploadScreen({Key? key}) : super(key: key);

  @override
  State<ReelUploadScreen> createState() => _ReelUploadScreenState();
}

class _ReelUploadScreenState extends State<ReelUploadScreen> {
  final ReelsService _reelsService = ReelsService();
  final TextEditingController _captionController = TextEditingController();
  final TextEditingController _hashtagsController = TextEditingController();
  final TextEditingController _audioNameController = TextEditingController();
  
  File? _videoFile;
  VideoPlayerController? _videoController;
  bool _isUploading = false;
  double _uploadProgress = 0.0;
  
  @override
  void dispose() {
    _captionController.dispose();
    _hashtagsController.dispose();
    _audioNameController.dispose();
    _videoController?.dispose();
    super.dispose();
  }
  
  Future<void> _pickVideo(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(
      source: source,
      maxDuration: const Duration(minutes: 1), // Limit video to 1 minute
    );
    
    if (pickedFile != null) {
      setState(() {
        _videoFile = File(pickedFile.path);
      });
      
      _initializeVideoController();
    }
  }
  
  Future<void> _initializeVideoController() async {
    if (_videoFile != null) {
      _videoController?.dispose();
      
      final controller = VideoPlayerController.file(_videoFile!);
      _videoController = controller;
      
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      
      setState(() {});
    }
  }
  
  Future<void> _uploadReel() async {
    if (_videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a video first')),
      );
      return;
    }
    
    final caption = _captionController.text.trim();
    if (caption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add a caption')),
      );
      return;
    }
    
    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });
    
    // Process hashtags
    final hashtagText = _hashtagsController.text.trim();
    final hashtags = hashtagText.isNotEmpty
        ? hashtagText.split(' ').map((tag) => tag.startsWith('#') ? tag.substring(1) : tag).toList()
        : <String>[];
    
    final audioName = _audioNameController.text.trim().isNotEmpty
        ? _audioNameController.text.trim()
        : 'Original Audio';
    
    final success = await _reelsService.uploadReel(
      videoFile: _videoFile!,
      caption: caption,
      hashtags: hashtags,
      audioName: audioName,
      progressCallback: (progress) {
        setState(() {
          _uploadProgress = progress;
        });
      },
    );
    
    if (mounted) {
      setState(() {
        _isUploading = false;
      });
      
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reel uploaded successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload reel. Please try again.')),
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Reel'),
        actions: [
          if (_videoFile != null && !_isUploading)
            TextButton(
              onPressed: _uploadReel,
              child: Text(
                'Share',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Preview
            if (_videoFile == null)
              GestureDetector(
                onTap: () => _showVideoPicker(context),
                child: Container(
                  height: 400,
                  width: double.infinity,
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.video_library,
                        size: 60,
                        color: Colors.grey[600],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Tap to select a video',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else if (_videoController != null && _videoController!.value.isInitialized)
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    VideoPlayer(_videoController!),
                    Positioned(
                      bottom: 16,
                      right: 16,
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: () {
                          setState(() {
                            _videoController!.value.isPlaying
                                ? _videoController!.pause()
                                : _videoController!.play();
                          });
                        },
                        child: Icon(
                          _videoController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                height: 400,
                width: double.infinity,
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            
            // Upload Progress Indicator
            if (_isUploading)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Uploading reel... ${(_uploadProgress * 100).toStringAsFixed(0)}%',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    LinearProgressIndicator(value: _uploadProgress),
                  ],
                ),
              ),
            
            // Form Fields
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Caption',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _captionController,
                    decoration: InputDecoration(
                      hintText: 'Write a caption...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    enabled: !_isUploading,
                  ),
                  
                  SizedBox(height: 16),
                  
                  Text(
                    'Hashtags',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _hashtagsController,
                    decoration: InputDecoration(
                      hintText: 'Add hashtags (e.g. #health #fitness)',
                      border: OutlineInputBorder(),
                    ),
                    enabled: !_isUploading,
                  ),
                  
                  SizedBox(height: 16),
                  
                  Text(
                    'Audio Name (Optional)',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _audioNameController,
                    decoration: InputDecoration(
                      hintText: 'Add audio name or leave for "Original Audio"',
                      border: OutlineInputBorder(),
                    ),
                    enabled: !_isUploading,
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 32),
          ],
        ),
      ),
      floatingActionButton: _videoFile == null
          ? FloatingActionButton(
              onPressed: () => _showVideoPicker(context),
              child: Icon(Icons.video_library),
            )
          : null,
    );
  }
  
  void _showVideoPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.video_library),
                title: Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickVideo(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
