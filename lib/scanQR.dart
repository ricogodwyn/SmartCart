import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:michelie2/shopPage.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:provider/provider.dart';
import 'dataHandler.dart';

// Custom painter class for overlay
class OverlayPainter extends CustomPainter {
  final double width;
  final double height;
  final double x;
  final double y;

  OverlayPainter({required this.width, required this.height, required this.x, required this.y});

  @override
  void paint(Canvas canvas, Size size) {
    var holeCenter = Offset(x, y);
    var hole = Rect.fromCenter(center: holeCenter, width: width, height: height);

    var overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    canvas.saveLayer(Rect.fromLTRB(0, 0, size.width, size.height), overlayPaint);
    canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), overlayPaint);
    canvas.drawRRect(RRect.fromRectAndRadius(hole, Radius.circular(16)), Paint()..blendMode = BlendMode.clear);
    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ScanQR extends StatefulWidget {
  const ScanQR({Key? key}) : super(key: key);

  @override
  State<ScanQR> createState() => _ScanQRState();
}

class _ScanQRState extends State<ScanQR> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText = "";

  @override
  Widget build(BuildContext context) {
    // Customize these values as needed
    double holeWidth = 300.0;
    double holeHeight = 300.0;
    double holeX = MediaQuery.of(context).size.width / 2; // Center X
    double holeY = 320; // Center Y

    return Scaffold(
      body: Stack(
        children: <Widget>[
          
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          CustomPaint(
            size: Size.infinite,
            painter: OverlayPainter(
              width: holeWidth, 
              height: holeHeight, 
              x: holeX, 
              y: holeY
            ),
          ),
          Positioned(
            bottom: holeY*2.05,
            right: holeX-120,
            child: Text('Scan the QR code here',
            style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Gilroy',
                      color: Color(0xFFEAE3E3))
            )
            ),
          // Positioned(
          //   bottom: 10,
          //   child: Container(
          //     width: MediaQuery.of(context).size.width,
          //     color: Colors.white,
          //     padding: EdgeInsets.all(10),
          //     child: Text('Estimated QR Code: $qrText', textAlign: TextAlign.center),
          //   ),
          // ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async{
      qrText = scanData.code;
        CollectionReference cartId = FirebaseFirestore.instance.collection('cartID');
        QuerySnapshot querySnapshot = await cartId.where('cartID', isEqualTo: qrText).get();
        if (mounted){
          Navigator.of(context).pushReplacement(
           MaterialPageRoute(builder: (context) => shopPage()),
          );
          if (querySnapshot.docs.isNotEmpty){
           DocumentSnapshot firstDoc = querySnapshot.docs.first;
            firstDoc.reference.update({'UID':'${Provider.of<dataHandler>(context, listen: false).uid}'});
        }
        }
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
