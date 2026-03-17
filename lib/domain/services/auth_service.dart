import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<UserCredential> register({
    required String email,
    required String password,
    required String name,
    String? school,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    
    // Save user profile to Firestore
    await _firestore.collection('users').doc(credential.user!.uid).set({
      'name': name,
      'email': email,
      'school': school,
      'grade': '10th',
      'createdAt': FieldValue.serverTimestamp(),
      'quizTaken': false,
    });

    return credential;
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }
  
  Future<void> updateUserProfile({
    required String uid,
    required String name,
    required String school,
    required String grade,
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'name': name,
      'school': school,
      'grade': grade,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    // Also update FirebaseAuth display name
    await _auth.currentUser?.updateDisplayName(name);
  }

  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      // Delete from Firestore first
      await _firestore.collection('users').doc(user.uid).delete();
      // Delete from FirebaseAuth
      await user.delete();
    }
  }
}
