import 'community_model.dart';

class Posts {
  String? fileType;
  String? fileName;
  String? createdAt;
  String? privacy;
  String? caption;
  int? id;
  int? postId;
  int? userId;
  Community? community;

  Posts(
      {this.fileType,
      this.fileName,
      this.createdAt,
      this.privacy,
      this.caption,
      this.id,
      this.postId,
      this.userId,
      this.community});

  Posts.fromJson(Map<String, dynamic> json) {
    fileType = json['file_type'];
    fileName = json['file_name'];
    createdAt = json['created_at'];
    privacy = json['privacy'];
    caption = json['caption'];
    id = json['id'];
    postId = json['post_id'];
    userId = json['user_id'];
    community = Community.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['file_type'] = fileType;
    data['file_name'] = fileName;
    data['created_at'] = createdAt;
    data['privacy'] = privacy;
    data['caption'] = caption;
    data['id'] = id;
    data['post_id'] = postId;
    data['user_id'] = userId;
    return data;
  }
}
