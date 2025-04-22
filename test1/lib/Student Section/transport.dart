import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:test1/Student%20Section/Homepage.dart';
import 'package:test1/Student%20Section/session_manager.dart';

class Transport extends StatefulWidget {
  const Transport({super.key});

  @override
  State<Transport> createState() => _TransportState();
}

class _TransportState extends State<Transport> {
  @override
  Widget build(BuildContext context) {
    int feesPaid = 11600;
    String? errorMessage;
    String imageUrl;
    Future<void> fetchImage() async {
      final String enrollment = globalUsername!;
      if (enrollment.isEmpty) {
        setState(() {
          errorMessage = "Enrollment number is required.";
        });
        return;
      }

      final String url = "http://192.168.1.6:8080/Flutter/firstapp/bring.php?enrollment=$enrollment";
      print("Fetching image from: $url");

      try {
        final response = await http.get(Uri.parse(url));
        print("Response Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data["success"]) {
            setState(() {
              globalImage=data["image_url"];
              imageUrl = data["image_url"];
              errorMessage = null;
            });
          } else {
            setState(() {
              imageUrl = "";
              errorMessage = data["message"];
            });
          }
        } else {
          setState(() {
            imageUrl = "";
            errorMessage = "Server error: ${response.statusCode}";
          });
        }
      } catch (e) {
        setState(() {
          imageUrl = "";
          errorMessage = "Failed to connect to server";
        });
        print("Error fetching image: $e");
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text(
          "Transport",
          style: TextStyle(
            color: Colors.white,
            fontFamily: "Robot",
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Homepage(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
      ),
      body: Container(

    child: RefreshIndicator(
      onRefresh: () async{
        fetchImage();
      },
      child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white70,
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage: globalImage != null ? NetworkImage(globalImage!) : null,
                              backgroundColor: Colors.grey[300],
                              child: globalImage == null
                                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                                  : null, // Prevents icon overlapping the image
                            ),
                            const Spacer(),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _statusTag(
                                  label: "Active",
                                  color: Colors.greenAccent,
                                ),
                                const SizedBox(height: 10),
                                _statusTag(
                                  label: "Bus Pass No. 24/S/01AC/029",
                                  color: Colors.orangeAccent,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _infoRow(title: "$globalname"),
                        _infoRow(title: "(Sem - 6 | 22030401162 | DICA-DoCA-6)"),
                        const SizedBox(height: 16),
                        const Divider(),
                        _infoRow(title: "Pickup Point", value: "150 Ft Ring Road"),
                        _infoRow(
                          title: "Route",
                          value: "Bus No.03 - (S2) - R-03 - Shift-2 Jyoti Nagar Road",
                        ),
                        const Divider(),
                        const SizedBox(height: 16),
                        Card(
                          color: Colors.white,
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _feesDetail(
                                  label: "Fees Amount",
                                  value: "₹11,600",
                                  color: Colors.blueAccent,
                                ),
                                _feesDetail(
                                  label: "Fees Paid",
                                  value: "₹$feesPaid",
                                  color: Colors.green,
                                ),
                                _feesDetail(
                                  label: "Remaining",
                                  value: "₹0",
                                  color: Colors.redAccent,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
    ),
      ),
    );
  }

  Widget _statusTag({required String label, required Color color}) {
    return Container(

      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: color, width: 1.5),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _infoRow({required String title, String? value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(

              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          if (value != null)
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _feesDetail({required String label, required String value, required Color color}) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(

            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}
