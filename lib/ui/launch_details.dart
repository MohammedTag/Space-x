import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_flutter_app/data/spacex_api_service.dart';

class LaunchDetailsPage extends StatelessWidget {
  final String launchId;

  const LaunchDetailsPage({
    Key key,
    this.launchId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Launch Details'),
      ),
      body: FutureBuilder<Response>(
        future: Provider.of<SpacexApiService>(context).getRocket(launchId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final Map rocket = json.decode(snapshot.data.bodyString);
            return _buildDetails(rocket);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Padding _buildDetails(Map rocket) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Text(
            rocket['name'],
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(rocket['description']),
        ],
      ),
    );
  }
}
