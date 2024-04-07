import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class InsertPage extends StatefulWidget {
  const InsertPage({super.key});

  @override
  State<InsertPage> createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {

  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addrController;
  late TextEditingController relationController;

  XFile? imageFile;
  final ImagePicker picker = ImagePicker();
  File? imgFile;

  late String name;
  late String phone;
  late String addr;
  late String relation;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    phoneController = TextEditingController();
    addrController = TextEditingController();
    relationController = TextEditingController();

    name = '';
    phone = '';
    addr = '';
    relation = '';
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주소록 추가'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                  child: ElevatedButton(
                    onPressed: () => getImageFromGallery(ImageSource.gallery), 
                    style : ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer
                    ),
                    child: const Text('이미지')
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width/2,
                  height: 200,
                  color: Colors.grey[300],
                  child: Center(
                    child: imageFile == null
                    ? const Text('이미지 없음')
                    :Image.file(File(imageFile!.path)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: '이름'
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: '전화번호'
                    ),
                    keyboardType: const TextInputType.numberWithOptions(signed: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                  child: TextField(
                    controller: addrController,
                    decoration: const InputDecoration(
                      labelText: '주소'
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 3, 20, 3),
                  child: TextField(
                    controller: relationController,
                    decoration: const InputDecoration(
                      labelText: '관계'
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ElevatedButton(
                    onPressed: () => insertAction(), 
                    style : ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                      foregroundColor: Theme.of(context).colorScheme.onSecondaryContainer
                    ),
                    child: const Text('입력')
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );  
  }

  getImageFromGallery(imageSource) async {
    final XFile? pickerFile = await picker.pickImage(source: imageSource);
    
    if(pickerFile == null){
      imageFile == null;
    } else {
      imageFile = XFile(pickerFile.path);
      imgFile = File(imageFile!.path);
      setState(() {});
    }
  }

  uploadImage(imgFile) async {
    final uri = Uri.parse("");
    var request = http.MultipartRequest('post',uri);
    request.fields['name'] = nameController.text;
    var pic = await http.MultipartFile.fromPath('image', imgFile!.path);
    request.files.add(pic);
    var response = await request.send();
    if(response.statusCode == 200) {
      print('success');
    } else {
      print('failure');
    }
  }

  insertAction() async {
    name = nameController.text;
    phone = phoneController.text;
    addr = addrController.text;
    relation = relationController.text;

    if(name.isNotEmpty && phone.isNotEmpty && addr.isNotEmpty && relation.isNotEmpty) {
      getInsertJSON();
    } else {
      alertSnackBar();
    }
  }

  getInsertJSON() async {
    var url = Uri.parse('http://localhost:8080/Flutter/JSP/insert_ourapp.jsp?name=$name&phone=$phone&address=$addr&relation=$relation&filename=$imageFile');
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(response.body);
    var result = dataConvertedJSON['results'];
    setState(() {});

    if(result == "OK") {
     // await uploadImage(imgFile);
      _showDialog();
    } else {
      errorSnackBar();
    }
  }


  alertSnackBar() {
    Get.snackbar(
      '경고', 
      '데이터를 입력하세요',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      colorText: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error
    );
  }  

  _showDialog() {
    Get.defaultDialog(
      title: '입력결과',
      middleText: '입력되었습니다.',
      barrierDismissible: false,
      backgroundColor: Colors.yellowAccent,
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

    errorSnackBar() {
    Get.snackbar(
      '경고', 
      '입력에 문제가 발생했습니다.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      colorText: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error
    );
  }  

}