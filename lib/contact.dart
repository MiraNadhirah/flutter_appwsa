import 'package:flutter/material.dart';
import 'package:flutter_wsa/contact_add.dart';
import 'package:flutter_wsa/contact_details.dart';
import 'package:flutter_wsa/firestore_service.dart';

import 'contact_data.dart';
import 'widget/provider_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: StreamBuilder(
        stream: FirestoreService()
            .contactSnapshots(Provider.of(context).auth.getCurrentUID()),
        builder: (BuildContext context, AsyncSnapshot<List<Contact>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              Contact contact = snapshot.data[index];

              return ListTile(
                title: Text(contact.contactName),
                subtitle: Text(contact.phoneNo),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      color: Colors.blue,
                      icon: Icon(Icons.edit),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AddContactPage(contact: contact),
                          )),
                    ),
                    IconButton(
                      color: Colors.red,
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteContact(context, contact.id),
                    ),
                  ],
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ContactDetailsPage(
                      contact: contact,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AddContactPage()));
        },
      ),
    );
  }

  void _deleteContact(BuildContext context, String id) async {
    if (await _showConfirmationDialog(context)) {
      try {
        await FirestoreService().deleteContact(id);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => AlertDialog(
              content: Text("Are you sure you want to delete?"),
              actions: <Widget>[
                FlatButton(
                  textColor: Colors.red,
                  child: Text("Delete"),
                  onPressed: () => Navigator.pop(context, true),
                ),
                FlatButton(
                  textColor: Colors.black,
                  child: Text("No"),
                  onPressed: () => Navigator.pop(context, false),
                ),
              ],
            ));
  }
}
