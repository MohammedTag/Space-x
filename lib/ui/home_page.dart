import 'dart:convert';

import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacex_flutter_app/data/post_api_service.dart';
import 'package:spacex_flutter_app/ui/launch_details.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chopper Blog'),
      ),
      body: _buildBody(context),
      /*   floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          // The JSONPlaceholder API always responds with whatever was passed in the POST request
          final response = await Provider.of<PostApiService>(context)
              .postPost({'key': 'value'});
          // We cannot really add any new posts using the placeholder API,
          // so just print the response to the console
          print(response.body);
        },
      ),*/
    );
  }

  FutureBuilder<Response> _buildBody(BuildContext context) {
    // FutureBuilder is perfect for easily building UI when awaiting a Future
    // Response is the type currently returned by all the methods of PostApiService
    return FutureBuilder<Response>(
      // In real apps, use some sort of state management (BLoC is cool)
      // to prevent duplicate requests when the UI rebuilds
      future: Provider.of<PostApiService>(context).getPastLaunches(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Snapshot's data is the Response
          // You can see there's no type safety here (only List<dynamic>)
          final List posts = json.decode(snapshot.data.bodyString);
          return _buildPosts(context, posts);
        } else {
          // Show a loading indicator while waiting for the posts
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ListView _buildPosts(BuildContext context, List posts) {
    return ListView.builder(
      itemCount: posts.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          child: ListTile(
            title: Text(
              posts[index]['name'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              posts[index]['date_utc'],
              softWrap: false,
              overflow: TextOverflow.clip,
            ),
            onTap: () =>
                _navigateToLaunchDetails(context, posts[index]['rocket']),
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
