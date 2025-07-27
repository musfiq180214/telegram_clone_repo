import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../views/login_screen.dart';
import '../views/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthController extends GetxController {

  var isLoggedIn = false.obs;  // reactive boolean for login state

  static AuthController instance = Get.find();

  FirebaseAuth auth = FirebaseAuth.instance;

  var user = Rxn<User>();
  var isLoading = false.obs; // ✅ Add this line

  @override
  void onInit() {
    super.onInit();

    user.value = auth.currentUser;

    auth.authStateChanges().listen((firebaseUser) {
    user.value = firebaseUser;
    isLoggedIn.value = firebaseUser != null;
    });
  }


  void register(String name, String email, String password) async {
  try {
    isLoading.value = true;

    // Create user
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = userCredential.user;

    // Update displayName
    await user?.updateDisplayName(name);

    // ✅ Save user info to Firestore
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'uid': user.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Optional: store in GetX observable
      this.user.value = user;
    }

    // Navigate to HomeScreen
    Get.offAll(() => HomeScreen());

  } catch (e) {
    Get.snackbar("Registration Failed", e.toString());
  } finally {
    isLoading.value = false;
  }
}



  void login(String email, String password) async {
    try {
      isLoading.value = true;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      Get.offAll(() => HomeScreen());
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
    isLoggedIn.value = true; // set to true when logged in
  }

  void logout() async {
  try {
    await auth.signOut();
    isLoggedIn.value = false; // update login state
    Get.offAll(() => LoginScreen());
  } catch (e) {
    Get.snackbar("Logout Failed", e.toString());
  }
}

}
