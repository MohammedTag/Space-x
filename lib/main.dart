import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/spacex_api_service.dart';
import 'ui/home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      // The initialized PostApiService is now available down the widget tree
      create: (_) => SpacexApiService.create(),
      // Always call dispose on the ChopperClient to release resources
      dispose: (context, SpacexApiService service) => service.client.dispose(),
      child: MaterialApp(
        title: 'Material App',
        home: HomePage(),
      ),
    );
  }
}
