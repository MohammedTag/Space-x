import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_flutter_app/data/post_api_service.dart';

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
        future: Provider.of<PostApiService>(context).getRocket(launchId).then(
            (launchpad) => Provider.of<PostApiService>(context)
                .getLaunchpad(launchpad.toString())),
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

  /* body: MultiProvider(
          providers: [
            Provider<PostApiService>(create: (_) => rocketDetails(context)),
            /*Provider<SomethingElse>(create: (_) => SomethingElse()),
            Provider<AnotherThing>(create: (_) => AnotherThing()),*/
          ],
         // child: _buildDetails(),
        )*/
  Provider<PostApiService> rocketDetails(BuildContext context) {
    return Provider(
        create: (_) => PostApiService.create(),
        dispose: (_, PostApiService service) => service.client.dispose(),
        child: _buildBody(context));
  }

  FutureBuilder<Response> _buildBody(BuildContext context) {
    return FutureBuilder<Response>(
      // 2
      future: Provider.of<PostApiService>(context).getRocket(launchId),
      builder: (context, snapshot) {
        // 3
        if (snapshot.connectionState == ConnectionState.done) {
          // 4
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          }
          // 5
          Map popular = snapshot.data.body;
          // 6
          return _buildDetails(popular);
        } else {
          // 7
          // Show a loading indicator while waiting for the movies
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
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
