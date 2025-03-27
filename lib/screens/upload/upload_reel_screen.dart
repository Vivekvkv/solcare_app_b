import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/services.dart';

class UploadReelScreen extends StatefulWidget {
  const UploadReelScreen({Key? key}) : super(key: key);

  @override
  State<UploadReelScreen> createState() => _UploadReelScreenState();
}

class _UploadReelScreenState extends State<UploadReelScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _videoFile;
  VideoPlayerController? _videoController;
  bool _isUploading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
      
      if (video != null) {
        _videoController?.dispose();
        
        setState(() {
          _videoFile = video;
          _videoController = VideoPlayerController.file(File(video.path))
            ..initialize().then((_) {
              setState(() {});
              _videoController!.play();
              _videoController!.setLooping(true);
            });
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking video: $e')),
      );
    }
  }

  Future<void> _uploadVideo() async {
    if (_videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a video first')),
      );
      return;
    }

    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add a description')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // In a real app, upload the video to a server
      await Future.delayed(const Duration(seconds: 2));
      
      HapticFeedback.mediumImpact();
      
      // Return to previous screen
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Video uploaded successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading video: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload New Short'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video Preview
              Container(
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _videoFile == null
                    ? InkWell(
                        onTap: _pickVideo,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.video_call_rounded, size: 64),
                            SizedBox(height: 16),
                            Text('Tap to select a video'),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            if (_videoController != null &&
                                _videoController!.value.isInitialized)
                              AspectRatio(
                                aspectRatio: _videoController!.value.aspectRatio,
                                child: VideoPlayer(_videoController!),
                              ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    _videoController!.value.isPlaying
                                        ? _videoController!.pause()
                                        : _videoController!.play();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Icon(
                                    _videoController != null &&
                                            _videoController!.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
              
              // Change Video Button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Center(
                  child: TextButton.icon(
                    icon: const Icon(Icons.change_circle),
                    label: const Text('Change Video'),
                    onPressed: _pickVideo,
                  ),
                ),
              ),
              
              // Description Input
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  hintText: 'Add a description with #hashtags...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                maxLines: 3,
              ),
              
              // Upload Button
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: _isUploading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.upload),
                  label: Text(_isUploading ? 'Uploading...' : 'Upload Short'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isUploading ? null : _uploadVideo,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
