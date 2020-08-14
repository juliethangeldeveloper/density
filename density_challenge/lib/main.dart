import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:density_challenge/density.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Density Count',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Density Project'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<DensityData> dataFuture;

  Future<List<DensityData>> fetchData() async {
    List<DensityData> dataItems;

    final response = await http.get(
      'https://api.density.io/v2/spaces/',
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer tok_KOcggRz4zULjCXCLHUkmRamnv1KLNnSxEzhTUDpqswL"
      },
    );
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data["results"] as List;
      dataItems =
          rest.map<DensityData>((json) => DensityData.fromJson(json)).toList();
      print(dataItems.length);
      return dataItems;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load ');
    }
  }

  void _refresh() {

  }

  @override
  void initState() {
    super.initState();
  }

  Widget listViewWidget(List<DensityData> data) {
    return Container(
      child: ListView.builder(
          itemCount: data.length,
          padding: const EdgeInsets.all(2.0),
          itemBuilder: (context, position) {
            return Card(
              child: ListTile(
                title: Text(
                  '${data[position].name}: ' + '${data[position].currentCount}',
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
    );
  }
  setUpTimedFetch() {
    Timer.periodic(Duration(milliseconds: 5000), (timer) {
      setState(() {
      });
    });
  }
  @override
  Widget build(BuildContext context) {
      setUpTimedFetch();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height - 100,
              child: FutureBuilder(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return new Container();
                    return snapshot.data != null
                        ? listViewWidget(snapshot.data)
                        : Center(child: CircularProgressIndicator());
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
