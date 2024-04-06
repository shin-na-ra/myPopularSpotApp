import 'dart:typed_data';

class Mylist{
  int? id;
  String sname;
  String sphone;
  Uint8List image;
  int longitude;
  int latitude;
  String text;

  Mylist ({
    this.id,
    required this.sname,
    required this.sphone,
    required this.image,
    required this.longitude,
    required this.latitude,
    required this.text
  });

  Mylist.fromMap(Map<String,dynamic> res)
    : id = res['id'],
      sname = res['sname'],
      sphone = res['sphone'],
      image = res['image'],
      longitude = res['longitude'],
      latitude = res['latitude'],
      text = res['text'];

}