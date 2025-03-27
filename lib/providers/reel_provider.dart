import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/reel_model.dart';

class ReelProvider with ChangeNotifier {
  List<ReelModel> _reels = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';
  
  List<ReelModel> get reels => _reels;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  
  ReelProvider() {
    _initReels();
  }
  
  Future<void> _initReels() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // In a real app, fetch from API
      await Future.delayed(const Duration(seconds: 1));
      
      // Use demo URLs for videos to avoid asset dependencies
      _reels = [
        ReelModel(
          id: '1',
          userId: 'user1',
          username: 'SolarExpert',
          userAvatar: '',  // Empty for placeholder generation
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
      ];
      
      _hasError = false;
      _errorMessage = '';
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to load reels: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> refreshReels() async {
    _reels = [];
    notifyListeners();
    
    return _initReels();
  }
  
  Future<void> loadMoreReels() async {
    if (_isLoading) return;
    
    _isLoading = true;
    notifyListeners();
    
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      // Use more demo content for additional reels
      final newReels = [
        ReelModel(
          id: '${_reels.length + 1}',
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
          id: '${_reels.length + 2}',
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
      
      _reels.addAll(newReels);
      _hasError = false;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to load more reels: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  void toggleLike(String reelId) {
    final index = _reels.indexWhere((reel) => reel.id == reelId);
    if (index != -1) {
      final reel = _reels[index];
      final liked = reel.likesCount + 1;
      
      // Provide haptic feedback
      HapticFeedback.mediumImpact();
      
      _reels[index] = reel.copyWith(likesCount: liked);
      notifyListeners();
    }
  }
  
  void toggleFollow(String reelId) {
    final index = _reels.indexWhere((reel) => reel.id == reelId);
    if (index != -1) {
      final reel = _reels[index];
      
      // Provide haptic feedback
      HapticFeedback.mediumImpact();
      
      _reels[index] = reel.copyWith(isFollowing: !reel.isFollowing);
      notifyListeners();
    }
  }
}
