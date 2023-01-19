import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CirclePrograa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class pickedItemsBYTheUser extends StatefulWidget {
  const pickedItemsBYTheUser({super.key});

  @override
  State<pickedItemsBYTheUser> createState() => _pickedItemsBYTheUser();
}

class _pickedItemsBYTheUser extends State<pickedItemsBYTheUser> {
  String user = FindConfig.auth!.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    print(user);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: FindConfig.firestore!
                .collection("lostItemsByAdmin")
                .where("userCurrentUid", isEqualTo: user)
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
                        var currentId = snapshot.data!.docs[index].id;
                        var currentName =
                            snapshot.data!.docs[index]['ItemsTitle'];
                        var alreadyPicked =
                            snapshot.data!.docs[index]['alreadyPicked'];
                        var PickedBy = snapshot.data!.docs[index]['pickedBy'];
                        var pickedOn = snapshot.data!.docs[index]['pickedDate'];

                        return InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: const Color(0XFFE3E3E3)),
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  SizedBox(
                                    height: 120.0,
                                    width: 120.0,
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (contextd) => AlertDialog(
                                            content: Container(
                                              child: Image.network(
                                                snapshot.data!.docs[index]
                                                    ['thumbnailUrl'],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Image.network(snapshot
                                          .data!.docs[index]['thumbnailUrl']),
                                    ),
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
                                                Icons.smartphone,
                                                color: FindColors.primaryColor,
                                                size: 25,
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['ItemsTitle'],
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              const Icon(
                                                Icons.description,
                                                color: FindColors.primaryColor,
                                                size: 25,
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  snapshot.data!.docs[index]
                                                      ['longDescription'],
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  overflow: TextOverflow.fade,
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
                                                Icons.date_range,
                                                color: FindColors.primaryColor,
                                                size: 27,
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Text(
                                                snapshot.data!
                                                    .docs[index]['FoundDate']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                Icons.map,
                                                color: FindColors.primaryColor,
                                                size: 27,
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              Text(
                                                snapshot.data!.docs[index]
                                                    ['LocationFound'],
                                                style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          PickedBy != ""
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Picked By",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      snapshot.data!.docs[index]
                                                          ['pickedBy'],
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              : const Text(""),
                                          pickedOn != ""
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text(
                                                      "Picked On",
                                                      style: TextStyle(
                                                          fontSize: 15),
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      "${snapshot.data!.docs[index]['pickedDate']} at ${snapshot.data!.docs[index]['pickedTime']}",
                                                      style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                )
                                              : const Text("")
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Column(
                                  //   children: [
                                  //     alreadyPicked == false
                                  //         ? Container(
                                  //             margin: const EdgeInsets.all(8),
                                  //             child: ElevatedButton(
                                  //               onPressed: () async {
                                  //                 await picked(
                                  //                     context, currentId);
                                  //               },
                                  //               style: ElevatedButton.styleFrom(
                                  //                 backgroundColor:
                                  //                     FindColors.primaryColor,
                                  //               ),
                                  //               child: const Text("Picked?"),
                                  //             ),
                                  //           )
                                  //         : Container(
                                  //             margin: const EdgeInsets.all(10),
                                  //             padding: const EdgeInsets.all(10),
                                  //             decoration: BoxDecoration(
                                  //               color: Colors.grey,
                                  //               borderRadius:
                                  //                   BorderRadius.circular(5),
                                  //             ),
                                  //             child: const Text(
                                  //               "Picked",
                                  //               style: TextStyle(
                                  //                 color: Colors.white,
                                  //                 fontWeight: FontWeight.bold,
                                  //               ),
                                  //             ),
                                  //           ),
                                  //   ],
                                  // ),
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
      ),
    );
  }
}
