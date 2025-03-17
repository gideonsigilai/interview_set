import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/views/add_user_screen.dart';
import 'package:interview/views/detail_screen.dart';
import 'package:interview/views/edit_user_screen.dart';
import 'package:interview/views/home_screen.dart';
import 'package:interview/config/app_theme.dart';
import 'package:url_strategy/url_strategy.dart';

void main() {  
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => HomeScreen()),
        GetPage(name: '/new-user', page: () => AddUserScreen()),
        GetPage(name: '/user/:id', page: () => UserDetailScreen()),
        GetPage(name: '/edit/:id', page: () => EditUserScreen()),
      ],
    );
  }
}