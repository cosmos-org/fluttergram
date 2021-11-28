class Image {
  String type;
  String id;
  String filename;

  Image({
    required this.id,
    required this.type,
    required this.filename,
  });
  factory Image.fromJson(Map<String, dynamic> json){
    return Image(
      id: json['_id'],
      type: json['type'],
      filename: json['fileName'],
    );}
// Map<String, dynamic> toJson() => {
//   "id": id,
//   "type": type,
//   "filename": filename
// };
}
