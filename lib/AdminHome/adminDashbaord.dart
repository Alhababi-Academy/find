import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/AdminHome/editItem.dart';
import 'package:find/DialogBox/loadingDialog.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CirclePrograa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class adminDashbaord extends StatefulWidget {
  @override
  _adminDashbaord createState() => _adminDashbaord();
}

class _adminDashbaord extends State<adminDashbaord> {
  Color color1 = const Color.fromARGB(128, 43, 16, 215);
  Color color2 = const Color.fromARGB(96, 1, 26, 134);
  @override
  bool get wantKeepAlive => true;
  final TextEditingController _itemsLostTitle = TextEditingController();
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final TextEditingController _itemLocationFound = TextEditingController();
  String? _setTime, _setDate;
  String? _hour, _minute, _time;
  String? dateTime;
  DateTime? selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  bool alreadyPicked = false;

  bool uploading = false;
  XFile? imageXFile;
  final _picker = ImagePicker();
  String uploadImageUrl = "";

  @override
  Widget build(BuildContext context) {
    return imageXFile == null
        ? getAdminHomeScreenBody()
        : displayAdminUploadFormScreen();
  }

  getAdminHomeScreenBody() {
    final User? user = FindConfig.auth?.currentUser;
    final uid = user!.uid;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          takeImage(context);
        },
        child: const Icon(Icons.add),
      ),
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
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      SizedBox(
                                        width: 120,
                                        height: 120,
                                        child: GestureDetector(
                                          onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (contextd) =>
                                                  AlertDialog(
                                                content: Container(
                                                  child: Image.network(
                                                    snapshot.data!.docs[index]
                                                        ['thumbnailUrl'],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                          child: Image.network(snapshot.data!
                                              .docs[index]['thumbnailUrl']),
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
                                                          fontSize: 19,
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
                                                        fontSize: 17,
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
                                                        fontSize: 17,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            editItem(currentId, currentName);
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              "Edit",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 15),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.red.withOpacity(0.8)),
                                          onPressed: () {
                                            deleteItem(currentId, currentName);
                                          },
                                          child: const Text(
                                            "Delete",
                                            style: TextStyle(fontSize: 18),
                                          ),
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
                      itemCount: snapshot.data!.docs.length,
                    );
            },
          ),
        ],
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            contentPadding: EdgeInsets.zero,
            title: SimpleDialogOption(
              padding: const EdgeInsets.all(0),
              child: IconButton(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.only(left: 5, top: 5),
                iconSize: 40,
                icon: const Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            titlePadding: const EdgeInsets.all(5),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.zero,
                onPressed: _getImageFromGallary,
                child: Container(
                  margin: const EdgeInsets.all(25),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: FindColors.primaryColor,
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.image,
                        color: Colors.white,
                        size: 60,
                      ),
                      Text(
                        "Gallery",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              SimpleDialogOption(
                padding: EdgeInsets.zero,
                onPressed: capturePhotoWithCamera,
                child: Container(
                  margin: const EdgeInsets.all(25),
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: FindColors.primaryColor,
                  ),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.camera,
                        color: Colors.white,
                        size: 60,
                      ),
                      Text(
                        "Camera",
                        style: TextStyle(color: Colors.white, fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
  }

  _getImageFromGallary() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      imageXFile;
    });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    imageXFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      imageXFile;
    });
  }

  Widget displayAdminUploadFormScreen() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(15)),
          child: ListView(
            children: [
              uploading ? circularProgress() : const Text(""),
              const Text(
                "Add Lost Items",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: FindColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    fontSize: 24),
              ),
              SizedBox(
                height: 230.0,
                width: MediaQuery.of(context).size.width * 0.5,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FileImage(File(imageXFile!.path)),
                              fit: BoxFit.fill)),
                    ),
                  ),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 12.0)),
              ListTile(
                leading: const Icon(
                  Icons.money,
                  color: FindColors.primaryColor,
                ),
                title: SizedBox(
                  width: 250.0,
                  child: TextField(
                    style: const TextStyle(color: FindColors.primaryColor),
                    controller: _itemsLostTitle,
                    decoration: const InputDecoration(
                      hintText: "Lost Item Title",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              // ListTile(
              //   leading: const Icon(
              //     Icons.payments,
              //     color: FindColors.primaryColor,
              //   ),
              //   title: SizedBox(
              //     width: 250.0,
              //     child: DropdownButton<String>(
              //       value: value,
              //       hint: const Text("Please select Payment method"),
              //       items: PaymentMehod.map(buildMenuItem).toList(),
              //       onChanged: (value) => setState(() => this.value = value),
              //     ),
              //   ),
              // ),
              // const Divider(
              //   color: Colors.black,
              // ),
              ListTile(
                leading: const Icon(
                  Icons.map_sharp,
                  color: FindColors.primaryColor,
                ),
                title: SizedBox(
                  width: 250.0,
                  child: TextField(
                    style: const TextStyle(color: FindColors.primaryColor),
                    controller: _itemLocationFound,
                    decoration: const InputDecoration(
                      hintText: "Location it was found",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              ListTile(
                leading: const Icon(
                  Icons.description,
                  color: FindColors.primaryColor,
                ),
                title: SizedBox(
                  width: 250.0,
                  child: TextField(
                    style: const TextStyle(color: FindColors.primaryColor),
                    controller: _descriptionTextEditingController,
                    decoration: const InputDecoration(
                      hintText: "Item Descriptions",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.black,
              ),
              ElevatedButton(
                onPressed: () {
                  _selectDate(context);
                },
                child: (const Text("Pick Date & Time")),
              ),
              _setDate != null
                  ? Text(
                      "${_setDate} " " ${_setTime}",
                      textAlign: TextAlign.center,
                    )
                  : const Text(""),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton.icon(
                  onPressed:
                      uploading ? null : () => uploadImageAndSaveItemInfo(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: FindColors.primaryColor,
                  ),
                  label: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Add Item",
                      style: TextStyle(fontSize: 25.0, color: Colors.white),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        print(selectedDate);
        _dateController.text = DateFormat.yMd().format(selectedDate!);
        print(_dateController.text = DateFormat.yMd().format(selectedDate!));
        _setDate = _dateController.text;
        _selectTime(context, _setDate);
      });
    }
  }

  Future<void> _selectTime(BuildContext context, _setDate) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = '$_hour:$_minute';
        _timeController.text = _time!;
        print(_timeController.text = _time!);
        _setTime = _timeController.text;
        // addOrderDetails(_setTime, _setDate);
      });
    }
  }

  clearFormInfo() {
    Navigator.of(context).pushReplacementNamed(FindScreens.adminDashbaord);
    setState(() {
      _descriptionTextEditingController.clear();
      _itemLocationFound.clear();
      _itemsLostTitle.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadingItemImage(imageXFile);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadingItemImage(mFileImage) async {
    String downloadUrl;
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    fStorage.Reference reference =
        fStorage.FirebaseStorage.instance.ref().child("Items").child(imageName);
    fStorage.UploadTask uploadTask = reference.putFile(File(imageXFile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      uploadImageUrl = url;
    });
    return uploadImageUrl;
  }

  saveItemInfo(String downloadUrl) async {
    final User? user = FindConfig.auth?.currentUser;
    final uid = user!.uid;
    final itemsRef =
        await FirebaseFirestore.instance.collection("lostItemsByAdmin").add({
      "ItemsTitle": _itemsLostTitle.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "thumbnailUrl": downloadUrl,
      "adminUid": uid,
      "LocationFound": _itemLocationFound.text.trim(),
      "FoundDate": _setDate,
      "FoundTime": _setTime,
      "DateUploaded": DateTime.now(),
      "pickedDate": "",
      "pickedTime": "",
      "pickedBy": "",
      "alreadyPicked": alreadyPicked,
    });

    setState(() {
      uploading = false;
      _descriptionTextEditingController.clear();
      _itemsLostTitle.clear();
      _itemLocationFound.clear();
    });

    Navigator.of(context).pushReplacementNamed(FindScreens.AdminHome);
  }

// Editing Item
  Future editItem(String currentId, String itemName) async {
    final User? user = FindConfig.auth?.currentUser;
    final uid = user!.uid;
    Navigator.of(context).pushNamed(
      FindScreens.editItem,
      arguments: {"ItemID": currentId, "ItemName": itemName},
    );
  }

  // Editing Item
  Future deleteItem(String currentId, String itemName) async {
    final User? user = FindConfig.auth?.currentUser;
    final uid = user!.uid;
    showDialog(
      context: context,
      builder: (c) => const LoadingAlertDialog(
        message: "Deleting Data...",
      ),
    );

    await FindConfig.firestore!
        .collection("lostItemsByAdmin")
        .doc(currentId)
        .delete()
        .then((value) {
      Navigator.pop(context);
    });
  }
}
