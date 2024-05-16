import 'package:flutter/material.dart';
//import 'package:smart_irrigation_system/statistics.dart';

void main() {
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
  // Define variables to hold temperature and moisture values
  String temperature = '73';
  String moisture = '63%';
  String humidity = '40%';
  String sunlight = 'low';
  String battery = '88%';
  String irrigationStatus = 'ON';
  final TextEditingController _textFieldController = TextEditingController();

  // Method to update temperature and moisture values
  void updateValues(String temp,String irriStatus, String batt, String moist, String hum, String sun) {
    setState(() {
      temperature = temp; moisture = moist; humidity = hum; sunlight = sun;battery = batt;
      irrigationStatus= irriStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Irrigation System'),
        actions: [IconButton(icon: Icon(Icons.menu),
        onPressed: (){
      //it should handle menu button
    }),
      ],
        centerTitle: true,
        backgroundColor: Color(0xFFD9D9D9),
      ),
      body: Container(width: 853, height: 953,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Color(0x931E3D6C)),
        child: Stack(
          children: [
            Positioned(
  left: 65, // Adjust the left position to move the icon to the right
  top: 230, // Adjust the top position as needed
  child: Icon(Icons.thermostat, color: Colors.white, size: 90), // Adjust size as needed
),
Positioned(
  left: 51,
  top: 315, // Adjust the top position of the text to move it below the icon
  child: Text(
    'Temperature: $temperature°C',
    style: TextStyle(
      color: Colors.white.withOpacity(0.7),
      fontSize: 16, fontFamily: 'Inter',
      fontWeight: FontWeight.w400, height: 0,
    ),
  ),
),
Positioned(
    left: 100,
    top: 165,
    child: Text(
      "IRRIGATION STATUS: $irrigationStatus", style: TextStyle(color: Colors.white.withOpacity(0.7),
    fontSize: 17, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 0,),
    )),

            // Statistics Button
            Positioned(
              left: 245,
              top: 100, // Adjust this value to position the button
              child: ElevatedButton(
                key: Key('statistics_button_key'),
                onPressed: () {
                  // Navigate to the next page
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
  top: 100, // Adjust the top position of the text field
  child: Container(
    width: 170, // Adjust the width of the container
    child: Row(
      children: [
        Expanded(
          child: TextField(
            key: Key('crops_textField'),
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Choose crop',
              hintStyle: TextStyle(color: Colors.black.withOpacity(0.2)), // Adjust opacity as needed
              fillColor: Colors.white, filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 10), // Adjust padding as needed
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
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.white), // Add down arrow icon
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
            _textFieldController.text = value; // Update text field value when item is selected
          },
        ),
      ],
    ),
  ),
),

            Positioned(
  left: 255,
  top: 240, // Adjust the top position of the icon
  child: Icon(Icons.wb_sunny, color: Colors.white, size: 78), // Adjust size as needed
),
Positioned(
  left: 245,
  top: 315, // Adjust the top position of the text
  child: Text(
    'Sunlight: $sunlight',
    style: TextStyle(
      color: Colors.white.withOpacity(0.7), fontSize: 16, fontFamily: 'Inter',
      fontWeight: FontWeight.w400, height: 0,
    ),
  ),
),

            Positioned(
  left: 251,
  top: 380, // Adjust the top position of the icon
  child: Icon(Icons.opacity, color: Colors.white, size: 78), // Adjust size as needed
),
Positioned(
  left: 245,
  top: 463, // Adjust the top position of the text
  child: Text(
    'Humidity: $humidity%',
    style: TextStyle(
      color: Colors.white.withOpacity(0.7), fontSize: 16, fontFamily: 'Inter',
      fontWeight: FontWeight.w400, height: 0,
    ),
  ),
),

          Positioned(
  left: 151,
  top: 530, // Adjust the top position as needed
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Positioned(
        child: Icon(Icons.battery_5_bar_outlined, color: Colors.white, size: 90,),
      ),
      SizedBox(height: 10), // Add some space between the icon and the battery percentage
      Positioned(
        child: Text(
          'Battery: $battery%',
          style: TextStyle(
            color: Colors.white.withOpacity(0.7), fontSize: 16, fontFamily: 'Inter',
            fontWeight: FontWeight.w400, height: 0,
          ),
        ),
      ),
    ],
  ),
),


          Positioned(
  left: 80,
  top: 380, // Adjust the top position of the icon
  child: Icon(Icons.water, color: Colors.white, size: 78), // Adjust size as needed
),
Positioned(
  left: 51,
  top: 463, // Adjust the top position of the text
  child: Text(
    'Soil Moisture: $moisture',
    style: TextStyle(
      color: Colors.white.withOpacity(0.7), fontSize: 16, fontFamily: 'Inter', fontWeight: FontWeight.w400,
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

// Add StatisticsPage class
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
