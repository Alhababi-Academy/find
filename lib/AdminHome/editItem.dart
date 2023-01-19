import 'package:find/DialogBox/errorDialog.dart';
import 'package:find/DialogBox/loadingDialog.dart';
import 'package:find/config/config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class editItem extends StatefulWidget {
  const editItem({super.key});

  @override
  _editItem createState() => _editItem();
}

class _editItem extends State<editItem> {
  User? user = FindConfig.auth!.currentUser;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController ItemsTitle = TextEditingController();
  TextEditingController longDescription = TextEditingController();
  TextEditingController LocationFound = TextEditingController();

  String? value;
  String itemID = '';
  String ItemName = '';

  @override
  Widget build(BuildContext context) {
    final editItem =
        ModalRoute.of(context)?.settings.arguments as Map<String, Object>;
    itemID = editItem['ItemID'].toString();
    ItemName = editItem['ItemName'].toString();
    setState(() {
      itemID;
    });
    gettingData();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "${ItemName}",
          style: const TextStyle(
              color: Colors.white, letterSpacing: 2, fontSize: 23),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Text(
                  "Edit Service",
                  style: TextStyle(
                      color: FindColors.primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 33,
                      letterSpacing: 1),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: ItemsTitle,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.smartphone,
                                  color: FindColors.primaryColor,
                                  size: 25,
                                ),
                                labelText: "Item Name"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: longDescription,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.description,
                                  color: FindColors.primaryColor,
                                  size: 25,
                                ),
                                labelText: "Item Description"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          child: TextField(
                            controller: LocationFound,
                            decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.map,
                                  color: FindColors.primaryColor,
                                  size: 27,
                                ),
                                labelText: "Location Found"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () => ItemsTitle.text.isNotEmpty &&
                            longDescription.text.isNotEmpty &&
                            LocationFound.text.isNotEmpty
                        ? updatingData()
                        : showDialog(
                            context: context,
                            builder: (c) =>
                                const errorDialog(message: "Can't be Empty")),
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(15)),
                    child: const Text(
                      "Save Data",
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Getting Data
  Future gettingData() async {
    String uid = user!.uid;

    var result = await FindConfig.firestore!
        .collection("lostItemsByAdmin")
        .doc(itemID)
        .get();

    if (result.exists) {
      ItemsTitle.text = result.data()!['ItemsTitle'];
      longDescription.text = result.data()!['longDescription'];
      LocationFound.text = result.data()!['LocationFound'].toString();
      value = result.data()!['PaymentMethod'];
    }
  }

  // For the drop down Items
  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),
      );

  Future updatingData() async {
    User? user = FindConfig.auth!.currentUser;
    String uid = user!.uid;

    showDialog(
        context: context,
        builder: (c) => const LoadingAlertDialog(
              message: "Saving Data...",
            ));

    await FindConfig.firestore!
        .collection("lostItemsByAdmin")
        .doc(itemID)
        .update({
      "ItemsTitle": ItemsTitle.text.trim(),
      "longDescription": longDescription.text.trim(),
      "LocationFound": LocationFound.text.trim(),
    }).then((value) {
      Navigator.pop(context);
      Navigator.of(context).pushReplacementNamed(FindScreens.AdminHome);
    });
  }
}
