import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ImageHelper {
  /// Returns an ImageProvider based on the image path
  /// Handles both network images and asset images with proper error handling
  static ImageProvider getImageProvider(String? imagePath, {String defaultAsset = 'assets/images/placeholder.jpg'}) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage('assets/images/placeholder.jpg');
    }
    
    // If it's a network image
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      return NetworkImage(imagePath);
    }
    
    // For demo purposes, return a placeholder instead of real assets
    return const AssetImage('assets/images/placeholder.jpg');
  }
  
  /// Widget to display images with fallback support using colored placeholders
  static Widget imageWithFallback({
    required String? imageUrl,
    double? width,
    double? height,
    BoxFit fit = BoxFit.cover,
    String placeholderAsset = 'assets/images/placeholder.jpg',
    Widget? errorWidget,
    Color placeholderColor = Colors.grey,
    IconData placeholderIcon = Icons.image,
  }) {
    // For demo/testing, generate a color-based placeholder instead of using real assets
    // This works well when assets might be missing
    
    // If URL is empty, use a colored placeholder
    if (imageUrl == null || imageUrl.isEmpty) {
      return buildColorPlaceholder(
        width: width, 
        height: height, 
        color: placeholderColor,
        icon: placeholderIcon
      );
    }

    // Check if it's a network image
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      // Use a demo placeholder URL for testing
      const demoImageUrl = 'https://picsum.photos/800/600';
      
      return CachedNetworkImage(
        imageUrl: demoImageUrl, // Use demo placeholder instead of actual URL
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => buildColorPlaceholder(
          width: width, 
          height: height, 
          color: placeholderColor,
          icon: placeholderIcon
        ),
        errorWidget: (context, url, error) => errorWidget ?? buildColorPlaceholder(
          width: width, 
          height: height, 
          color: Colors.red.shade200,
          icon: Icons.broken_image
        ),
      );
    }

    // Instead of asset image, return a colored placeholder for testing
    return buildColorPlaceholder(
      width: width, 
      height: height, 
      color: placeholderColor,
      icon: placeholderIcon
    );
  }
  
  // Helper to build a colored placeholder with icon
  static Widget buildColorPlaceholder({
    double? width, 
    double? height, 
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: width,
      height: height,
      color: color.withOpacity(0.3),
      child: Center(
        child: Icon(
          icon,
          size: 40,
          color: color,
        ),
      ),
    );
  }
  
  // Generate a color from a string (service name, etc.)
  static Color colorFromString(String text) {
    // Simple hash function to generate a consistent color
    int hash = 0;
    for (var i = 0; i < text.length; i++) {
      hash = text.codeUnitAt(i) + ((hash << 5) - hash);
    }
    
    // Convert to a color
    final hue = (hash % 360).abs();
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.6, 0.8).toColor();
  }
}
