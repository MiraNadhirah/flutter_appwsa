import 'package:flutter/material.dart';

class Tips extends StatefulWidget {
  @override
  _TipsState createState() => _TipsState();
}

class _TipsState extends State<Tips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.pink[200],
        appBar: AppBar(
          title: Text('Tips For Women Safety'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image(
                image: AssetImage('assets/tips.jpg'),
              ),
              Text(
                '\n\n1. Walk with a buddy whenever possible. If you are walking alone at night, stay near well lit places of business and well lit walk ways. Avoid alleys and other poorly lit, closed spaces that might allow an attacker the advantage of surprise.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '\n\n2. Never pull over when someone points at your car, claiming that something is wrong. Suspects use this tactic to get you to open your window or get out of the car. Rather drive to the nearest garage or shop where you will be safe to have a look yourself or can ask for assistance.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '\n\n3. Always remember to lock your doors when driving. Suspects often hijack or smash-and-grab motorists stopped at a red traffic light. Don’t make it any easier for them by simply leaving your doors unlocked.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '\n\n4. Limit distractions in parking lots. Tuck your phone safely in your purse so you can keep your head up to look around and pay attention to your surroundings.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '\n\n5. Your eyes should be watching where you are going and scanning your surroundings.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '\n\n6. Trust your gut when parking your car. If you feel uneasy about where you have just parked, put it in drive and keep moving. Park as close as possible to your destination.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              Text(
                '\n\n7. Be mindful of the way you dress, especially if you will be walking alone. Shoes like wedges and high heels, and tight skirts, will be hard to run in while scarves and long necklaces are easy to grab. Play a scenario through your mind and try to determine if you would be able to easily defend yourself with what you’re wearing.\n\n ',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
        ));
  }
}
