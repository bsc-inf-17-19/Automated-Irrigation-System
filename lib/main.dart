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
  final TextEditingController _textFieldController = TextEditingController();
  late DatabaseReference _databaseReference;

  @override
  void initState() {
    super.initState();
    _databaseReference = FirebaseDatabase.instance.ref();
    _readMoistureData();
  }

  void _readMoistureData() {
    // Fetch initial data
    _databaseReference.child('/sensors/sensorId1/data/moisture').get().then((DataSnapshot snapshot) {
      final data = snapshot.value;
      if (data != null) {
        setState(() {
          moisture = data.toString();
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
    _databaseReference.child('/sensors/sensorId1/data/moisture').onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null) {
        setState(() {
          moisture = data.toString();
        });
      }
    }, onError: (error) {
      print('Failed to listen for moisture data: $error');
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
                value: 'History',
                child: Text('History'),
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
              } else if (value == 'History') {
                // Handle history
              } else if (value == 'Log out') {
                // Handle logout
              }
            },
          ),
        ],
        centerTitle: true,
        backgroundColor: Color(0xFFD9D9D9),
      ),
      body: Container(
        width: 853,
        height: 953,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Color(0x931E3D6C)),
        child: Stack(
          children: [
            Positioned(
              left: 245,
              top: 100,
              child: ElevatedButton(
                key: Key('statistics_button_key'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StatisticsPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFD9D9D9),
                  foregroundColor: Colors.white,
                ),
                child: Text('Statistics'),
              ),
            ),
            Positioned(
              left: 51,
              top: 100,
              child: Container(
                width: 170,
                child: Row(
                  children: [
                    Expanded(
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
                        ),
                        onChanged: (value) {
                          // Handle text field changes
                        },
                      ),
                    ),
                    PopupMenuButton<String>(
                      icon: Icon(Icons.keyboard_arrow_down, color: Colors.white),
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
                      },
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 80,
              top: 380,
              child: Icon(Icons.water, color: Colors.white, size: 78),
            ),
            Positioned(
              left: 51,
              top: 463,
              child: Text(
                'Soil Moisture: $moisture',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  height: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
      ),
      body: Center(
        child: Text('Statistics Page'),
      ),
    );
  }
}
