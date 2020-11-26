class Contact {
  final String contactName;
  final String phoneNo;
  final String id;

  Contact({this.contactName, this.phoneNo, this.id});

  Contact.fromMap(Map<String, dynamic> data, String id)
      : contactName = data["contactName"],
        phoneNo = data['phoneNo'],
        id = id;

  Map<String, dynamic> toMap() {
    return {
      "contactName": contactName,
      "phoneNo": phoneNo,
    };
  }

  String toString() => toMap().toString();
}
