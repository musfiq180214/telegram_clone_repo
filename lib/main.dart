import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

import 'controllers/private_chat_controller.dart';
import 'controllers/auth_controller.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';

void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    // ✅ Web-specific Firebase initialization
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAExCNanTDh2GDMLh11CTj2GLemNH5yFBU",
        authDomain: "telegram-clone-2905c.firebaseapp.com",
        projectId: "telegram-clone-2905c",
        storageBucket: "telegram-clone-2905c.firebasestorage.app",
        messagingSenderId: "907796239054",
        appId: "1:907796239054:web:da046bffa588ba8bbd769f",
      ),
    );
  } else {
    // ✅ Android/iOS
    await Firebase.initializeApp();
  }

  Get.put(AuthController());

  Get.put(PrivateChatController());   // << Add this line

  runApp(MyApp());
  
}

class MyApp extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Telegram Clone',
      home: Obx(() {
        return authController.isLoggedIn.value ? HomeScreen() : LoginScreen();
      }),
    );
  }
}

/*

presently created test users: 

musfiq677@gmail.com
1210900445

musfiq180214@gmail.com
1210900445

180214@gmail.com
1210900445

*/
