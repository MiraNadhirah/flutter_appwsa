import 'package:flutter/material.dart';
import 'package:flutter_wsa/contact_data.dart';

class ContactDetailsPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailsPage({Key key, @required this.contact}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              contact.contactName,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            const SizedBox(height: 20.0),
            Text(
              contact.phoneNo,
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
