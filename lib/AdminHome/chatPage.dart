import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/AdminHome/chatchat.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CirclePrograa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class chatTech extends StatefulWidget {
  chatTech({Key? key}) : super(key: key);

  @override
  _chatTech createState() => _chatTech();
}

class _chatTech extends State<chatTech> {
  final currentAdminId = FirebaseAuth.instance.currentUser?.uid;

  CollectionReference chats = FirebaseFirestore.instance.collection('chats');

  var chatDocId;
  var _textController = new TextEditingController();
  var keyss;
  var values;
  var key;
  var gettingUserID;
  var currentChatID;

  @override
  void initState() {
    super.initState();
    checkUser();
    print("This is the current ID $currentAdminId");
  }

  void checkUser() async {
    await FirebaseFirestore.instance.collection('chats').get().then(
      (QuerySnapshot querySnapshot) async {
        if (querySnapshot.docs.isNotEmpty) {
          var gettingData = querySnapshot.docs;
          for (var element in gettingData) {
            print(element['users']['UserID']);
            gettingUserID = element['users']['adminId'];
            setState(() {
              gettingUserID = element['users']['adminId'];
            });
          }
        } else {
          print("It's Empty");
        }
      },
    ).catchError((erorr) {
      print("Error Happend");
    });
  }

  void sendMessage(String msg) {
    if (msg == '') return;
    chats.doc(chatDocId).collection('messages').add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentAdminId,
      // 'friendName': friendName,
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
  }

  bool isSender(String friend) {
    return currentAdminId == currentAdminId;
  }

  Alignment getAlignment(friend) {
    if (currentAdminId == currentAdminId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Text(gettingUserID.toString()),
    // );
    return CustomScrollView(
      slivers: [
        StreamBuilder(
          stream: chats.where("adminID", isEqualTo: currentAdminId).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return !snapshot.hasData
                ? SliverToBoxAdapter(
                    child: Center(
                      child: circularProgress(),
                    ),
                  )
                : SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      currentChatID = snapshot.data!.docs[index].id;
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Color(0XFFE3E3E3)),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 10.0,
                                ),
                                const SizedBox(
                                  height: 85.0,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Icon(
                                              Icons.person,
                                              color: FindColors.primaryColor,
                                              size: 40,
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['userName'],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: IconButton(
                                      onPressed: () {
                                        currentChatID =
                                            snapshot.data!.docs[index].id;
                                        Route route = MaterialPageRoute(
                                          builder: (c) => chatchat(
                                            currentChatID: currentChatID,
                                            AdminIdName: snapshot
                                                .data!.docs[index]['userName'],
                                          ),
                                        );
                                        Navigator.push(context, route);
                                      },
                                      icon: const Icon(
                                        Icons.message,
                                        size: 30,
                                        color: FindColors.primaryColor,
                                      )),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: snapshot.data!.docs.length,
                  );
          },
        ),
      ],
    );
  }
}
