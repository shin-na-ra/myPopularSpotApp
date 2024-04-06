import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/model/mylist.dart';
import 'package:myapp/vm/database_handler.dart';

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {

  late DatabaseHandler handler;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();

  late TextEditingController longController;
  late TextEditingController latiController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController textController;
  
  late String long;
  late String lati;
  late String name;
  late String phone;
  late String text;


  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();

    longController = TextEditingController();
    latiController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    textController = TextEditingController();

    long = '';
    lati = '';
    name = '';
    phone = '';
    text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('맛집 추가'),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: ElevatedButton(
                onPressed: () => getImageFromGallery(ImageSource.gallery),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                  minimumSize: const Size(100, 40)
                ), 
                child: const Text('갤러리'),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width/2,
              height: 200,
              color: Colors.grey[200],
              child: Center(
                child: imageFile == null
                ? const Text('이미지 없음')
                : Image.file(File(imageFile!.path)),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const SizedBox(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 20, 15),
                      child: Text(
                        '위치 : ',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                      child: Text(
                        '이름 : ',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                      child: Text(
                        '전화 : ',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 20, 20),
                      child: Text(
                        '평가 : ',
                        style: TextStyle(
                          fontSize: 18
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                          child: SizedBox(
                            width: 120,
                            child: TextField(
                              controller: latiController,
                              decoration: const InputDecoration(
                                labelText: '위도'
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: SizedBox(
                            width: 120,
                            child: TextField(
                              controller: longController,
                              decoration: const InputDecoration(
                                labelText: '경도'
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 260,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: TextField(
                        controller: nameController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 260,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: SizedBox(
                        width: 260,
                        child: TextField(
                          controller: textController,
                          keyboardType: TextInputType.text,
                          maxLength: 50,
                          maxLines: 8,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ],
            ),
            ElevatedButton(
                onPressed: () => insertAction(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                  foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
                  minimumSize: const Size(100, 40)
                ), 
                child: const Text('입력'),
              ),
          ],
        ),
      ),
    );
  }

  // 갤러리 선택
  getImageFromGallery(imageSource) async {
    final XFile? pickerFile = await picker.pickImage(source: imageSource);
    if(pickerFile == null){
      imageFile == null;
    } else {
      imageFile = XFile(pickerFile.path);
      setState(() {});
    }
  }

  // 입력 버튼 클릭 시
  insertAction() async { 
    lati = latiController.text;
    long = longController.text;
    name = nameController.text;
    phone = phoneController.text;
    text = textController.text;

    if(lati.isNotEmpty && long.isNotEmpty && name.isNotEmpty && phone.isNotEmpty
        && text.isNotEmpty && imageFile != null) {
      
      //File type을 byte type으로 변환
      File imageFile1 = File(imageFile!.path);
      Uint8List getImage = await imageFile1.readAsBytes();

      var list = Mylist(sname: name, sphone: phone, image: getImage, longitude: long, latitude: lati, text: text);
      await handler.insertList(list);
      _showDialog();

    } else {
      errorSnackBar();
    }
  }

  //데이터 빈칸 체크
  errorSnackBar() {
    Get.snackbar(
      '경고', 
      '데이터를 입력하세요.',
      backgroundColor: Colors.pink[100],
      colorText: Theme.of(context).colorScheme.onTertiaryContainer
    );
  }

  _showDialog() {
    Get.defaultDialog(
      title: '결과',
      middleText: '입력이 완료되었습니다.',
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      barrierDismissible: false,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
          }, 
          child: const Text('확인')
        )
      ]
    );
  }
}