import 'package:flutter/material.dart';
import 'package:test1/Student Section/Homepage.dart';
class punishment extends StatefulWidget {
  const punishment({super.key});

  @override
  State<punishment> createState() => _punishmentState();
}

class _punishmentState extends State<punishment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.orangeAccent,
        title: Text("Punishment",style: TextStyle(color: Colors.white,fontFamily: 'Playfaair',fontWeight: FontWeight.bold,fontSize: 20, ),),
        leading: IconButton(onPressed: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => Homepage(),));
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      body: ListView(
        children: [
          Column(
            children: [
              SizedBox(height: 350,),
              Text("No data Found",style: TextStyle(fontSize: 20,fontFamily: 'Playfaair',color: Colors.grey),),
            ],
          )
        ],
      ),
    );
  }
}
