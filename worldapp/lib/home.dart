import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:worldapp/addPage.dart';
import 'package:worldapp/mapPage.dart';
import 'package:worldapp/model/lists.dart';
import 'package:worldapp/star_ratio.dart';
import 'package:worldapp/updatePage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('세계 맛집 리스트'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const AddPage());
            }, 
            icon: const Icon(Icons.add_outlined)
          )
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(

          //select
          stream: FirebaseFirestore.instance
                  .collection('lists')
                  .snapshots(),

          builder: (context, snapshot) {
            if(!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator(),);
            }
            final documents = snapshot.data!.docs;
            return ListView(
              children: documents.map((e) => _bulidItemWidget(e)).toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _bulidItemWidget(doc) {

    final list = List(
      sname : doc['sname'],
      world : doc['world'],
      latitude : doc['latitude'],
      longitude : doc['longitude'],
      text : doc['text'],
      image : doc['image'],
      score : doc['score'],
      foods : doc['foods'],
    );

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
                  doc.id,
                  doc['sname'],
                  doc['latitude'],
                  doc['longitude'],
                  doc['score'],
                  doc['foods'],
                  doc['text'],
                  doc['world'],
                  doc['image'],

                ]
              );
            },
          )
        ]
      ),
      endActionPane: ActionPane(
        motion: const BehindMotion(), 
        children: [
          SlidableAction(
            backgroundColor: Colors.red,
            icon: Icons.delete,
            label: '삭제',
            onPressed: (context) async {
              FirebaseFirestore.instance
                .collection('lists')
                .doc(doc.id)
                .delete();
              await deleteImage(list.sname);
            },
          )
        ]
      ),
      child: GestureDetector(
        onLongPress: () {
          Get.to(
            const ShowMapPage(),
            arguments: [
              doc['latitude'],
              doc['longitude'],
              doc['sname'],
            ]
          );
        },
        child: Card(
          
          child: ListTile(
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        list.image,
                        height: 150,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 0, 3),
                      child: Text('국가  : ${list.world}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 3, 0, 3),
                      child: Text('상호명 : ${list.sname}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 3, 0, 3),
                      child: Text('메뉴 : ${list.foods}'),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 3, 0, 3),
                      child: Row(
                        children: [
                          const Text('평점 : '),
                          IconTheme(
                            data: const IconThemeData(
                              color: Colors.amber,
                              size: 18
                            ), 
                            child: StarDisplay(value: list.score),
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

    // ---- function ----- 
  deleteImage(deleteCode) async {
    final firebaseStorage = FirebaseStorage.instance
      .ref()
      .child('images')
      .child('$deleteCode.png');
    await firebaseStorage.delete();
  }
}
