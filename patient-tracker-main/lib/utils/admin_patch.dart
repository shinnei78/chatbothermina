import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> patchAllUsersWithDefaultFields() async {
  final firestore = FirebaseFirestore.instance;
  final usersSnapshot = await firestore.collection('users').get();

  for (final doc in usersSnapshot.docs) {
    final data = doc.data();
    final updates = <String, dynamic>{};

    if (!data.containsKey('dob')) updates['dob'] = '';
    if (!data.containsKey('gender')) updates['gender'] = '';
    if (!data.containsKey('phone')) updates['phone'] = '';
    if (!data.containsKey('address')) updates['address'] = '';
    if (!data.containsKey('bloodType')) updates['bloodType'] = '';
    if (!data.containsKey('allergies')) updates['allergies'] = [];
    if (!data.containsKey('photoUrl')) updates['photoUrl'] = '';

    if (updates.isNotEmpty) {
      await firestore.collection('users').doc(doc.id).update(updates);
      print('Updated user ${doc.id} with $updates');
    } else {
      print('No updates needed for user ${doc.id}');
    }
  }
}
