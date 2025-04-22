import 'package:financedepartment/admin/bscitfeesnotpaid.dart';
import 'package:flutter/material.dart';
class bscitfees extends StatefulWidget {
  const bscitfees({super.key});
  @override
  State<bscitfees> createState() => _bscitfeesState();
}
class _bscitfeesState extends State<bscitfees>  {
  final TextEditingController _changevalue = TextEditingController();
  int sem_1 = 35000;
  int sem_2 = 24500;
  int sem_3 = 24500;
  int sem_4 = 24500;
  int sem_5 = 24500;
  int sem_6 = 28000;
  Future<void> changeValueSem1() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Enter changes Regarding Fees",
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20, // Adjusted font size to fit constraints
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _changevalue,
                        decoration: InputDecoration(
                          labelText: 'Fees',
                          labelStyle: TextStyle(
                            fontFamily: 'Playfair',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Card(color: Colors.redAccent,
                        child: Text(
                          "  Cancel  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_changevalue.text.isNotEmpty) {
                          final value = int.tryParse(_changevalue.text);
                          if (value != null) {
                            setState(() {
                              sem_1 = value;
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid input. Please enter a valid number.'),
                              ),
                            );
                          }
                        }
                      },
                      child: Card(color: Colors.greenAccent,
                        child: Text(
                          "  Save  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> changeValueSem2() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Enter changes Regarding Fees",
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20, // Adjusted font size to fit constraints
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _changevalue,
                        decoration: InputDecoration(
                          labelText: 'Fees',
                          labelStyle: TextStyle(
                            fontFamily: 'Playfair',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Card(color: Colors.redAccent,
                        child: Text(
                          "  Cancel  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_changevalue.text.isNotEmpty) {
                          final value = int.tryParse(_changevalue.text);
                          if (value != null) {
                            setState(() {
                              sem_2 = value;
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid input. Please enter a valid number.'),
                              ),
                            );
                          }
                        }
                      },
                      child: Card(color: Colors.greenAccent,
                        child: Text(
                          "  Save  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> changeValueSem3() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Enter changes Regarding Fees",
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20, // Adjusted font size to fit constraints
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _changevalue,
                        decoration: InputDecoration(
                          labelText: 'Fees',
                          labelStyle: TextStyle(
                            fontFamily: 'Playfair',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Card(color: Colors.redAccent,
                        child: Text(
                          "  Cancel  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_changevalue.text.isNotEmpty) {
                          final value = int.tryParse(_changevalue.text);
                          if (value != null) {
                            setState(() {
                              sem_3 = value;
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid input. Please enter a valid number.'),
                              ),
                            );
                          }
                        }
                      },
                      child: Card(color: Colors.greenAccent,
                        child: Text(
                          "  Save  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> changeValueSem4() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Enter changes Regarding Fees",
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20, // Adjusted font size to fit constraints
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _changevalue,
                        decoration: InputDecoration(
                          labelText: 'Fees',
                          labelStyle: TextStyle(
                            fontFamily: 'Playfair',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Card(color: Colors.redAccent,
                        child: Text(
                          "  Cancel  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_changevalue.text.isNotEmpty) {
                          final value = int.tryParse(_changevalue.text);
                          if (value != null) {
                            setState(() {
                              sem_4 = value;
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid input. Please enter a valid number.'),
                              ),
                            );
                          }
                        }
                      },
                      child: Card(color: Colors.greenAccent,
                        child: Text(
                          "  Save  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> changeValueSem5() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Enter changes Regarding Fees",
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20, // Adjusted font size to fit constraints
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _changevalue,
                        decoration: InputDecoration(
                          labelText: 'Fees',
                          labelStyle: TextStyle(
                            fontFamily: 'Playfair',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Card(color: Colors.redAccent,
                        child: Text(
                          "  Cancel  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_changevalue.text.isNotEmpty) {
                          final value = int.tryParse(_changevalue.text);
                          if (value != null) {
                            setState(() {
                              sem_5 = value;
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid input. Please enter a valid number.'),
                              ),
                            );
                          }
                        }
                      },
                      child: Card(color: Colors.greenAccent,
                        child: Text(
                          "  Save  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> changeValueSem6() async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Container(
          constraints: BoxConstraints(maxHeight: 300, maxWidth: 300),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Enter changes Regarding Fees",
                        style: TextStyle(
                          fontFamily: 'Playfair',
                          fontSize: 20, // Adjusted font size to fit constraints
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _changevalue,
                        decoration: InputDecoration(
                          labelText: 'Fees',
                          labelStyle: TextStyle(
                            fontFamily: 'Playfair',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16), // Add spacing
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Card(color: Colors.redAccent,
                        child: Text(
                          "  Cancel  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (_changevalue.text.isNotEmpty) {
                          final value = int.tryParse(_changevalue.text);
                          if (value != null) {
                            setState(() {
                              sem_6 = value;
                            });
                            Navigator.pop(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid input. Please enter a valid number.'),
                              ),
                            );
                          }
                        }
                      },
                      child: Card(color: Colors.greenAccent,
                        child: Text(
                          "  Save  ",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: Text(
          "BSC-IT Fees",
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
            fontFamily: 'Playfair',
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Sem 1",
                          style: TextStyle(fontWeight: FontWeight.bold,
                            fontFamily: 'Playfaair',
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Tuation Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "22,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Semester Registration Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Exam Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "1,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Enrollment",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "1,000",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Deposite",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "7,000",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Uniform Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "2,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                      child: Divider( // Add an underline
                        color: Colors.black,
                        thickness: 1.0,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "Total Fees",
                          style: TextStyle(
                            fontFamily: 'Playfair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "$sem_1",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => changeValueSem1(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Card(color: Colors.greenAccent,child: Text("  Edit  ",style: TextStyle(fontSize: 20),)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Sem 2",
                          style: TextStyle(fontWeight: FontWeight.bold,
                            fontFamily: 'Playfaair',
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Tuation Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "22,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Semester Registration Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Exam Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "1,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Total Fees",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "$sem_2 ",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => changeValueSem2(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Card(color: Colors.greenAccent,child: Text("  Edit  ",style: TextStyle(fontSize: 20),)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Sem 3",
                          style: TextStyle(fontWeight: FontWeight.bold,
                            fontFamily: 'Playfaair',
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Tuation Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "22,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Semester Registration Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Exam Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "1,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Total Fees",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "$sem_3 ",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => changeValueSem3(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Card(color: Colors.greenAccent,child: Text("  Edit  ",style: TextStyle(fontSize: 20),)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Sem 4",
                          style: TextStyle(fontWeight: FontWeight.bold,
                            fontFamily: 'Playfaair',
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Tuation Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "22,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Semester Registration Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Exam Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "1,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Total Fees",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "$sem_4 ",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => changeValueSem4(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Card(color: Colors.greenAccent,child: Text("  Edit  ",style: TextStyle(fontSize: 20),)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Sem 5",
                          style: TextStyle(fontWeight: FontWeight.bold,
                            fontFamily: 'Playfaair',
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Tuation Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "22,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Semester Registration Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Exam Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "1,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Total Fees",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "$sem_5 ",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => changeValueSem5(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Card(color: Colors.greenAccent,child: Text("  Edit  ",style: TextStyle(fontSize: 20),)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0,right: 8.0,left: 8.0,bottom: 80,),
            child: Card(color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text("Sem 6",
                          style: TextStyle(fontWeight: FontWeight.bold,
                            fontFamily: 'Playfaair',
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(
                      children: [
                        Text(
                          "Tuation Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "22,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Semester Registration Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Exam Fee",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "1,500",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Total Fees",
                          style: TextStyle(
                            fontFamily: 'Playfaair',
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "$sem_6 ",
                          style: TextStyle(
                            fontFamily: 'Robot',
                            fontSize: 20,
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Divider( // Add an underline
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () => changeValueSem6(),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Card(color: Colors.greenAccent,child: Text("  Edit  ",style: TextStyle(fontSize: 20),)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => bscitfeesnotpaid(),));
      },child: Icon(Icons.feed_sharp),backgroundColor: Colors.white,),
    );
  }
}