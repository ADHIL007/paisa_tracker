import 'package:flutter/material.dart';
import 'package:paisa_tracker/theme/theme_provider.dart';

class HomeScreenMain extends StatefulWidget {
  const HomeScreenMain({Key? key}) : super(key: key);

  @override
  _HomeScreenMainState createState() => _HomeScreenMainState();
}

class _HomeScreenMainState extends State<HomeScreenMain> {
  @override
  Widget build(BuildContext context) {
    return Text(
      "home screen",
      style: TextStyle(color: customColors().textPrimary),
    );
  }
}
