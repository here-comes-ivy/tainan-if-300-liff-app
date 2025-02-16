import 'package:flutter/material.dart';
import 'package:flutter_line_liff/flutter_line_liff.dart';
import '../service_firebase/firebase_service.dart';
import 'dart:html' as html;
import 'package:flutter/foundation.dart' show kIsWeb;

class GlobalLiffData {
  static final FlutterLineLiff liffInstance = FlutterLineLiff.instance;
  static bool isLoggedIn = false;
  static bool isInitialized = false;

  static Uri? uri;
  static String? userId;

  static String? language;
  static String? lineVersion;
  static String? context;

  static String? decodedIDToken;
  static String? accessToken;
  static String? idToken;
  static bool? isInclient;
  static bool isSendMessage = false;

  static String? userName;
  static String? userPhotoUrl;

  static bool friendshipStatus = false;

  static List<Map<String, dynamic>> allLandmarkDetails = [];
  static Map<String, dynamic> landmarkDetails = {};
  static String? landmarkName;
  static String? password;
  static String? landmarkPictureUrl;
  static String? landmarkInfoTitle;
  static String? landmarkInfoDescription;

  static bool isLandmarkPageShown = false;



  static Future<void> getAllLiffData() async {
    print("Starting data initialization...");
    try {
      await Future.wait([
        getAllLandmarkFromFirestore(),
        getLiffData(),
        getProfileData(),
        getFriendshipData(),
      ]);
      await Future.wait([
        getSelectedLandmarkData(),
        showLandmarkMessage()
      ]);
      isInitialized = true;
    } catch (e) {
      isInitialized = false;
      print("Error initializing LIFF data: $e");
    }
  }

  static Future<void> showLandmarkMessage() async {
    isLandmarkPageShown = (friendshipStatus && landmarkDetails.isNotEmpty);
  }

  
  static Future<void> getLiffData() async {
    if (kIsWeb && !isInitialized) {
      await Future.microtask(() {
        userId = liffInstance.context?.userId;
        language = liffInstance.appLanguage;
        lineVersion = liffInstance.lineVersion;
        context = liffInstance.context?.toString();
        decodedIDToken = liffInstance.getDecodedIDToken()?.toString();
        accessToken = liffInstance.getAccessToken();
        idToken = liffInstance.getIDToken();
        isInclient = liffInstance.isInClient;
      });
    } else {}
  }

  static Future<void> getProfileData() async {
    try {
      if (!isInitialized) {
        final profileData = await liffInstance.profile;
        userName = profileData.displayName;
        userId = profileData.userId;
        userPhotoUrl = profileData.pictureUrl;
      }
    } catch (e) {
      print('Error getting profile data: $e');
    }
  }

  static Future<void> getFriendshipData() async {
    try {
      if (!isInitialized) {
        final friendshipData = await liffInstance.friendship;
        friendshipStatus = friendshipData.friendFlag;
      }
    } catch (e) {
      print('Error getting friendship status: $e');
    }
  }

  static Future<void> getAllLandmarkFromFirestore() async {
    try {
      final firebaseService = FirebaseService();
      allLandmarkDetails =
          await firebaseService.getAllLandmarkDataFromFirestore();
    } catch (e) {
      print('Error getting all landmark data from Firestore: $e');
    }
  }

  static Future<void> getSelectedLandmarkData() async {
    try {
      if (!isInitialized) {
        final uri = Uri.parse(html.window.location.href);
        String? locationSegment;
        // 取得 landmark uid
        final pathSegments = uri.pathSegments;
        print('pathSegments: $pathSegments');

        if (pathSegments.isNotEmpty) {
          locationSegment = pathSegments.last; // 取得最後一段 path
        } else {
          landmarkName = 'Url location';
        }
        final sendMessageParam = uri.queryParameters['sendMessage'];
        isSendMessage = sendMessageParam?.toLowerCase() == 'true';

        print('locationSegment: $locationSegment');
        print('Should Send Message: $isSendMessage');

        if (locationSegment != null && locationSegment.isNotEmpty) {
          landmarkDetails = allLandmarkDetails.firstWhere(
            (landmark) => landmark['id'] == locationSegment,
            orElse: () => <String, dynamic>{},
          );
          if (allLandmarkDetails.isNotEmpty) {
            landmarkName = landmarkDetails['landmark_name'];
            password = landmarkDetails['password'];

            landmarkPictureUrl =
                landmarkDetails['landmark_pictureUrl'].toString();
            landmarkInfoTitle = landmarkDetails['infoWindow_title'];
            landmarkInfoDescription = landmarkDetails['infoWindow_snippet'];

            print('Selected Landmark Details: $landmarkDetails');
          } else {
            // await getLocationDataFromUrl();
          }
        }
      } else {
        // await getLocationDataFromUrl();
      }
    } catch (e) {
      print('Error getting the selected location data: $e');
      // await getLocationDataFromUrl();
    }
  }
}
