import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/food_analysis_model.dart';
import 'log_model.dart'; // Ensure you import your LogModel here.

class LogRepo{
  Stream<List<LogModel>> getRealtimeLogs(String authUserId) {
    try {
      final logsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(authUserId)
          .collection('logs');

      // Stream to listen for real-time updates, ordered by logTime
      return logsCollection
          .orderBy('logTime', descending: true)
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs
            .map((doc) => LogModel.fromJson(doc.data()))
            .toList();
      });
    } catch (e) {
      print('Error setting up real-time listener: $e');
      return const Stream.empty();
    }
  }
  Future<void> createLog(String authUserId, FoodAnalysisResponse response) async {
    try {
      // Reference to the logs collection
      final logsCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(authUserId)
          .collection('logs');

      // Add a new document with logTime set to DateTime.now()
      await logsCollection.add({
        ...response.toJson(), // Spread existing fields from the response
        'logTime': DateTime.now(), // Override or add the logTime field
      });

      print('Log added successfully!');
    } catch (e) {
      print('Error adding log: $e');
    }
  }
}