import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Launcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        title: Text('Defence Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage('assets/selfDefence.png'),
            ),
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
        height: 60,
        width: 380,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            color: Colors.blue[100],
            splashColor: Colors.amberAccent,
            onPressed: onTap));
  }
}

Future<void> openUrl(String url,
    {bool forceWebView = false, bool enableJavaScript = false}) async {
  await launch(url);
}
