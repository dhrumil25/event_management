import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("user")
        .doc(id)
        .set(userInfoMap);
  }

  Future addEventDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Event Details")
        .doc(id)
        .set(userInfoMap);
  }

 Stream<QuerySnapshot> getallEvents() {
  return FirebaseFirestore.instance.collection('Event Details').snapshots();
}

}
