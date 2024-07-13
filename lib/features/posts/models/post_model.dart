class PostModel {
  String id;
  String emotionName;
  String userId;
  String content;
  List<String>? imgs;
  int createdAt;

  PostModel({
    required this.id,
    required this.emotionName,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.imgs,
  });

  PostModel.fromJson(
      {required Map<String, dynamic> json, required String postId})
      : emotionName = json["emotionName"],
        content = json["content"],
        userId = json["userId"],
        createdAt = json["createdAt"],
        id = postId,
        imgs = (json['imgs'] as List<dynamic>).map((e) => e as String).toList();

  Map<String, dynamic> toJson() {
    return {
      "emotionName": emotionName,
      "content": content,
      "userId": userId,
      "createdAt": createdAt,
      "id": id,
      "imgs": imgs,
    };
  }

  PostModel copyWith({
    String? id,
    String? emotionName,
    String? userId,
    String? content,
    List<String>? imgs,
    int? createdAt,
  }) {
    return PostModel(
      id: id ?? this.id,
      emotionName: emotionName ?? this.emotionName,
      userId: userId ?? this.userId,
      content: content ?? this.content,
      imgs: imgs ?? this.imgs,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
