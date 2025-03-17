import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/models/user_model.dart';
import 'package:interview/widgets/loading_button.dart';

import '../controllers/user_controller.dart';

class EditUserScreen extends StatefulWidget {

  const EditUserScreen({super.key});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final UserController controller = Get.isRegistered<UserController>() ? Get.find() : Get.put(UserController());

  final userId = Get.parameters['id']!;

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameCtrl, emailCtrl, occupationCtrl, bioCtrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit User'),
        leading: TextButton.icon(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
          label: Text('Back'),
          style: TextButton.styleFrom(foregroundColor: Colors.white),
        ),
      ),
      body: FutureBuilder<User>(
        future: controller.api.getUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                ),
                SizedBox(height: 16),
                Text('Loading user information...',
                    style: TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          );
          }
          
          nameCtrl = TextEditingController(text: snapshot.data!.name);
          emailCtrl = TextEditingController(text: snapshot.data!.email);
          occupationCtrl = TextEditingController(text: snapshot.data!.occupation);
          bioCtrl = TextEditingController(text: snapshot.data!.bio);

          return Padding(
            padding: EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Edit Profile Information',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24),
                        TextFormField(
                          controller: nameCtrl,
                          decoration: InputDecoration(
                            labelText: 'Full Name',
                            hintText: 'Enter your full name',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                          validator: (v) => v!.isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: emailCtrl,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter your email address',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.email_outlined),
                          ),
                          validator: (v) => !v!.contains('@') ? 'Invalid email' : null,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: occupationCtrl,
                          decoration: InputDecoration(
                            labelText: 'Occupation',
                            hintText: 'Enter your occupation',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: Icon(Icons.work_outline),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          controller: bioCtrl,
                          maxLines: 3,
                          decoration: InputDecoration(
                            labelText: 'Bio',
                            hintText: 'Tell us about yourself',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignLabelWithHint: true,
                            prefixIcon: Icon(Icons.description_outlined),
                          ),
                        ),
                        SizedBox(height: 24),
                        Obx(
                          ()=> LoadingButton(
                            text: 'Save Changes',
                            isLoading: controller.isEditing.value,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                User updatedUser = User(
                                  id: userId,
                                  name: nameCtrl.text,
                                  email: emailCtrl.text,
                                  occupation: occupationCtrl.text,
                                  bio: bioCtrl.text,
                                );
                                await controller.updateUser(updatedUser);
                                Get.back();
                              }
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}