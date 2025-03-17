import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/controllers/user_controller.dart';
import 'package:interview/models/user_model.dart';
import 'package:interview/widgets/loading_button.dart';

class UserDetailScreen extends StatelessWidget {
  UserDetailScreen({super.key});

  final String userId = Get.parameters['id']!;
  final UserController controller = Get.isRegistered<UserController>() ? Get.find() : Get.put(UserController());

  Future<void> _showDeleteDialog() async {
    return showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Delete User'),
        content: Text('Are you sure you want to delete this user?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          Obx(() => LoadingButton(
            text: 'Delete',
            isLoading: controller.isDeleting.value,
            backgroundColor: Colors.red,
            onPressed: () async {
              controller.isDeleting.value = true;
              try {
                await controller.deleteUser(userId);
                Get.back();
                Get.back();
              } finally {
                controller.isDeleting.value = false;
              }
            },
          )),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
        leading: TextButton.icon(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
          label: Text('Back'),
          style: TextButton.styleFrom(foregroundColor: Colors.white),
        ),
        actions: [
          IconButton(icon: Icon(Icons.edit), onPressed: () => Get.toNamed('/edit/$userId')),
          IconButton(icon: Icon(Icons.delete), onPressed: _showDeleteDialog),
        ]),
      body: FutureBuilder<User>(
        future: controller.api.getUser(userId),
        builder: (context, snapshot) => snapshot.hasData
            ? Padding(
                padding: EdgeInsets.all(16),
                child: Column(children: [
                  Text(snapshot.data!.name, style: TextStyle(fontSize: 24)),
                  Text(snapshot.data!.email),
                  Text(snapshot.data!.occupation),
                  SizedBox(height: 20),
                  Text(snapshot.data!.bio),
                ]))
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: double.infinity),
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                    ),
                    SizedBox(height: 16),
                    Text('Loading user details...',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ),
      ),
    );
  }
}