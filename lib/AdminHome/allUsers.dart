import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CirclePrograa.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class allUsers extends StatefulWidget {
  const allUsers({super.key});

  @override
  State<allUsers> createState() => _allUsersState();
}

class _allUsersState extends State<allUsers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: FindConfig.firestore!.collection("users").snapshots(),
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
                        return InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(7.0),
                            child: Container(
                              margin: const EdgeInsets.only(
                                right: 10,
                                left: 10,
                                top: 2,
                                bottom: 2,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: const Color(0XFFE3E3E3),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 12,
                                        left: 12,
                                        top: 5,
                                        bottom: 5,
                                      ),
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
                                                      ['name'],
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
                                                      ['email'],
                                                  style: const TextStyle(
                                                      fontSize: 14,
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
