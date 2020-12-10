import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Defence Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LaunchButton('Self-Defense Techniques for Women', () async {
              await openUrl('https://www.youtube.com/watch?v=T7aNSRoDCmg');
            }),
            LaunchButton('Self-Defense Moves Every Woman Should Know',
                () async {
              await openUrl('https://www.youtube.com/watch?v=KVpxP3ZZtAc');
            }),
            LaunchButton('Self Defence', () async {
              await openUrl('https://www.youtube.com/watch?v=84Z60dOLrsg');
            }),
          ],
        ),
      ),
    );
  }
}

class LaunchButton extends StatelessWidget {
  final String text;
  final Function onTap;
  LaunchButton(this.text, this.onTap);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 200,
        child: RaisedButton(
            child: Text(text), color: Colors.blue[100], onPressed: onTap));
  }
}

Future<void> openUrl(String url,
    {bool forceWebView = false, bool enableJavaScript = false}) async {
  await launch(url);
}
