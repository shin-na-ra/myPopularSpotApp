import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:ourapp/view/insert.dart';
import 'package:ourapp/view/update.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List data;

  @override
  void initState() {
    super.initState();
    data = [];
    getJSONData();
    
  }

  getJSONData() async {
    var url = Uri.parse('http://localhost:8080/Flutter/JSP/select_ourapp.jsp');
    var response = await http.get(url);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['results'];

    data.addAll(result);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('주소록'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        actions: [
          IconButton(
            onPressed: () => Get.to(const InsertPage())!.then((value) => reload()), 
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: data.isEmpty
        ? const Center(
          //child: CircularProgressIndicator(),
        )
        : ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Slidable(
              startActionPane: ActionPane(
                motion: const BehindMotion(), 
                children: [
                  SlidableAction(
                    backgroundColor: Colors.green,
                    icon: Icons.edit,
                    label: '수정',
                    onPressed: (context) {
                      Get.to(
                        const UpdatePage(),
                        arguments: [
                          data[index]['seq'],
                          data[index]['name'],
                          data[index]['phone'],
                          data[index]['address'],
                          data[index]['relation'],
                          data[index]['filename'],
                        ]
                      )!.then((value) => reload());
                    },
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const BehindMotion(), 
                children: [
                  SlidableAction(
                    backgroundColor: Colors.red,
                    icon: Icons.delete,
                    label: '삭제',
                    onPressed: (context) => selectDelete(data[index]['seq']),
                  ),
                ]
              ),
              child: Card(
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text(
                          '이름 : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          ),
                        ),
                        Text(data[index]['name']),
                      ],
                    ),
              
                    Row(
                      children: [
                        const Text(
                          '전화번호 : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          ),
                        ),
                        Text(data[index]['phone']),
                      ],
                    ),
              
                    Row(
                      children: [
                        const Text(
                        '관계 : ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                          ),
                        ),
                      Text(data[index]['relation']),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  reload() {
    data.clear();
    getJSONData();
    setState(() {});
  }

  selectDelete(seq) {
    showCupertinoModalPopup(
      context: context, 
      builder: (context) => CupertinoActionSheet(
        title: const Text('알림'),
        message: const Text('선택한 항목을 삭제하시겠습니까?'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              getJSONDeleteData(seq);
            }, 
            child: const Text('삭제')
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  getJSONDeleteData(seq) async {
    if(seq.isNotEmpty){
      var url = Uri.parse('http://localhost:8080/Flutter/JSP/delete_ourapp.jsp?seq=$seq');
      var response = await http.get(url); // 얘는 데이터가 올때까지 기다리고 Bulider는 화면 그리고 있다.

      var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
      var result = await dataConvertedJSON['results'];

      setState(() {});

      if(result == 'OK') {
        _showDialog();
      } else {
        errorSnackBar();
      }
    } else {
      showInputText();
    }
  }

  _showDialog() {
    Get.defaultDialog(
      title: '결과',
      middleText: '삭제되었습니다.',
      barrierDismissible: false,
      backgroundColor: Colors.yellowAccent,
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back();
            reload();
          }, 
          child: const Text('확인')
        )
      ]
    );
  }

  errorSnackBar() {
    Get.snackbar(
      '경고', 
      '문제가 발생했습니다.',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
      colorText: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error
    );
  }  

  showInputText() {
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