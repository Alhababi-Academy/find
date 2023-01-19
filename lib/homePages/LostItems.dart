import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CirclePrograa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class LostItem extends StatefulWidget {
  const LostItem({super.key});

  @override
  State<LostItem> createState() => _LostItemState();
}

class _LostItemState extends State<LostItem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          StreamBuilder(
            stream: FindConfig.firestore!
                .collection("lostItemsByAdmin")
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
                                                      fontSize: 17,
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
                                  //     Padding(
                                  //       padding:
                                  //           const EdgeInsets.only(right: 15),
                                  //       child: ElevatedButton(
                                  //         onPressed: () {
                                  //           // picked(currentId);
                                  //         },
                                  //         child: const Padding(
                                  //           padding: EdgeInsets.all(8.0),
                                  //           child: Text("Found?"),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Padding(
                                  //       padding:
                                  //           const EdgeInsets.only(right: 15),
                                  //       child: ElevatedButton(
                                  //         onPressed: () {
                                  //           // picked(currentId);
                                  //         },
                                  //         child: const Padding(
                                  //           padding: EdgeInsets.all(8.0),
                                  //           child: Text("Picked?"),
                                  //         ),
                                  //       ),
                                  //     ),
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
