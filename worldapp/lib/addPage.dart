import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/route_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:worldapp/starlist.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {

  //이미지, 위도, 경도, 평점, , , , 

  late TextEditingController snameController;
  late TextEditingController nationController;
  late TextEditingController menuController;
  late TextEditingController latiController;
  late TextEditingController longController;
  late TextEditingController textController;
  late TextEditingController foodController;

  int selectedOption = 1;

  late bool serviceEnabled;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  File? imgFile;

  late String sname;
  late String nation;
  late String menu;
  late double lati;
  late double long;
  late String text;
  late String food;

  late int dropDownValue;

  late List items;

  // late Position currentPosition;
  late bool canRun;

  late bool enabled;
  late int score;


  void getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
    print(position);
  }

  @override
  void initState() {
    super.initState();
    snameController = TextEditingController();
    nationController = TextEditingController();
    menuController = TextEditingController();
    latiController = TextEditingController();
    longController = TextEditingController();
    textController = TextEditingController();
    foodController = TextEditingController();

    sname = '';
    nation = '';
    menu = '';
    text = '';
    food = '';

    lati = 0;
    long = 0;

    canRun = false;
    //getLocationData();
    
    score = 0;

    enabled = false;
    enableCheck();
  }


  getLocationData() async {
    LocationPermission permission = await Geolocator.requestPermission();

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );
      print(position);
      print(position.latitude.toString());
      print(position.longitude.toString());
      
    setState(() {
    });
  }

  
  
  enableCheck() async {
    enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) {
	return Future.error('Location services are disabled.');
    print('실패안되안됌');
    } else {
      getLocationData();
      print('된다뇌된다.');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('세계 맛집 리스트 추가'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
            child: ElevatedButton(
              onPressed: () => insertAction(), 
              child: const Text('입력'),
            ),
          )
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: ElevatedButton(
                onPressed: () => getImageFromGallery(ImageSource.gallery), 
                child: const Text('갤러리')
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width/2,
                height: 200,
                color: Colors.grey[400],
                child: Center(
                  child: imageFile == null
                  ? const Text('이미지를 선택하세요.')
                  : Image.file(File(imageFile!.path)),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 130,
                    child: TextField(
                      controller: latiController,
                      decoration: const InputDecoration(
                        labelText: '위도',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                          )
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 130,
                    child: TextField(
                      controller: longController,
                      decoration: const InputDecoration(
                        labelText: '경도',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                          )
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () { 
                    getLocation();
                  }, 
                  icon: Icon(Icons.pin_drop)
                )
              ],
            ),

            //상호명 tf
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: snameController,
                decoration: const InputDecoration(
                  labelText: '상호명',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                    )
                  ),
                ),
              ),
            ),

            //국가명 tf
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: nationController,
                decoration: const InputDecoration(
                  labelText: '국가명',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                    )
                  ),
                ),
              ),
            ),

            //먹은 음식  tf
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: foodController,
                decoration: const InputDecoration(
                  labelText: '음식명',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                    )
                  ),
                ),
              ),
            ),

            //리뷰  tf
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                  labelText: '리뷰',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      style: BorderStyle.solid,
                    )
                  ),
                ),
                maxLength: 50,
              ),
            ),

            //평점
            // Padding(
            //   padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            //   child: Row(
            //     children: [
            //       const Text(
            //         '평점 : ',
            //         style: TextStyle(
            //           fontSize: 16
            //         ),
            //       ),
            //       //StarList()
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }

  //image
  getImageFromGallery(imageSource) async {
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if(pickedFile == null) {
      return null;
    } else {
      imageFile = XFile(pickedFile.path);
      imgFile = File(imageFile!.path);
      setState(() {});
    }
  }

  //추가
  insertAction() async {

    sname = snameController.text;
    nation = nationController.text;
    food = foodController.text;
    text = textController.text;
    lati = double.parse(latiController.text);
    long = double.parse(longController.text);
    
    String image = await preparingImage();

    if(sname.isEmpty || nation.isEmpty || food.isEmpty || text.isEmpty || image == null) {
      errorSnackBar();
    }


    FirebaseFirestore.instance
    .collection('lists')
    .add(
      {
        'sname' : sname,
        'world' : nation,
        'foods' : food,
        'latitude' : lati,
        'longitude' : long,
        'text' : text,
        'score' : 4,
        'image': image
      }
    );
    Get.back();
    setState(() {});
    
  }

  Future<String> preparingImage() async {
    final firebaseStorage = FirebaseStorage.instance
      .ref()
      .child('images')
      .child('${sname}.png');
    await firebaseStorage.putFile(imgFile!);

    String downloadURL = await firebaseStorage.getDownloadURL();
    return downloadURL;
  }

  errorSnackBar() {
    Get.snackbar(
      '경고', 
      '데이터를 입력하세요',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      colorText: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error
    );
  }
}