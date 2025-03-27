import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reel_model.dart';

class ReelsService {
  // In-memory data store for demo purposes
  static final List<ReelModel> _reels = [
    ReelModel(
      id: '1',
      userId: 'user1',
      username: 'SolarExpert',
      userAvatar: '', // Empty for placeholder generation
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      caption: 'See how we restored this 5-year-old system to peak performance! #SolarCare #Efficiency',
      likesCount: 142,
      commentsCount: 23,
      sharesCount: 15,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      hashtags: ['SolarCare', 'Efficiency'],
      audioName: 'Original Audio - SolarExpert',
    ),
    ReelModel(
      id: '2',
      userId: 'user2',
      username: 'GreenEnergy',
      userAvatar: '',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
      caption: 'Dust reducing your efficiency? Check out this quick cleaning hack! #SolarHacks #CleanEnergy',
      likesCount: 93,
      commentsCount: 17,
      sharesCount: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      hashtags: ['SolarHacks', 'CleanEnergy'],
      audioName: 'Clean Energy - Remix',
    ),
    ReelModel(
      id: '3',
      userId: 'user3',
      username: 'SolarPro',
      userAvatar: '',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
      caption: 'How to maintain your solar panels during rainy season #Maintenance #RainySeason',
      likesCount: 127,
      commentsCount: 19,
      sharesCount: 12,
      createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      hashtags: ['Maintenance', 'RainySeason'],
      audioName: 'Maintenance Tips - SolarPro',
    ),
    ReelModel(
      id: '4',
      userId: 'user4',
      username: 'EnergyEfficient',
      userAvatar: '',
      videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4',
      caption: 'Solar energy savings calculation - watch how much you can save! #Savings #GoGreen',
      likesCount: 232,
      commentsCount: 34,
      sharesCount: 28,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      hashtags: ['Savings', 'GoGreen'],
      audioName: 'Money Saving Tips - Original',
    ),
  ];

  static final Map<String, List<ReelComment>> _comments = {
    '1': [
      ReelComment(
        id: 'c1',
        userId: 'user5',
        username: 'SolarEnthusiast',
        userAvatar: '',
        comment: 'This is exactly what I needed for my home system!',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      ReelComment(
        id: 'c2',
        userId: 'user6',
        username: 'GreenLiving',
        userAvatar: '',
        comment: 'Great tips, trying this tomorrow!',
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
      ),
    ],
    '2': [
      ReelComment(
        id: 'c3',
        userId: 'user7',
        username: 'EcoFriendly',
        userAvatar: '',
        comment: 'I use this method all the time, works great!',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
    ]
  };

  static final Map<String, bool> _userLikes = {};
  static final Map<String, bool> _userFollows = {};

  // Get trending reels
  Future<List<ReelModel>> getTrendingReels() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return copy of reels sorted by likes count
    final sortedReels = List<ReelModel>.from(_reels);
    sortedReels.sort((a, b) => b.likesCount.compareTo(a.likesCount));
    return sortedReels;
  }

  // Get reels for home screen
  Future<List<ReelModel>> getReelsForHomeScreen() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Return copy of reels sorted by creation date
    final sortedReels = List<ReelModel>.from(_reels);
    sortedReels.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sortedReels;
  }

  // Get user's reels
  Future<List<ReelModel>> getUserReels(String userId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Filter reels by user ID
    return _reels.where((reel) => reel.userId == userId).toList();
  }

  // Upload a new reel
  Future<bool> uploadReel({
    required File videoFile,
    required String caption,
    required List<String> hashtags,
    required String audioName,
    required Function(double) progressCallback,
  }) async {
    try {
      // Simulate upload progress
      for (int i = 0; i <= 100; i += 10) {
        await Future.delayed(const Duration(milliseconds: 100));
        progressCallback(i / 100);
      }
      
      // Simulate prefs to store created reels
      final prefs = await SharedPreferences.getInstance();
      final uploadedReelsCount = prefs.getInt('uploaded_reels_count') ?? 0;
      
      // Create new reel
      final newReel = ReelModel(
        id: (uploadedReelsCount + 1).toString(),
        userId: 'current_user',
        username: 'CurrentUser',
        userAvatar: '',
        videoUrl: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
        caption: caption,
        likesCount: 0,
        commentsCount: 0,
        sharesCount: 0,
        createdAt: DateTime.now(),
        hashtags: hashtags,
        audioName: audioName,
      );
      
      // Add to in-memory list
      _reels.add(newReel);
      
      // Update preferences
      await prefs.setInt('uploaded_reels_count', uploadedReelsCount + 1);
      
      return true;
    } catch (e) {
      debugPrint('Error uploading reel: $e');
      return false;
    }
  }

  // Like/unlike a reel
  Future<bool> toggleLikeReel(String reelId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Get current like status and toggle it
    final currentStatus = _userLikes[reelId] ?? false;
    final newStatus = !currentStatus;
    _userLikes[reelId] = newStatus;
    
    // Find reel index
    final index = _reels.indexWhere((reel) => reel.id == reelId);
    if (index != -1) {
      // Update likes count
      final reel = _reels[index];
      final newLikesCount = reel.likesCount + (newStatus ? 1 : -1);
      _reels[index] = reel.copyWith(likesCount: newLikesCount);
    }
    
    return newStatus;
  }

  // Check if user liked a reel
  Future<bool> checkIfLiked(String reelId) async {
    return _userLikes[reelId] ?? false;
  }

  // Add a comment
  Future<bool> addComment(String reelId, String comment) async {
    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Create new comment
      final newComment = ReelComment(
        id: 'c${Random().nextInt(1000)}',
        userId: 'current_user',
        username: 'CurrentUser',
        userAvatar: '',
        comment: comment,
        createdAt: DateTime.now(),
      );
      
      // Add comment to map
      if (!_comments.containsKey(reelId)) {
        _comments[reelId] = [];
      }
      _comments[reelId]!.add(newComment);
      
      // Update comments count for reel
      final index = _reels.indexWhere((reel) => reel.id == reelId);
      if (index != -1) {
        final reel = _reels[index];
        _reels[index] = reel.copyWith(commentsCount: reel.commentsCount + 1);
      }
      
      return true;
    } catch (e) {
      return false;
    }
  }

  // Get comments
  Stream<List<ReelComment>> getComments(String reelId) async* {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Yield comments for this reel, or empty list if none
    yield _comments[reelId] ?? [];
  }

  // Report a reel
  Future<bool> reportReel(String reelId, String reason) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In a real app, this would send the report to a server
    debugPrint('Reported reel $reelId for reason: $reason');
    
    return true;
  }

  // Toggle follow user
  Future<bool> toggleFollowUser(String targetUserId) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Get current follow status and toggle it
    final currentStatus = _userFollows[targetUserId] ?? false;
    final newStatus = !currentStatus;
    _userFollows[targetUserId] = newStatus;
    
    return newStatus;
  }

  // Check if following
  Future<bool> checkIfFollowing(String targetUserId) async {
    return _userFollows[targetUserId] ?? false;
  }
}
