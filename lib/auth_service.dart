import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get user => _auth.authStateChanges();

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Ошибка входа: ${e.message}");
      return null;
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Ошибка регистрации: ${e.message}");
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      print("Ошибка выхода: $e");
    }
  }

  Future<void> saveUserPreferences(String userId, Map<String, dynamic> prefs) async {
    try {
      await _firestore.collection('userPreferences').doc(userId).set(prefs);
    } catch (e) {
      print("Ошибка сохранения настроек: $e");
    }
  }

  Future<Map<String, dynamic>> getUserPreferences(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('userPreferences').doc(userId).get();
      return doc.exists ? doc.data() as Map<String, dynamic> : {};
    } catch (e) {
      print("Ошибка загрузки настроек: $e");
      return {};
    }
  }
}