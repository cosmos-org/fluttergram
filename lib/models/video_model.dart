class Video {
  String type;
  String id;
  String fileName;
  String fileType;
  int fileSize;
  Video({
    required this.id,
    required this.type,
    this.fileName = '',
    this.fileType = '',
    this.fileSize = 0,
  });

  factory Video.fromJson(Map<String, dynamic> json){
    var a= Video(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'video',
      fileName: json['fileName'] ?? '',
      fileType: json['mimetype'] ?? '',
      fileSize: json['fileSize'] ?? 0,
    );
    print('from json video');
    print(a);
    return a;
  }
}

