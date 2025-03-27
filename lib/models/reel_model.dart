class ReelModel {
  final String id;
  final String userId;
  final String username;
  final String userAvatar;
  final String videoUrl;
  final String caption;
  final int likesCount;
  final int commentsCount;
  final int sharesCount;
  final DateTime createdAt;
  final List<String> hashtags;
  final String audioName;
  final bool isLiked;
  final bool isFollowing;

  ReelModel({
    required this.id,
    required this.userId,
    required this.username,
    required this.userAvatar,
    required this.videoUrl,
    required this.caption,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.createdAt,
    required this.hashtags,
    required this.audioName,
    this.isLiked = false,
    this.isFollowing = false,
  });

  ReelModel copyWith({
    String? id,
    String? userId,
    String? username,
    String? userAvatar,
    String? videoUrl,
    String? caption,
    int? likesCount,
    int? commentsCount,
    int? sharesCount,
    DateTime? createdAt,
    List<String>? hashtags,
    String? audioName,
    bool? isLiked,
    bool? isFollowing,
  }) {
    return ReelModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      userAvatar: userAvatar ?? this.userAvatar,
      videoUrl: videoUrl ?? this.videoUrl,
      caption: caption ?? this.caption,
      likesCount: likesCount ?? this.likesCount,
      commentsCount: commentsCount ?? this.commentsCount,
      sharesCount: sharesCount ?? this.sharesCount,
      createdAt: createdAt ?? this.createdAt,
      hashtags: hashtags ?? this.hashtags,
      audioName: audioName ?? this.audioName,
      isLiked: isLiked ?? this.isLiked,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

class ReelComment {
  final String id;
  final String userId;
  final String username;
  final String userAvatar;
  final String comment;
  final DateTime createdAt;

  ReelComment({
    required this.id,
    required this.userId,
    required this.username,
    required this.userAvatar,
    required this.comment,
    required this.createdAt,
  });
}
