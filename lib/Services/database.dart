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

  Future<void> addUserBooking(
      String userId, Map<String, dynamic> userInfoMap) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("Booking")
        .add(userInfoMap);
  }

  Future<void> addAdminTicket(Map<String, dynamic> userInfoMap) async {
    await FirebaseFirestore.instance
        .collection("adminTickets")
        .add(userInfoMap);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getBookings(String id) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Booking")
        .snapshots();
  }
}
