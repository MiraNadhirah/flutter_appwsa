import 'package:flutter/material.dart';
import 'package:flutter_wsa/contact_data.dart';
import 'package:flutter_wsa/firestore_service.dart';
import 'package:flutter_wsa/services/auth_service.dart';
import 'package:flutter_wsa/widget/provider_widget.dart';
import 'package:flutter/services.dart';

class AddContactPage extends StatefulWidget {
  final Contact contact;

  const AddContactPage({
    Key key,
    this.contact,
  }) : super(key: key);
  @override
  _AddContactPageState createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController _contactNameController;
  TextEditingController _phoneNoController;
  FocusNode _phoneNoNode;

  @override
  void initState() {
    super.initState();
    _contactNameController = TextEditingController(
        text: isEditMote ? widget.contact.contactName : '');
    _phoneNoController =
        TextEditingController(text: isEditMote ? widget.contact.phoneNo : '');
    _phoneNoNode = FocusNode();
  }

  get isEditMote => widget.contact != null;

  @override
  Widget build(BuildContext context) {
    AuthService provider = Provider.of(context).auth;
    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(
        title: Text(isEditMote ? 'Edit Contact' : 'Add Contact'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  FocusScope.of(context).requestFocus(_phoneNoNode);
                },
                controller: _contactNameController,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return "Name cannot be empty";
                  return null;
                },
                decoration: InputDecoration(
                  labelText: "Name",
                  border: OutlineInputBorder(),
                  icon: Icon(Icons.people),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                focusNode: _phoneNoNode,
                controller: _phoneNoController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                decoration: InputDecoration(
                    labelText: "Phone Number",
                    border: OutlineInputBorder(),
                    icon: Icon(Icons.phone_iphone)),
              ),
              const SizedBox(height: 10.0),
              RaisedButton(
                color: Theme.of(context).primaryColor,
                textColor: Colors.white,
                child: Text(isEditMote ? "Update" : "Save"),
                onPressed: () async {
                  if (_key.currentState.validate()) {
                    try {
                      if (isEditMote) {
                        Contact contact = Contact(
                          phoneNo: _phoneNoController.text,
                          contactName: _contactNameController.text,
                          id: widget.contact.id,
                        );
                        await FirestoreService().updateContact(contact);
                      } else {
                        Contact contact = Contact(
                          phoneNo: _phoneNoController.text,
                          contactName: _contactNameController.text,
                        );
                        await FirestoreService().addContact(
                            await provider.getCurrentUID(), contact);
                      }
                      Navigator.pop(context);
                    } catch (e) {
                      print(e);
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
