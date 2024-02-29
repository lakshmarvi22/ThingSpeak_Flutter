import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:thingspeak/about.dart';
import 'dart:async';

import 'package:thingspeak/faq.dart';
import 'faq.dart';
import 'package:charts_flutter/flutter.dart' as charts;

void main() {
  runApp(MaterialApp(
    home: YourWidget(),
  ));
}

class YourWidget extends StatefulWidget {
  @override
  _YourWidgetState createState() => _YourWidgetState();
}
class _YourWidgetState extends State<YourWidget> {
  @override
  void initState() {
    super.initState();
    // Call fetchDataFromThingSpeak immediately when the widget initializes
    fetchDataFromThingSpeak(context);
    // Call fetchDataFromThingSpeak every 30 seconds
    Timer.periodic(Duration(seconds: 30), (timer) {
      fetchDataFromThingSpeak(context);
    });
  }

  late double? value;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white, // Change the color of the drawer icon here
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Smart App',
            style: TextStyle(color: Colors.white),),
          backgroundColor: Colors.black,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.black,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                title: Text('About'),
                onTap: () {
                  // Navigate to the Faq screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUsPage()),
                  );
                },

              ),
              ListTile(
                title: Text('Frequently Asked Question'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Faq()),
                  ); // Close the drawer
                },
              ),
              ListTile(
                title: Text('Home'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => YourWidget()),
                  ); // Close the drawer
                },
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Container(
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 500,
                      width: 500,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        // Change this to your desired background color for the container
                        borderRadius: BorderRadius.circular(
                            40), // Adjust the border radius as needed
                      ),
                      padding: EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.home, // Change this to your desired icon
                            size: 150, // Adjust size as needed
                            color: Colors
                                .black, // Change this to your desired icon color
                          ),
                          SizedBox(height: 20),
                          // Add some space between icon and text
                          Center(child: Text(
                            "SMART CITY",
                            softWrap: true,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Roboto',
                              // Change this to your desired font family
                              color: Colors
                                  .black, // Change this to your desired text color
                            ),
                          ),
                          ),
                        ],
                      ),
                    )

                    //SizedBox(height: 20), // Add some space between logo and text
                    /*Text(
                      "Creating smarter cities for a better tomorrow",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto', // Change this to your desired font family
                        color: Colors.black, // Change this to your desired text color
                      ),
                    ),*/
                  ],
                ),
              ),
            ),


            // Added Expanded to take remaining space
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showText(context);
                    },
                    child: const Text('Fetch Data'),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _showGraph(context);
                    },
                    child: const Text('Fetch Graph'),
                  ),
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }


  Future<void> fetchDataFromThingSpeak(BuildContext context) async {
    try {
      // Replace 'YOUR_API_KEY' with your actual ThingSpeak Read API Key
      final String apiKey = 'P8B7E23C51REH7A3';
      // Replace 'CHANNEL_ID' with your actual ThingSpeak Channel ID
      final String channelId = '2443981';
      final String url = 'https://api.thingspeak.com/channels/$channelId/feeds.json?api_key=$apiKey&results=1';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> feeds = data['feeds'];
        if (feeds.isNotEmpty) {
          final lastEntry = feeds.first; // Extracting the first (most recent) entry
          final fieldValue = lastEntry['field1'].toString(); // Assuming 'field1' contains the value
          print('Last value: $fieldValue');
          final double? fieldValue_f = double.tryParse(
              fieldValue.replaceAll(RegExp('[^0-9.]'), ''));
          value = fieldValue_f;
          if (fieldValue_f != null && fieldValue_f > 75.00) {
            _showAlert(context);
            print("alert");
          } else {
            print('No alert');
          }
        } else {
          print('No data available in the channel.');
        }
      }
      else {
        throw Exception(
            'Failed to fetch data from ThingSpeak: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching data from ThingSpeak: $e');
    }
  }

  void _showAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('Emission is high..Turn on ventilation'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showText(BuildContext context) {
    fetchDataFromThingSpeak(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Gas Emitted value'),
          content: Text('Value : $value'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showGraph(BuildContext context) async {
    try {
      // Fetch data from ThingSpeak
      final String apiKey = 'P8B7E23C51REH7A3';
      final String channelId = '2443981';
      final String url = 'https://api.thingspeak.com/channels/$channelId/feeds.json?api_key=$apiKey&results=10';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> feeds = data['feeds'];
        if (feeds.isNotEmpty) {
          final List<ChartData> chartData = [];

          /*for (var entry in feeds) {
            final value = double.tryParse(entry['field1']);
            print(value);
            if (value != null) {
              chartData.add(ChartData(value));
            }
          }*/
          for (var feed in feeds) {
            final fieldValueGraph = feed['field1'].toString();
            print('Field1 Value: $fieldValueGraph');
            //final fieldValue = lastEntry['field1'].toString(); // Assuming 'field1' contains the value
            //print('Last value: $fieldValueGraph');
            final double? fieldValueGraph_f= double.tryParse(
                fieldValueGraph.replaceAll(RegExp('[^0-9.]'), ''));
            if (fieldValueGraph_f != null) {
              chartData.add(ChartData(fieldValueGraph_f));
            }

          }
          // Show chart in dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Gas Emitted Graph'),
                content: SizedBox(
                  width: 300,
                  height: 300,
                  child: _buildChart(chartData),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        } else {
          print('No data available in the channel.');
        }
      } else {
        throw Exception(
            'Failed to fetch data from ThingSpeak: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error fetching data from ThingSpeak: $e');
    }
  }

  Widget _buildChart(List<ChartData> data) {
    print(data);
    final seriesList = [
      charts.Series<ChartData, double>(
        id: 'Data',
        colorFn: (_, __) => charts.MaterialPalette.black,
        domainFn: (ChartData sales, _) => sales.value,
        // Use field1 value as x-axis (domain)
        measureFn: (ChartData sales, _) => sales.value,
        // Use field1 value as y-axis (measure)
        data: data,
      )
    ];

    return charts.ScatterPlotChart(
      seriesList,
      animate: true,
    );
  }
}
  class ChartData {
  final double value;

  ChartData(this.value);
  }



