import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:futurenext/data/models/career_model.dart';
import 'package:futurenext/data/local/career_data.dart';

class CareerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<CareerCategory> getCategories() {
    return CareerData.categories;
  }

  CareerCategory? getCategoryById(String id) {
    try {
      return CareerData.categories.firstWhere((cat) => cat.id == id);
    } catch (e) {
      return null;
    }
  }

  SubCareer? getSubCareerById(String categoryId, String subCareerId) {
    final category = getCategoryById(categoryId);
    if (category == null) return null;
    try {
      return category.subCareers.firstWhere((sc) => sc.id == subCareerId);
    } catch (e) {
      return null;
    }
  }

  // User Saved Careers
  Future<void> saveCareer(String userId, SubCareer career) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_careers')
        .doc(career.id)
        .set({
      'id': career.id,
      'title': career.title,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<String>> getSavedCareerIds(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_careers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }
}
