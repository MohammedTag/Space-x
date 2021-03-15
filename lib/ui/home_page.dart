import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_flutter_app/data/spacex_api_service.dart';
import 'package:spacex_flutter_app/ui/launch_details.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Space X'),
      ),
      body: _buildBody(context),
    );
  }

  FutureBuilder<Response> _buildBody(BuildContext context) {
    return FutureBuilder<Response>(
      future: Provider.of<SpacexApiService>(context).getPastLaunches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List rockets = json.decode(snapshot.data.bodyString);
          return _buildPosts(context, rockets);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ListView _buildPosts(BuildContext context, List rockets) {
    return ListView.builder(
      itemCount: rockets.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          child: ListTile(
            title: Text(
              rockets[index]['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              rockets[index]['date_utc'],
              softWrap: false,
              overflow: TextOverflow.clip,
            ),
            onTap: () =>
                _navigateToLaunchDetails(context, rockets[index]['rocket']),
          ),
        );
      },
    );
  }

  void _navigateToLaunchDetails(BuildContext context, String id) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LaunchDetailsPage(
          launchId: id,
        ),
      ),
    );
  }
}
