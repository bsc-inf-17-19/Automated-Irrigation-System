import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Irrigation System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IrrigationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IrrigationPage extends StatefulWidget {
  @override
  _IrrigationPageState createState() => _IrrigationPageState();
}

class _IrrigationPageState extends State<IrrigationPage> {
  String moisture = 'N/A';
  String relayStatus = 'N/A';
  final TextEditingController _textFieldController = TextEditingController();
  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();
    _readMoistureData();
    _readRelayStatus();
  }

  void _readMoistureData() {
    // Fetch initial data
    _databaseReference.child('/sensors/sensorId1/data').orderByKey().limitToLast(1).get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        Map data = snapshot.value as Map;
        data.forEach((key, value) {
          setState(() {
            moisture = value['value'].toString() + '%';
            _showMoistureNotification(double.tryParse(value['value'].toString()) ?? -1);
          });
        });
      } else {
        setState(() {
          moisture = 'N/A';
        });
      }
    }).catchError((error) {
      print('Failed to read moisture data: $error');
      setState(() {
        moisture = 'N/A';
      });
    });

    // Listen for real-time updates
    _databaseReference.child('/sensors/sensorId1/data').orderByKey().limitToLast(1).onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map data = event.snapshot.value as Map;
        data.forEach((key, value) {
          setState(() {
            moisture = value['value'].toString() + '%';
            _showMoistureNotification(double.tryParse(value['value'].toString()) ?? -1);
          });
        });
      }
    }, onError: (error) {
      print('Failed to listen for moisture data: $error');
    });
  }

  void _readRelayStatus() {
    // Fetch relay status data
    _databaseReference.child('/relays/relayId1/status').get().then((DataSnapshot snapshot) {
      if (snapshot.exists) {
        setState(() {
          relayStatus = snapshot.value.toString();
        });
      } else {
        setState(() {
          relayStatus = 'N/A';
        });
      }
    }).catchError((error) {
      print('Failed to read relay status: $error');
      setState(() {
        relayStatus = 'N/A';
      });
    });

    // Listen for real-time updates
    _databaseReference.child('/relays/relayId1/status').onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        setState(() {
          relayStatus = event.snapshot.value.toString();
        });
      }
    }, onError: (error) {
      print('Failed to listen for relay status: $error');
    });
  }

  void _showMoistureNotification(double moistureValue) {
    String message = '';
    if (moistureValue == 0) {
      message = 'No moisture';
    } else if (moistureValue < 20) {
      message = 'Low moisture';
    } else if (moistureValue >= 30 && moistureValue <= 60) {
      message = 'Moderate moisture';
    } else if (moistureValue > 70) {
      message = 'High moisture';
    } else {
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Moisture Alert'),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _sendCropSelection(String crop) {
    int valueToSend;
    if (crop == 'Maize') {
      valueToSend = 60;
    } else if (crop == 'Onion') {
      valueToSend = 40; // Example value for Onion
    } else {
      return;
    }

    _databaseReference.child('/selectedCrop').set({'crop': crop, 'value': valueToSend}).then((_) {
      print('Crop selection updated successfully');
    }).catchError((error) {
      print('Failed to update crop selection: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Irrigation System'),
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'Notification',
                child: Text('Notification'),
              ),
              PopupMenuItem<String>(
                value: 'Refresh',
                child: Text('Refresh'),
              ),
              PopupMenuItem<String>(
                value: 'Log out',
                child: Text('Log out'),
              ),
            ],
            onSelected: (String value) {
              // Handle menu item selection
              if (value == 'Notification') {
                // Handle notification
              } else if (value == 'Refresh') {
                // Handle history
              } else if (value == 'Log out') {
                // Handle logout
              }
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Relay Status: $relayStatus',
                  style: TextStyle(
                    fontSize: 4,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 100),
                Container(
                  width: 300,
                  child: TextField(
                    key: Key('crops_textField'),
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      hintText: 'Choose crop',
                      hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)),
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: PopupMenuButton<String>(
                        icon: Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Maize',
                            child: Text('Maize'),
                          ),
                          PopupMenuItem<String>(
                            value: 'Onion',
                            child: Text('Onion'),
                          ),
                        ],
                        onSelected: (String value) {
                          _textFieldController.text = value;
                          _sendCropSelection(value);
                        },
                      ),
                    ),
                    onChanged: (value) {
                      // Handle text field changes
                    },
                  ),
                ),
                SizedBox(height: 120),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Soil Moisture',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          moisture,
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
//                 SizedBox(height: 70),
//                 ElevatedButton(
//                   key: Key('statistics_button_key'),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => StatisticsPage()),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.teal,
//                     foregroundColor: Colors.white,
//                     padding: EdgeInsets.symmetric(horizontal: 70, vertical: 20),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   child: Text('Statistics'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class StatisticsPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Statistics'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Center(
//         child: Text(
//           'Statistics Page',
//           style: TextStyle(
//             fontSize: 24,
//             color: Colors.teal,
//           ),
//         ),
//       ),
//     );
//   }
// }
