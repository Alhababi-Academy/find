import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/config/config.dart';
import 'package:find/homePages/customChat.dart';
import 'package:find/widgets/CirclePrograa.dart';
import 'package:find/widgets/CustomeTextField.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class showAdminsToChat extends StatefulWidget {
  const showAdminsToChat({super.key});

  @override
  State<showAdminsToChat> createState() => _showAdminsToChatState();
}

class _showAdminsToChatState extends State<showAdminsToChat> {
  TextEditingController mes = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Text(
            "Consult Admin",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: FindColors.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            child: StreamBuilder(
              stream: FindConfig.firestore!
                  .collection("users")
                  .where("type", isEqualTo: "admin")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(19),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var adminId = snapshot.data!.docs[index].id;
                            var adminName = snapshot.data!.docs[index]['name'];
                            return Row(
                              children: [
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
                                              Icons.smartphone,
                                              color: FindColors.primaryColor,
                                              size: 33,
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['name'],
                                                style: const TextStyle(
                                                    fontSize: 19,
                                                    fontWeight: FontWeight.bold,
                                                    color: FindColors
                                                        .primaryColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          // Navigator.of(context)
                                          //     .pushReplacementNamed(
                                          //         FindScreens.chat,
                                          //         arguments: {
                                          //       "adminAD": adminId,
                                          //       "name": FindConfig
                                          //           .sharedPreferences!
                                          //           .getString(
                                          //               FindConfig.userName),
                                          //     });
                                          Route route = MaterialPageRoute(
                                            builder: (_) => customChat(
                                              adminID: adminId,
                                              // adminName: FindConfig
                                              //     .sharedPreferences!
                                              //     .getString(
                                              //         FindConfig.userName),
                                              adminName: adminName,
                                            ),
                                          );
                                          Navigator.push(context, route);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                              right: 16, left: 16),
                                          child: Text("Chat"),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          sendingFeedback(adminName, adminId);
                                        },
                                        child: const Text("Feedback"),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> sendingFeedback(String adminName, String adminId) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          "Write Feedback",
          style: TextStyle(color: FindColors.primaryColor),
        ),
        content: Container(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              // CustomeTextField(
              //   iconData: Icons.message,
              //   hintText: "write Feedback",
              // ),
              TextField(
                controller: mes,
                keyboardType: TextInputType.multiline,
                minLines: 1, //Normal textInputField will be displayed
                maxLines: 5, // when user presses enter it will adapt to it
              ),
              ElevatedButton(
                onPressed: () async {
                  await uploadingFeeback(adminName, adminId);
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 16, left: 16),
                  child: Text("Send"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> uploadingFeeback(String adminName, String adminId) async {
    User? user = FindConfig.auth!.currentUser;
    String currentUser = user!.uid;
    print(mes);
    mes.text.isNotEmpty
        ? await FindConfig.firestore!
            .collection("users")
            .doc(currentUser)
            .collection("feedback")
            .add(
            {
              "Date": DateTime.now(),
              "userId": currentUser,
              "userName":
                  FindConfig.sharedPreferences!.getString(FindConfig.userName),
              "adminName": adminName,
              "adminID": adminId,
              "msg": mes.text.trim(),
              "status": "Pending",
            },
          ).then((value) async {
            await FindConfig.firestore!.collection("adminFeedback").add({
              "Date": DateTime.now(),
              "userId": currentUser,
              "userName":
                  FindConfig.sharedPreferences!.getString(FindConfig.userName),
              "adminName": adminName,
              "adminID": adminId,
              "msg": mes.text.trim(),
              "status": "Pending",
            });
            Navigator.pop(context);
            setState(() {
              mes.text = '';
            });
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Sent Successfully"),
            ));
          })
        : Text("");
  }
}
