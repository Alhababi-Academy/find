import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/DialogBox/errorDialog.dart';
import 'package:find/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:image_downloader/image_downloader.dart';

class chatchat extends StatefulWidget {
  final currentChatID;
  final AdminIdName;

  chatchat({Key? key, required this.currentChatID, required this.AdminIdName})
      : super(key: key);

  @override
  _chatchat createState() => _chatchat(currentChatID, AdminIdName);
}

class _chatchat extends State<chatchat> {
  final currentChatID;
  final AdminIdName;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  var userName;
  var _textController = new TextEditingController();
  _chatchat(this.currentChatID, this.AdminIdName);
  @override
  void sendMessage(String msg) {
    if (msg == '') return;
    FindConfig.firestore!
        .collection("chats")
        .doc(currentChatID)
        .collection('messages')
        .add({
      'createdOn': FieldValue.serverTimestamp(),
      'uid': currentUserId,
      'friendName': AdminIdName,
      'msg': msg,
      'sentBy': FindConfig.sharedPreferences!.getString(FindConfig.userName),
    }).then((value) {
      _textController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FindConfig.firestore!
          .collection("chats")
          .doc(currentChatID)
          .collection('messages')
          .orderBy('createdOn', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }

        if (snapshot.hasData) {
          var data;
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(AdminIdName),
              trailing: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {},
                child: const Text(""),
              ),
              previousPageTitle: "Back",
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      reverse: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        data = snapshot.data!.docs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChatBubble(
                            clipper: ChatBubbleClipper6(
                              nipSize: 0,
                              radius: 0,
                              type: isSender(
                                data['uid'].toString(),
                              )
                                  ? BubbleType.sendBubble
                                  : BubbleType.receiverBubble,
                            ),
                            alignment: getAlignment(data['uid'].toString()),
                            margin: const EdgeInsets.only(top: 20),
                            backGroundColor: isSender(data['uid'].toString())
                                ? const Color(0xFF08C187)
                                : const Color(0xffE7E7ED),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      DefaultTextStyle(
                                        style: TextStyle(
                                          color: isSender(
                                            data['uid'].toString(),
                                          )
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                        child: data['msg'].length < 20
                                            ? Text(data['msg'])
                                            : Column(
                                                children: [
                                                  Image.network(
                                                    data['msg'],
                                                    width: 200,
                                                    height: 200,
                                                  ),
                                                ],
                                              ),

                                        // child: Text(
                                        //   data(
                                        //     ['msg'].length < 20
                                        //         ? Text(
                                        //             data['msg'],
                                        //           )
                                        //         : Image.network(
                                        //             data['msg'],
                                        //             width: 200,
                                        //             height: 200,
                                        //           ),
                                        //   ),
                                        // ),
                                      ),
                                    ],
                                  ),
                                  // snapshot.data!.docs[index]['msg'].length > 20
                                  //     ? ElevatedButton(
                                  //         onPressed: () {
                                  //           if (snapshot.data!
                                  //                   .docs[index]['msg'].length >
                                  //               20) {
                                  //             downloadImage(snapshot
                                  //                 .data!.docs[index]['msg']);
                                  //           }
                                  //         },
                                  //         child: const Text("Download Image"),
                                  //       )
                                  //     : const Text(""),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      DefaultTextStyle(
                                        style: TextStyle(
                                            fontSize: 10,
                                            color:
                                                isSender(data['uid'].toString())
                                                    ? Colors.white
                                                    : Colors.black),
                                        child: Text(
                                          data['createdOn'] == null
                                              ? DateTime.now().toString()
                                              : data['createdOn']
                                                  .toDate()
                                                  .toString(),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: CupertinoTextField(
                            controller: _textController,
                          ),
                        ),
                      ),
                      CupertinoButton(
                          child: const Icon(Icons.send_sharp),
                          onPressed: () => sendMessage(_textController.text))
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
