// Column(crossAxisAlignment: CrossAxisAlignment.center,
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Padding(
// padding: const EdgeInsets.all(10),
// child: Text("List of Stream",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,),),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6), // Reduced vertical padding
// child: GestureDetector(
// onTapDown: (_) => _controller.forward(),  // Press Animation
// onTapUp: (_) => _controller.reverse(),    // Release Animation
// onTap: () {
// targetPage = bcaCertificates();
// globalCertificates = "BCA";
// Navigator.push(context, _createPageRoute(targetPage));
// },
// child: AnimatedContainer(
// duration: Duration(milliseconds: 300),
// curve: Curves.easeInOut,
// transform: Matrix4.diagonal3Values(_scale, _scale, 1),
// height: 50, // Set a fixed smaller height
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(12), // Reduced border radius
// color: Colors.white.withOpacity(0.2), // Glassmorphism effect
// border: Border.all(color: Colors.orangeAccent, width: 2),
// boxShadow: [
// BoxShadow(
// color: Colors.orange.withOpacity(0.3),
// blurRadius: 8, // Slightly smaller blur
// offset: Offset(2, 2),
// ),
// ],
// ),
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10), // Reduced padding
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Icon(Icons.school, color: Colors.orange, size: 22), // Reduced icon size
// SizedBox(width: 8), // Reduced spacing
// Text(
// "BCA",
// style: TextStyle(
// fontSize: 18, // Reduced font size
// fontWeight: FontWeight.w600,
// color: Colors.black87,
// letterSpacing: 1.1,
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// child: GestureDetector(
// onTapDown: (_) => _controller.forward(),  // Press Animation
// onTapUp: (_) => _controller.reverse(),    // Release Animation
// onTap: () {
// targetPage = bcaCertificates();
// globalCertificates = "MCA";
// Navigator.push(context, _createPageRoute(targetPage));
// },
// child: AnimatedContainer(
// duration: Duration(milliseconds: 300),
// curve: Curves.easeInOut,
// transform: Matrix4.diagonal3Values(_scale, _scale, 1),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// color: Colors.white.withOpacity(0.2), // Glassmorphism effect
// border: Border.all(color: Colors.orangeAccent, width: 2),
// boxShadow: [
// BoxShadow(
// color: Colors.orange.withOpacity(0.3),
// blurRadius: 10,
// offset: Offset(3, 3),
// ),
// ],
// ),
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Icon(Icons.school, color: Colors.orange, size: 22), // Added icon
// SizedBox(width: 10), // Space between icon and text
// Text(
// "MCA",
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.w600,
// color: Colors.black87,
// letterSpacing: 1.2,
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// child: GestureDetector(
// onTapDown: (_) => _controller.forward(),  // Press Animation
// onTapUp: (_) => _controller.reverse(),    // Release Animation
// onTap: () {
// targetPage = bcaCertificates();
// globalCertificates = "BSC-IT";
// Navigator.push(context, _createPageRoute(targetPage));
// },
// child: AnimatedContainer(
// duration: Duration(milliseconds: 300),
// curve: Curves.easeInOut,
// transform: Matrix4.diagonal3Values(_scale, _scale, 1),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// color: Colors.white.withOpacity(0.2), // Glassmorphism effect
// border: Border.all(color: Colors.orangeAccent, width: 2),
// boxShadow: [
// BoxShadow(
// color: Colors.orange.withOpacity(0.3),
// blurRadius: 10,
// offset: Offset(3, 3),
// ),
// ],
// ),
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Icon(Icons.school, color: Colors.orange, size: 22), // Added icon
// SizedBox(width: 10), // Space between icon and text
// Text(
// "BSC-IT",
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.w600,
// color: Colors.black87,
// letterSpacing: 1.2,
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// child: GestureDetector(
// onTapDown: (_) => _controller.forward(),  // Press Animation
// onTapUp: (_) => _controller.reverse(),    // Release Animation
// onTap: () {
// targetPage = bcaCertificates();
// globalCertificates = "BBA";
// Navigator.push(context, _createPageRoute(targetPage));
// },
// child: AnimatedContainer(
// duration: Duration(milliseconds: 300),
// curve: Curves.easeInOut,
// transform: Matrix4.diagonal3Values(_scale, _scale, 1),
// decoration: BoxDecoration(
// borderRadius: BorderRadius.circular(15),
// color: Colors.white.withOpacity(0.2), // Glassmorphism effect
// border: Border.all(color: Colors.orangeAccent, width: 2),
// boxShadow: [
// BoxShadow(
// color: Colors.orange.withOpacity(0.3),
// blurRadius: 10,
// offset: Offset(3, 3),
// ),
// ],
// ),
// child: Padding(
// padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
// child: Row(
// mainAxisAlignment: MainAxisAlignment.center,
// children: [
// Icon(Icons.school, color: Colors.orange, size: 22), // Added icon
// SizedBox(width: 10), // Space between icon and text
// Text(
// "BBA",
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.w600,
// color: Colors.black87,
// letterSpacing: 1.2,
// ),
// ),
// ],
// ),
// ),
// ),
// ),
// ),
// ],
// )

import 'package:flutter/material.dart';

class CertificateGrid extends StatefulWidget {
  @override
  _CertificateGridState createState() => _CertificateGridState();
}

class _CertificateGridState extends State<CertificateGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _scale = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..addListener(() {
      setState(() {
        _scale = _controller.value;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // List of certificates
  final List<Map<String, String>> certificates = [
    {"name": "BCA", "route": "bcaCertificates"},
    {"name": "MCA", "route": "mcaCertificates"},
    {"name": "BSC-IT", "route": "bscItCertificates"},
    {"name": "BBA", "route": "bbaCertificates"},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 Columns
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 3, // Adjusts width/height ratio
        ),
        itemCount: certificates.length,
        itemBuilder: (context, index) {
          return _buildCertificateButton(
            certificates[index]["name"]!,
            certificates[index]["route"]!,
          );
        },
      ),
    );
  }

  Widget _buildCertificateButton(String title, String route) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        transform: Matrix4.diagonal3Values(_scale, _scale, 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white.withOpacity(0.2), // Glassmorphism effect
          border: Border.all(color: Colors.orangeAccent, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.orange.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(3, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.school, color: Colors.orange, size: 22),
              SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
