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
  Map toJson(){
    return {'type': type, 'id': id, 'fileName':fileName, 'fileSize': fileSize};
  }

  factory Video.fromJson(Map<String, dynamic> json){
    var a= Video(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'video',
      fileName: json['fileName'] ?? '',
      fileType: json['mimetype'] ?? '',
      fileSize: json['fileSize'] ?? 0,
    );
    return a;
  }
}

