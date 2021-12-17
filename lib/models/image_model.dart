class Image {
  String type;
  String id;
  String fileName;
  String fileType;
  int fileSize;
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      '_id': id,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
    };
  }
  Map toJson(){
    return {'type': type, 'id': id, 'fileName':fileName, 'fileSize': fileSize};
  }
  Image({
    required this.id,
    required this.type,
    this.fileName = '',
    this.fileType = '',
    this.fileSize = 0,
  });

  factory Image.fromJson(Map<String, dynamic> json){
    var a= Image(
      id: json['_id'] ?? '',
      type: json['type'] ?? 'images',
      fileName: json['fileName'] ?? '',
      fileType: json['mimetype'] ?? '',
      fileSize: json['fileSize'] ?? 0,
    );

    return a;
  }

  @override
  String toString() {
    return 'Image{type: $type, id: $id, fileName: $fileName, fileType: $fileType, fileSize: $fileSize}';
  }
}

