



import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class Location extends StatefulWidget {
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<Location> {

  List<String> kann = [];

  @override
  void initState() {
    Translator();
    super.initState();
  }

  Future<String> Translator() async {
    final translator = GoogleTranslator();

    final input = "Здравствуйте. Ты в порядке?";
    final input1 = "Road Maintenance";
    final input2 = "Здравствуйте. Ты в порядке?";



    var translation = translator.translate(input1, from: 'en', to: 'kn').
    then(
            (value) =>
                print(value));





  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Translator"),),
      body: Column(
        children: [



        ],
      )
      ,
    );

  }





}















// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
//
// class Location extends StatefulWidget {
//   _LocationState createState() => _LocationState();
// }
//
// class _LocationState extends State<Location> {
//
//   String latitude = "";
//   String longitude = "";
// @override
//   void initState() {
//     super.initState();
//     getCurrenLocation();
//   }
//
//   getCurrenLocation() async {
//     final geoposition  = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//     setState(() {
//       latitude = "${geoposition.latitude}";
//       longitude = "${geoposition.longitude}";
//
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.blue,
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             Text(latitude),
//             Text(longitude),
//           ],
//         ),
//       ),
//     );
//   }
//
//
// }

