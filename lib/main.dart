import 'package:flutter/material.dart';
import 'esp_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// ...

void main() async{
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
  //String temperature = 'N/A';
  String moisture = 'N/A';
  // String humidity = 'N/A';
  // String sunlight = 'N/A';
  // String battery = 'N/A';
  // String irrigationStatus = 'N/A';

  final TextEditingController _textFieldController = TextEditingController();
  final ESPService espService = ESPService('http://192.168.137.178');

  @override
  void initState() {
    super.initState();
    getMoistureData();
  }

  Future<void> getMoistureData() async {
    try {
      final data = await espService.fetchData();
      setState(() {
        // temperature = data['temperature'].toString();
        moisture = data['moisture'].toString();
        // humidity = data['humidity'].toString();
        // sunlight = data['sunlight'].toString();
        // battery = data['battery'].toString();
        // irrigationStatus = data['irrigationStatus'].toString();
      });
    } catch (e) {
      print("Error in fetching data: $e");
      setState(() {
        // temperature = 'Error';
        moisture = 'Error';
        // humidity = 'Error';
        // sunlight = 'Error';
        // battery = 'Error';
        // irrigationStatus = 'Error';
      });
    }
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
            // Positioned(
            //   left: 65,
            //   top: 230,
            //   child: Icon(Icons.thermostat, color: Colors.white, size: 90),
            // ),
            // Positioned(
            //   left: 51,
            //   top: 315,
            //   child: Text(
            //     'Temperature: $temperature°C',
            //     style: TextStyle(
            //       color: Colors.white.withOpacity(0.7),
            //       fontSize: 16,
            //       fontFamily: 'Inter',
            //       fontWeight: FontWeight.w400,
            //       height: 0,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   left: 100,
            //   top: 165,
            //   child: Text(
            //     "IRRIGATION STATUS: $irrigationStatus",
            //     style: TextStyle(
            //       color: Colors.white.withOpacity(0.7),
            //       fontSize: 17,
            //       fontFamily: 'Inter',
            //       fontWeight: FontWeight.w400,
            //       height: 0,
            //     ),
            //   ),
            // ),
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
            // Positioned(
            //   left: 255,
            //   top: 240,
            //   child: Icon(Icons.wb_sunny, color: Colors.white, size: 78),
            // ),
            // Positioned(
            //   left: 245,
            //   top: 315,
            //   child: Text(
            //     'Sunlight: $sunlight',
            //     style: TextStyle(
            //       color: Colors.white.withOpacity(0.7),
            //       fontSize: 16,
            //       fontFamily: 'Inter',
            //       fontWeight: FontWeight.w400,
            //       height: 0,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   left: 251,
            //   top: 380,
            //   child: Icon(Icons.opacity, color: Colors.white, size: 78),
            // ),
            // Positioned(
            //   left: 245,
            //   top: 463,
            //   child: Text(
            //     'Humidity: $humidity%',
            //     style: TextStyle(
            //       color: Colors.white.withOpacity(0.7),
            //       fontSize: 16,
            //       fontFamily: 'Inter',
            //       fontWeight: FontWeight.w400,
            //       height: 0,
            //     ),
            //   ),
            // ),
            // Positioned(
            //   left: 151,
            //   top: 530,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Icon(Icons.battery_5_bar_outlined, color: Colors.white, size: 90),
            //       SizedBox(height: 10),
            //       Text(
            //         'Battery: $battery%',
            //         style: TextStyle(
            //           color: Colors.white.withOpacity(0.7),
            //           fontSize: 16,
            //           fontFamily: 'Inter',
            //           fontWeight: FontWeight.w400,
            //           height: 0,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
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
