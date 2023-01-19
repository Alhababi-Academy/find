import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/DialogBox/loadingDialog.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CirclePrograa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class feedbackPageAdmin extends StatefulWidget {
  const feedbackPageAdmin({super.key});

  @override
  State<feedbackPageAdmin> createState() => _feedbackPageAdmin();
}

class _feedbackPageAdmin extends State<feedbackPageAdmin> {
  User? user = FindConfig.auth!.currentUser;
  @override
  Widget build(BuildContext context) {
    String currentUser = user!.uid;
    return CustomScrollView(
      slivers: [
        StreamBuilder(
          stream: FindConfig.firestore!
              .collection("adminFeedback")
              // .where("status", isEqualTo: "Approved")
              .snapshots(),
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
                      var currentFeedback = snapshot.data!.docs[index].id;
                      String feedbackMade =
                          snapshot.data!.docs[index]["Date"].toString();

                      String feedbackstatus =
                          snapshot.data!.docs[index]['status'];
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0XFFE3E3E3)),
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
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Icon(
                                              Icons.pending,
                                              color: FindColors.primaryColor,
                                              size: 40,
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['status'],
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            const Icon(
                                              Icons.message,
                                              color: FindColors.primaryColor,
                                              size: 40,
                                            ),
                                            const SizedBox(
                                              width: 25,
                                            ),
                                            Expanded(
                                              child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['msg'],
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color:
                                                        FindColors.primaryColor,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                feedbackstatus == "Pending"
                                    ? Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              checkMarkFunction(
                                                  currentFeedback);
                                            },
                                            icon: const Icon(Icons.check),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              closeMarkFunction(
                                                  currentFeedback);
                                            },
                                            icon: const Icon(Icons.close),
                                          ),
                                        ],
                                      )
                                    : const Text("")
                                // Text(feedbackMade[])
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

  checkMarkFunction(String currentFeedback) async {
    showDialog(
      context: context,
      builder: (_) => const LoadingAlertDialog(
        message: "Saving...",
      ),
    );
    await FindConfig.firestore!
        .collection("adminFeedback")
        .doc(currentFeedback)
        .update({
      "status": "Approved",
      "dateIpproved": DateTime.now().isUtc,
    }).then((value) {
      Navigator.pop(context);
    });
  }

  closeMarkFunction(String currentFeedback) async {
    showDialog(
      context: context,
      builder: (_) => const LoadingAlertDialog(
        message: "Saving...",
      ),
    );
    await FindConfig.firestore!
        .collection("adminFeedback")
        .doc(currentFeedback)
        .update({
      "status": "Denied",
      "dateIpproved": DateTime.now().year,
    }).then((value) {
      Navigator.pop(context);
    });
  }
}
