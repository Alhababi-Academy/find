import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/AdminHome/editItem.dart';
import 'package:find/config/config.dart';
import 'package:find/widgets/CirclePrograa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as fStorage;
import 'package:intl/intl.dart';

class addItem extends StatefulWidget {
  final imageXfile;
  const addItem(XFile? imageXFile, {super.key, this.imageXfile});

  @override
  State<addItem> createState() => _addItemState(imageXfile);
}

class _addItemState extends State<addItem> {
  final imageXfile;
  bool uploading = false;
  // XFile? imageXFile;
  final _picker = ImagePicker();
  String uploadImageUrl = "";
  final TextEditingController _itemsLostTitle = TextEditingController();
  final TextEditingController _descriptionTextEditingController =
      TextEditingController();
  final TextEditingController _priceTextEditingController =
      TextEditingController();
  String? _setTime, _setDate;
  String? _hour, _minute, _time;
  String? dateTime;
  DateTime? selectedDate = DateTime.now();
  TimeOfDay selectedTime = const TimeOfDay(hour: 00, minute: 00);
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  _addItemState(this.imageXfile);
  bool s = false;
  @override
  Widget build(BuildContext context) {
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
                            image: FileImage(File(widget.imageXfile)),
                            fit: BoxFit.fill),
                      ),
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
              ListTile(
                leading: const Icon(
                  Icons.map_sharp,
                  color: FindColors.primaryColor,
                ),
                title: SizedBox(
                  width: 250.0,
                  child: TextField(
                    style: const TextStyle(color: FindColors.primaryColor),
                    controller: _descriptionTextEditingController,
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
              Text(
                "${_setDate} " " ${_setTime}",
                textAlign: TextAlign.center,
              ),
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
                      style: TextStyle(fontSize: 23.0, color: Colors.white),
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate!,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime.now());
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

  Future<Null> _selectTime(BuildContext context, _setDate) async {
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
      _priceTextEditingController.clear();
      _itemsLostTitle.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadingItemImage(widget.imageXfile);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadingItemImage(mFileImage) async {
    String downloadUrl;
    String imageName = DateTime.now().microsecondsSinceEpoch.toString();
    fStorage.Reference reference =
        fStorage.FirebaseStorage.instance.ref().child("Items").child(imageName);
    fStorage.UploadTask uploadTask =
        reference.putFile(File(widget.imageXfile!.path));
    fStorage.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    await taskSnapshot.ref.getDownloadURL().then((url) {
      uploadImageUrl = url;
    });
    return uploadImageUrl;
  }

  saveItemInfo(String downloadUrl) {
    final User? user = FindConfig.auth?.currentUser;
    final uid = user!.uid;
    final itemsRef = FirebaseFirestore.instance
        .collection("lostItemsByAdmin")
        .doc(uid)
        .collection("AllLostItems")
        .add({
      "ItemsTitle": _itemsLostTitle.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "publishedDate": DateTime.now(),
      "thumbnailUrl": downloadUrl,
      "adminUid": uid,
      "Date": _setDate,
      "Time": _setTime,
      // "serviceUid": productId.toString(),
    });

    setState(() {
      uploading = false;
      // productId = DateTime.now().microsecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _itemsLostTitle.clear();
      _priceTextEditingController.clear();
    });

    Navigator.of(context).pushReplacementNamed(FindScreens.AdminHome);
  }

  Future editingData(String currentId) async {
    final User? user = FindConfig.auth?.currentUser;
    final uid = user!.uid;
    // technicianApp.firestore!
    //     .collection("services")
    //     .doc(uid)
    //     .collection("AllServicesPerUser")
    //     .doc(currentId)
    //     .update({

    //     });
    // Route route = MaterialPageRoute(
    //     builder: (context) => editService(
    //           serviceId: currentId,
    //         ));
    // Navigator.push(context, route);
  }
}
