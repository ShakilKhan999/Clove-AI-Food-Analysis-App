import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_recepi/auth/views/info_screen_four.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../bottom_nevigation/views/mobile_bottom.dart';
import '../../views/predic_screen.dart';
import '../views/login_screen.dart';
import '../views/verifi_code_screen.dart';

class AuthService extends GetxService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Observables to track authentication state
  final Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    // Bind the firebase user stream to track changes in authentication state
    firebaseUser.bindStream(auth.authStateChanges());
  }

  /// Login with email and password
  Future<void> login({required String email, required String password}) async {
    try {
      // Sign in the user
      await auth.signInWithEmailAndPassword(email: email, password: password);

      // Reload the user's information to ensure email verification status is updated
      firebaseUser.value = auth.currentUser;
      await firebaseUser.value?.reload();

      if (firebaseUser.value?.emailVerified ?? false) {
        // Email is verified, navigate to home screen
        Get.offAll(CustomBottomNavBar());
      } else {
        // Email is not verified, navigate to verification screen
        Get.offAll(() => VerifiCodeScreen());
        Get.snackbar(
          'Email Not Verified',
          'Please verify your email before proceeding.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password. Please try again.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      Get.snackbar(
        'Login Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Logout the user
  Future<void> logout() async {
    try {
      // Check if the current user is signed in with Google
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );
      bool isGoogleUser = await googleSignIn.isSignedIn();

      if (isGoogleUser) {
        // Sign out from Google
        await googleSignIn.signOut();
      }

      // Sign out from Firebase (this will handle email/password sign-in as well)
      await auth.signOut();

      // Navigate back to the login screen
      Get.offAll(() => LoginScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to logout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String fullName,
    required String address,
    required String mobile,
  }) async {
    try {
      // Register the user
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Delay to ensure user credentials are initialized
      await Future.delayed(Duration(seconds: 1));

      // Send email verification
      await userCredential.user!.sendEmailVerification().catchError((e) {
        // If email verification fails, delete the user and show an error
        userCredential.user!.delete();
        throw FirebaseAuthException(
          code: 'email-verification-failed',
          message: 'Failed to send email verification. Please try again.',
        );
      });

      // Add user details to Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'fullName': fullName,
        'address': address,
        'mobile': mobile,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Show success message
      Get.snackbar(
        'Registration Successful',
        'A verification email has been sent to your email address. Please verify it before logging in.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Update the current user
      firebaseUser.value = auth.currentUser;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'This email is already in use.';
          break;
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
          break;
        case 'email-verification-failed':
          errorMessage = e.message!;
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      Get.snackbar(
        'Registration Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> registerWithGoogle() async {
    try {
      UserCredential userCredential;

      if (Platform.isAndroid || Platform.isIOS) {
        // Mobile sign in
        final GoogleSignIn googleSignIn = GoogleSignIn(
          scopes: [
            'email',
            'https://www.googleapis.com/auth/userinfo.profile',
          ],
        );

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) return;

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await auth.signInWithCredential(credential);
      } else {
        // Web sign in
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider
            .addScope('https://www.googleapis.com/auth/userinfo.email');
        googleProvider
            .addScope('https://www.googleapis.com/auth/userinfo.profile');

        userCredential = await auth.signInWithPopup(googleProvider);
      }

      if (userCredential.user != null) {
        // Send email verification if email not verified
        if (!userCredential.user!.emailVerified) {
          await userCredential.user!.sendEmailVerification().catchError((e) {
            userCredential.user!.delete();
            throw FirebaseAuthException(
              code: 'email-verification-failed',
              message: 'Failed to send email verification. Please try again.',
            );
          });
        }

        // Add user details to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': userCredential.user!.email,
          'fullName': userCredential.user!.displayName ?? '',
          'address': '', // These can be updated later
          'mobile': '', // These can be updated later
          'createdAt': FieldValue.serverTimestamp(),
          'photoURL': userCredential.user!.photoURL,
          'isGoogleSignIn': true,
        });

        // Show success message
        Get.snackbar(
          'Registration Successful',
          !userCredential.user!.emailVerified
              ? 'A verification email has been sent to your email address. Please verify it before logging in.'
              : 'Successfully registered with Google.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Update the current user
        firebaseUser.value = auth.currentUser;

        Get.offAll(() => CustomBottomNavBar());
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'An account already exists with this email.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign-in is not enabled.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for this email.';
          break;
        case 'email-verification-failed':
          errorMessage = e.message!;
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      Get.snackbar(
        'Registration Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      // Check if the user is already signed in
      if (auth.currentUser != null) {
        print('User is already logged in: ${auth.currentUser!.email}');
        return; // Skip the Google Sign-In process
      }

      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
        ],
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          final userDoc = await FirebaseFirestore.instance
              .collection('users')
              .doc(userCredential.user!.uid)
              .get();

          if (!userDoc.exists) {
            await FirebaseFirestore.instance
                .collection('users')
                .doc(userCredential.user!.uid)
                .set({
              'email': userCredential.user!.email,
              'fullName': userCredential.user!.displayName ?? '',
              'photoURL': userCredential.user!.photoURL,
              'createdAt': FieldValue.serverTimestamp(),
              'isGoogleSignIn': true,
            });
          }

          firebaseUser.value = auth.currentUser;

          if (!userCredential.user!.emailVerified) {
            Get.to(() => VerifiCodeScreen());
          } else {
            // Get.offAll(() => PredicScreen(analysisResponse: null));
            Get.offAll(CustomBottomNavBar());
          }

          Get.snackbar(
            'Success',
            'Successfully logged in with Google',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'account-exists-with-different-credential':
          errorMessage = 'An account already exists with this email.';
          break;
        case 'invalid-credential':
          errorMessage = 'Invalid credentials.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Google sign-in is not enabled.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        case 'user-not-found':
          errorMessage = 'No user found for this email.';
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}';
      }
      Get.snackbar(
        'Login Failed',
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> addMenuItem({
    required String foodName,
    required int kCal,
    required String category,
    required DateTime dateTime, // Added DateTime parameter
  }) async {
    try {
      // Check if firebaseUser is null
      if (auth.currentUser == null) {
        print('Error: firebaseUser is null');
        return;
      }

      print('firebaseUser UID: ${auth.currentUser!.uid}');

      // Check if parameters are null or invalid
      if (foodName.isEmpty) {
        print('Error: foodName is null or empty');
        return;
      }
      if (category.isEmpty) {
        print('Error: category is null or empty');
        return;
      }

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Generate a unique document ID
      String docId = firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('menu')
          .doc()
          .id;

      // Create the data to be added
      Map<String, dynamic> menuItem = {
        'foodName': foodName,
        'kCal': kCal,
        'foodId': docId, // Using the generated docId as foodId
        'category': category,
        'dateTime': dateTime, // Storing DateTime directly
      };

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('menu')
          .doc(docId)
          .set(menuItem);

      print('Menu item added successfully!');
    } catch (e) {
      print('Error adding menu item: $e');
    }
  }

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<List<Map<String, dynamic>>> getMenuItems(DateTime selectedDate) async {
    try {
      // Normalize selectedDate to match the start and end of the day
      DateTime startOfDay =
          DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      DateTime endOfDay = startOfDay.add(Duration(days: 1));

      // Fetch documents from the menu collection within the date range
      QuerySnapshot querySnapshot = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('menu')
          .where('dateTime',
              isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay))
          .where('dateTime', isLessThan: Timestamp.fromDate(endOfDay))
          .get();

      // Convert the query results into a list of maps
      List<Map<String, dynamic>> mealList = querySnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();

      print(
          'Retrieved ${mealList.length} menu items for the date: $selectedDate');
      return mealList;
    } catch (e) {
      print('Error retrieving menu items: $e');
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> getAllMenuItems() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('menu')
        .orderBy('dateTime',
            descending: false) // Order by dateTime ascending if needed
        .snapshots() // Real-time updates
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    });
  }

  Stream<Map<String, dynamic>?> getUserDocAsMapRealtime() {
    // Create a stream for the document
    return FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .snapshots()
        .map((docSnapshot) {
      if (docSnapshot.exists) {
        // Return the document data as a Map
        return docSnapshot.data();
      } else {
        // Return null if the document does not exist
        return null;
      }
    });
  }

  /// Check if the user is logged in
  bool isLoggedIn() {
    return firebaseUser.value != null;
  }
}
