import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_wsa/contact_data.dart';

class FirestoreService {
  static final FirestoreService _firestoreService =
      FirestoreService._internal();
  FirebaseFirestore _db = FirebaseFirestore.instance;

  FirestoreService._internal();

  factory FirestoreService() {
    return _firestoreService;
  }

  Future<List<Contact>> getContacts(String uid) {
    return _db
        .collection('contacts')
        .where("owned_by", isEqualTo: uid)
        .get()
        .then(
          (value) => value.docs
              .map(
                (doc) => Contact.fromMap(doc.data(), doc.id),
              )
              .toList(),
        );
  }

  Stream<List<Contact>> contactSnapshots(String uid) {
    return _db
        .collection('contacts')
        .where("owned_by", isEqualTo: uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => Contact.fromMap(doc.data(), doc.id),
              )
              .toList(),
        );
  }

  Future<void> addContact(String ownId, Contact contact) {
    return _db
        .collection('contacts')
        .add(contact.toMap()..addAll({"owned_by": ownId}));
  }

  Future<void> deleteContact(String id) {
    return _db.collection('contacts').doc(id).delete();
  }

  Future<void> updateContact(Contact contact) {
    return _db.collection('contacts').doc(contact.id).update(contact.toMap());
  }
}
