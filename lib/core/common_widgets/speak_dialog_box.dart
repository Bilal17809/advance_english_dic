import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Future<void> showNoInternetDialog2(BuildContext context) async {
//   var connectivityResults = await Connectivity().checkConnectivity();
//   ConnectivityResult connectivityResult = connectivityResults.isNotEmpty
//       ? connectivityResults.first
//       : ConnectivityResult.none;
//   if (connectivityResult == ConnectivityResult.none) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           contentPadding: EdgeInsets.all(20),
//           titlePadding: EdgeInsets.only(left: 10),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   CircleAvatar(
//                     radius: 20,
//                     backgroundColor: Colors.blueAccent,
//                     child: Icon(
//                       Icons.wifi_off,
//                       color: Colors.white,
//                     ),
//                   ),
//                   SizedBox(width: 5),
//                   Text(
//                     'No Internet Connection',
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//               SizedBox(height: 10),
//               // Updated message
//               Text(
//                 'Make sure that Wi-Fi or mobile data is turned on, then try again.',
//                 style: TextStyle(
//                   fontSize: 16,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20), // Space before the "OK" button
//               // Button to dismiss the dialog
//               Align(
//                 alignment: Alignment.bottomRight,
//                 child: TextButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text(
//                     'OK',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   style: TextButton.styleFrom(
//                     backgroundColor: Colors.purple,
//                     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

void showCustomToast(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      bottom:70,
      left: 30,
      right: 30,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3A8DFF),  Color(0xFF6CC4FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius:5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), () {
    overlayEntry.remove();
  });
}
