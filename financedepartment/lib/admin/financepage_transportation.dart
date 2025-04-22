import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Transportation extends StatefulWidget {
  const Transportation({super.key});

  @override
  State<Transportation> createState() => _TransportationState();
}

class _TransportationState extends State<Transportation> {
  final TextEditingController addRootNumber = TextEditingController();
  final TextEditingController addArea = TextEditingController();
  final List<Map<String, dynamic>> roots = [];

  @override
  void initState() {
    super.initState();
    fetchExistingRoots();
  }

  // Fetch roots from Firestore
  Future<void> fetchExistingRoots() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('transportationRoots')
          .get();

      setState(() {
        roots.clear();
        for (var doc in snapshot.docs) {
          roots.add({
            'rootNumber': doc['rootNumber'],
            'area': doc['area'],
          });
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching roots: $e')),
      );
    }
  }

  // Add a new root to Firestore
  Future<void> addRootToFirestore(String rootNumber, String area) async {
    try {
      await FirebaseFirestore.instance.collection('transportationRoots').add({
        'rootNumber': rootNumber,
        'area': area,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Root added successfully!')),
      );
      fetchExistingRoots(); // Refresh the list after adding
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding root: $e')),
      );
    }
  }

  Future openAddDialog() => showDialog(
    context: context,
    builder: (context) {
      final _formKey = GlobalKey<FormState>();
      return AlertDialog(backgroundColor: Colors.white,
        actions: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Enter Root, Area",
                    style: TextStyle(

                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: addRootNumber,
                    decoration: InputDecoration(
                      labelText: 'Root Number',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.place_outlined,
                        color: Colors.blueAccent,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: TextField(
                    controller: addArea,
                    decoration: InputDecoration(
                      labelText: 'Add Area',
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        color: Colors.blueAccent,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(
                          color: Colors.black,
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Card(
                          elevation: 0.5,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text("Cancel",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            addRootToFirestore(
                                addRootNumber.text, addArea.text);
                            addRootNumber.clear();
                            addArea.clear();
                            Navigator.of(context).pop();
                          }
                        },
                        child: Card(
                          elevation: 4,
                          color: Colors.greenAccent,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text("Save",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "Transportation",
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text("Roots List",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
          ),
          Expanded(
            child: ListView(
              children: [
                if (roots.isEmpty)
                  Center(child: Text('No roots available. Add new ones!')),
                if (roots.isNotEmpty)
                  ...roots.map((root) => Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      color: Colors.white,
                      elevation: 8,
                      shadowColor:  Colors.blueAccent.withOpacity(0.5),
                      child: ListTile(
                        title: Column(
                          children: [
                            Center(child: Text('Root: ${root["rootNumber"]}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
                         Divider(color: Colors.orangeAccent,thickness: 2,),
                          ],
                        ),
                        subtitle: Text('Area: ${root["area"]}',style: TextStyle(fontSize: 20),),
                      ),
                    ),
                  )),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: InkWell(
        onTap: () => openAddDialog(),
        child: Card(
          color: Colors.orangeAccent,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Add",
                style: TextStyle( fontSize: 20,color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
