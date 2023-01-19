import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CirclePrograa.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';

class lostItemsAdmin extends StatefulWidget {
  const lostItemsAdmin({super.key});

  @override
  State<lostItemsAdmin> createState() => _lostItemsAdminState();
}

class _lostItemsAdminState extends State<lostItemsAdmin> {
  String? _setTime, _setDate;
  String? _hour, _minute, _time;
  String? dateTime;
  DateTime? selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
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
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30,
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
                                  Row(
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
                                                    Icons.smartphone,
                                                    color:
                                                        FindColors.primaryColor,
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
                                                    color:
                                                        FindColors.primaryColor,
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
                                                      overflow:
                                                          TextOverflow.fade,
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
                                                    color:
                                                        FindColors.primaryColor,
                                                    size: 27,
                                                  ),
                                                  const SizedBox(
                                                    width: 25,
                                                  ),
                                                  Text(
                                                    snapshot
                                                        .data!
                                                        .docs[index]
                                                            ['FoundDate']
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
                                                    color:
                                                        FindColors.primaryColor,
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
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Picked By",
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          snapshot.data!
                                                                  .docs[index]
                                                              ['pickedBy'],
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    )
                                                  : const Text(""),
                                              pickedOn != ""
                                                  ? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        const Text(
                                                          "Picked On",
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(
                                                          "${snapshot.data!.docs[index]['pickedDate']} at ${snapshot.data!.docs[index]['pickedTime']}",
                                                          style: const TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                      ],
                                                    )
                                                  : const Text("")
                                            ],
                                          ),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          alreadyPicked == false
                                              ? Container(
                                                  margin:
                                                      const EdgeInsets.all(8),
                                                  child: ElevatedButton(
                                                    onPressed: () async {
                                                      await picked(
                                                          context, currentId);
                                                    },
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          FindColors
                                                              .primaryColor,
                                                    ),
                                                    child: const Text(
                                                      "Picked?",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  margin:
                                                      const EdgeInsets.all(10),
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  child: const Text(
                                                    "Picked",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ],
                                  ),
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

  Future<void> picked(BuildContext context, currentId) async {
    var dateLast;
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        print(selectedDate);
        _dateController.text = DateFormat.yMd().format(selectedDate!);
        dateLast = DateFormat.yMd().format(selectedDate!);
      });
    }
    _selectTime(context, dateLast, currentId);
  }

  Future<void> _selectTime(BuildContext context, _setDate, currentId) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '$_hour:$_minute';
        _timeController.text = _time!;
        print(_timeController.text = _time!);
        _setTime = _timeController.text;
        // addOrderDetails(_setTime, _setDate);
      });
    }

    showDialog(
      context: context,
      builder: ((_) {
        return AlertDialog(
          title: Text(
            "Registered Users",
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          scrollable: true,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 300,
                height: 300,
                child: SingleChildScrollView(
                  child: StreamBuilder(
                    stream: FindConfig.firestore!
                        .collection("users")
                        .where("type", isEqualTo: "user")
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return !snapshot.hasData
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                var userCurrentNameFromDialog =
                                    snapshot.data!.docs[index]['name'];
                                var userCurrentUid =
                                    snapshot.data!.docs[index].id;
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                  margin: const EdgeInsets.all(10),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 8, left: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            snapshot.data!.docs[index]['name'],
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await savingData(
                                              _setDate,
                                              _setTime,
                                              currentId,
                                              userCurrentNameFromDialog,
                                              userCurrentUid,
                                            );
                                            print(
                                                "This is the savingDate $currentId");
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.blue),
                                          child: const Text("Received"),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.docs.length,
                            );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      }),
    );
  }

  Future<void> savingData(setDate, setTime, String currentId,
      String userCurrentNameFromDialog, String userCurrentUid) async {
    print("This is the savingDate $currentId");
    setTime ??= "noTimePciked";
    await FindConfig.firestore!
        .collection("lostItemsByAdmin")
        .doc(currentId)
        .update({
      "alreadyPicked": true,
      "pickedBy": userCurrentNameFromDialog,
      "pickedDate": setDate,
      "pickedTime": setTime,
      "userCurrentUid": userCurrentUid,
    }).then((value) {
      Navigator.pop(context);
    });
  }
}
