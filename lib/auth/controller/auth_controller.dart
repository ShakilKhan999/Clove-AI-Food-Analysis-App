import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../views/verifi_code_screen.dart';
import 'auth_serviece.dart';

class AuthController extends GetxController {
  final AuthService authService = Get.put(AuthService());
  // Form controllers
  final TextEditingController ageController = TextEditingController();
  final TextEditingController biometricsController = TextEditingController();
  final TextEditingController fastingGlucoseController = TextEditingController();
  final TextEditingController sleepQualityController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController verificationCodeController = TextEditingController();

  // Form validation states
  final RxBool isEmailValid = false.obs;
  final RxBool isPasswordValid = false.obs;
  final RxBool isFullNameValid = false.obs;
  final RxBool isMobileValid = false.obs;
  final RxBool isAddressValid = false.obs;
  final RxBool isAgeValid = false.obs;
  final RxBool isFastingGlucoseValid = false.obs;
  var isPasswordVisible = false.obs;
  var isMealTracking = false.obs;
  var mealName="".obs;
  var mealList=[].obs;
  var allMealList=[].obs;
  var homeRouteIndex=100.obs;
  var weekOffset = 0.obs;

  // Error messages
  final RxString emailError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString fullNameError = ''.obs;
  final RxString mobileError = ''.obs;
  final RxString addressError = ''.obs;
  final RxString ageError = ''.obs;
  final RxString fastingGlucoseError = ''.obs;
  var userInfo=[].obs;
  final TextEditingController appNameController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isAuthenticated = false.obs;

  // Health checkboxes
  final RxMap<String, bool> checkboxValues = {
    'I\'m not type 1 diabetic or taking insulin': false,
    'I do not have an active diagnosis of kidney disease': false,
    'I\'m not pregnant': false,
    'I\'m not vegan': false,
  }.obs;

  // Activity and exercise tracking
  final RxString activityLevel = ''.obs;
  final List<String> activityLevels = [
    'Sedentary (minimal physical activity)',
    'Lightly Active (walking, light housework)',
    'Moderately Active (regular exercise 2-3 times per week)',
    'Very Active (intense exercise 5+ times per week)',
  ];

  final RxDouble height = 170.0.obs;
  final RxDouble weight = 70.0.obs;
  final RxDouble sleepHours = 7.0.obs;
  final RxDouble stressLevel = 5.0.obs;
  final RxBool agreeToPolicy = false.obs;

  final RxMap<String, bool> exerciseTypes = {
    'Walking': false,
    'Running/Jogging': false,
    'Weightlifting': false,
    'Yoga': false,
    'Other': false,
  }.obs;

  // Progress tracking
  final RxDouble progress = 0.4.obs;
  Timer? _timer;
  var selectedDate=DateTime.now().obs;

  @override
  void onInit() {

    super.onInit();
   // startProgress();
    _setupValidationListeners();
  }

  Future<void> getData() async{
    isLoading.value=true;
    await getMeals(selectedDate.value);
    listenToMeals();
    listenToUserDoc();
    isLoading.value=false;
  }

var todayCalories=0.obs;
  Future<void> getMeals(var date)async{
    isLoading.value=true;
    mealList.value= await authService.getMenuItems(date);
    isLoading.value=false;
  }
  void listenToUserDoc() {
    AuthService().getUserDocAsMapRealtime().listen((userData) {
      if (userData != null) {
        userInfo.clear();
        userInfo.add(userData);
      } else {

      }
    });
  }
  void listenToMeals() async{
    isLoading.value=true;
    AuthService().getAllMenuItems().listen((logs) {
      allMealList.value=logs;
      log('Received meals update: ${allMealList.length}');

    });
    isLoading.value=false;
  }
  void _setupValidationListeners() {
    // Setup debounced validation listeners
    ever(RxString(emailController.text), validateEmail);
    ever(RxString(passwordController.text), validatePassword);
    ever(RxString(fullNameController.text), validateFullName);
    ever(RxString(mobileController.text), validateMobile);
    ever(RxString(addressController.text), validateAddress);
    ever(RxString(ageController.text), validateAge);
    ever(RxString(fastingGlucoseController.text), validateFastingGlucose);
  }

  // Validation methods
  void validateEmail(String value) {
    if (value.isEmpty) {
      emailError.value = 'Email is required';
      isEmailValid.value = false;
    } else if (!GetUtils.isEmail(value)) {
      emailError.value = 'Please enter a valid email';
      isEmailValid.value = false;
    } else {
      emailError.value = '';
      isEmailValid.value = true;
    }
  }

  void validatePassword(String value) {
    if (value.isEmpty) {
      passwordError.value = 'Password is required';
      isPasswordValid.value = false;
    } else if (value.length < 6) {
      passwordError.value = 'Password must be at least 6 characters';
      isPasswordValid.value = false;
    } else {
      passwordError.value = '';
      isPasswordValid.value = true;
    }
  }

  void validateFullName(String value) {
    if (value.isEmpty) {
      fullNameError.value = 'Full name is required';
      isFullNameValid.value = false;
    } else if (value.length < 3) {
      fullNameError.value = 'Name must be at least 3 characters';
      isFullNameValid.value = false;
    } else {
      fullNameError.value = '';
      isFullNameValid.value = true;
    }
  }

  void validateMobile(String value) {
    if (value.isEmpty) {
      mobileError.value = 'Mobile number is required';
      isMobileValid.value = false;
    } else if (!GetUtils.isPhoneNumber(value)) {
      mobileError.value = 'Please enter a valid mobile number';
      isMobileValid.value = false;
    } else {
      mobileError.value = '';
      isMobileValid.value = true;
    }
  }



  Future<void> login() async {
    if (!_validateLoginForm()) return;

    try {
      isLoading.value = true;

      // Call the AuthService's login method
      await authService.login(
        email: emailController.text,
        password: passwordController.text,
      );
     // getData();
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
    } finally {
      isLoading.value = false;
    }
  }

  void validateAddress(String value) {
    if (value.isEmpty) {
      addressError.value = 'Address is required';
      isAddressValid.value = false;
    } else if (value.length < 5) {
      addressError.value = 'Please enter a valid address';
      isAddressValid.value = false;
    } else {
      addressError.value = '';
      isAddressValid.value = true;
    }
  }

  void validateAge(String value) {
    if (value.isEmpty) {
      ageError.value = 'Age is required';
      isAgeValid.value = false;
    } else {
      final age = int.tryParse(value);
      if (age == null || age < 18 || age > 120) {
        ageError.value = 'Please enter a valid age between 18 and 120';
        isAgeValid.value = false;
      } else {
        ageError.value = '';
        isAgeValid.value = true;
      }
    }
  }

  void validateFastingGlucose(String value) {
    if (value.isEmpty) {
      fastingGlucoseError.value = 'Fasting glucose is required';
      isFastingGlucoseValid.value = false;
    } else {
      final glucose = double.tryParse(value);
      if (glucose == null || glucose < 50 || glucose > 400) {
        fastingGlucoseError.value = 'Please enter a valid glucose level (50-400 mg/dL)';
        isFastingGlucoseValid.value = false;
      } else {
        fastingGlucoseError.value = '';
        isFastingGlucoseValid.value = true;
      }
    }
  }

  // Authentication methods

  Future<void> signup() async {
    if (!_validateSignupForm()) return;

    try {
      isLoading.value = true;

      // Call AuthService to register the user
      await AuthService().register(
        email: emailController.text,
        password: passwordController.text,
        fullName: fullNameController.text,
        address: addressController.text,
        mobile: mobileController.text,
      );
     // getData();

      // Navigate to the verification screen after successful registration
      Get.to(VerifiCodeScreen());
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign up: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateLoginForm() {
    validateEmail(emailController.text);
    validatePassword(passwordController.text);

    return isEmailValid.value && isPasswordValid.value;
  }

  bool _validateSignupForm() {
    // Validate each field and update the validation state
    validateEmail(emailController.text);
    validatePassword(passwordController.text);
    validateFullName(fullNameController.text);
    validateMobile(mobileController.text);
    validateAddress(addressController.text);

    // Show error messages based on validation state
    if (!isEmailValid.value) {
      Get.snackbar(
        'Invalid Email',
        'Please enter a valid email address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    if (!isPasswordValid.value) {
      Get.snackbar(
        'Invalid Password',
        'Password must be at least 6 characters long.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    if (!isFullNameValid.value) {
      Get.snackbar(
        'Invalid Full Name',
        'Please enter your full name.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    if (!isMobileValid.value) {
      Get.snackbar(
        'Invalid Mobile Number',
        'Please enter a valid mobile number.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    if (!isAddressValid.value) {
      Get.snackbar(
        'Invalid Address',
        '${addressError.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    // Check if the user agreed to the policy
    if (!agreeToPolicy.value) {
      Get.snackbar(
        'Agreement Required',
        'You must agree to the policy to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    // Return whether all validations are passed
    return isEmailValid.value &&
        isPasswordValid.value &&
        isFullNameValid.value &&
        isMobileValid.value &&
        isAddressValid.value &&
        agreeToPolicy.value;
  }

  // Helper methods
  void updateCheckbox(String key, bool? value) {
    checkboxValues[key] = value ?? false;
  }

  void updateExerciseType(String type, bool? value) {
    exerciseTypes[type] = value ?? false;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void startProgress() {
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (progress.value < 1.0) {
        progress.value += 0.01;
      } else {
        _timer?.cancel();
      }
    });
  }

  void onNextPressed() {
    // Validate all required fields
    if (!_validateHealthForm()) return;

    print('Form Data:');
    print('Age: ${ageController.text}');
    print('Biometrics: ${biometricsController.text}');
    print('Activity Level: ${activityLevel.value}');
    print('Height: ${height.value}');
    print('Weight: ${weight.value}');
    print('Exercise Types: $exerciseTypes');
    print('Fasting Glucose: ${fastingGlucoseController.text}');
    print('Sleep Hours: ${sleepHours.value}');
    print('Sleep Quality: ${sleepQualityController.text}');
    print('Stress Level: ${stressLevel.value}');
  }

  bool _validateHealthForm() {
    validateAge(ageController.text);
    validateFastingGlucose(fastingGlucoseController.text);

    final bool isHealthCheckboxesValid = checkboxValues.values.every((value) => value);
    final bool isActivityLevelValid = activityLevel.value.isNotEmpty;

    if (!isHealthCheckboxesValid) {
      Get.snackbar(
        'Error',
        'Please confirm all health conditions',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (!isActivityLevelValid) {
      Get.snackbar(
        'Error',
        'Please select your activity level',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return isAgeValid.value &&
        isFastingGlucoseValid.value &&
        isHealthCheckboxesValid &&
        isActivityLevelValid;
  }

  @override
  void onClose() {
    _timer?.cancel();
    ageController.dispose();
    biometricsController.dispose();
    fastingGlucoseController.dispose();
    sleepQualityController.dispose();
    fullNameController.dispose();
    addressController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    verificationCodeController.dispose();
    super.onClose();
  }


  Future<void> updateAppDetails(String uid, String appName, String? imageUrl) async {
    try {
      final docRef = FirebaseFirestore.instance.collection('users').doc(uid);

      // Create update map with non-null values only
      Map<String, dynamic> updateData = {};
      if (appName.isNotEmpty) {
        updateData['appName'] = appName;
      }
      if (imageUrl != null) {
        updateData['appImage'] = imageUrl;
      }

      // Update document
      await docRef.set(updateData, SetOptions(merge: true));

      // Update local userInfo
      if (userInfo.isNotEmpty) {
        userInfo[0]['appName'] = appName;
        if (imageUrl != null) {
          userInfo[0]['appImage'] = imageUrl;
        }
      }
    } catch (e) {
      print('Error updating app details: $e');
      Get.snackbar('Error', 'Failed to update app details');
    }
  }

  // Method to upload image to Firebase Storage
  Future<String?> uploadImageToStorage(File imageFile, String uid) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('app_images/$uid.jpg');

      await imageRef.putFile(imageFile);
      final downloadUrl = await imageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      Get.snackbar('Error', 'Failed to upload image');
      return null;
    }
  }

  // Method to pick image from gallery
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        selectedImage = File(image.path);
        // Force UI update to show picked image
        update(['imagePreview']);
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  void showAppDetailsDialog(BuildContext context) {
    appNameController.text = userInfo.isNotEmpty && userInfo[0]['appName'] != null
        ? userInfo[0]['appName']
        : '';

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Rounded corners
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0), // Padding around the dialog
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update App Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),
              // Image Picker with modern UI
              GetBuilder<AuthController>(
                id: 'imagePreview',
                builder: (controller) {
                  return GestureDetector(
                    onTap: () => controller.pickImage(),
                    child: Container(
                      height: 180,
                      width: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey[300]!),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (controller.selectedImage != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.file(
                                controller.selectedImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                          else if (controller.userInfo.isNotEmpty &&
                              controller.userInfo[0]['appImage'] != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                controller.userInfo[0]['appImage'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            )
                          else
                            Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey[500]),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: Container(
                              padding: EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black54,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              // App Name Input Field with modern style
              TextFormField(
                controller: appNameController,
                decoration: InputDecoration(
                  labelText: 'App Name',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                ),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              // Update Button with modern design
              ElevatedButton(
                onPressed: () async {
                  String? imageUrl;
                  if (selectedImage != null) {
                    imageUrl = await uploadImageToStorage(
                        selectedImage!,
                        AuthService().auth.currentUser!.uid
                    );
                  }

                  await updateAppDetails(
                    AuthService().auth.currentUser!.uid,
                    appNameController.text,
                    imageUrl,
                  );

                  Get.back();
                  Get.snackbar('Success', 'App details updated successfully');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // Button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                child: Text(
                  'Update',
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }



}