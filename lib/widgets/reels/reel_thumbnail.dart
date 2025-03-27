import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/reel_model.dart';

class ReelThumbnail extends StatelessWidget {
  final ReelModel reel;
  final VoidCallback onTap;

  const ReelThumbnail({
    Key? key,
    required this.reel,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width / 3 - 16,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video thumbnail
            CachedNetworkImage(
              imageUrl: _getVideoThumbnail(reel.videoUrl),
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                color: Colors.grey[900],
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Colors.grey[900],
                child: Icon(Icons.error, color: Colors.red),
              ),
            ),
            
            // Play button overlay
            Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                padding: const EdgeInsets.all(8),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            
            // Bottom info overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: CachedNetworkImageProvider(
                            reel.userAvatar.isNotEmpty
                                ? reel.userAvatar
                                : 'https://ui-avatars.com/api/?name=${reel.username}',
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            reel.username,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.white, size: 10),
                        const SizedBox(width: 2),
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
  }

  // This is a placeholder function. In a real app, you'd generate thumbnails server-side
  // or use a service like Firebase Video Thumbnail Generator
  String _getVideoThumbnail(String videoUrl) {
    // For simplicity, we're just returning the video URL.
    // In a real implementation, you'd replace this with actual thumbnail generation
    // or have a separate thumbnail URL in your ReelModel
    return videoUrl.replaceAll('.mp4', '.jpg');
  }
}
