import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview/models/user_model.dart' show User;
import '../controllers/user_controller.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final UserController controller = Get.isRegistered<UserController>() ? Get.find() : Get.put(UserController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Users'),
        actions: [
          IconButton(
        icon: const Icon(Icons.brightness_6),
        onPressed: () {
          Get.changeThemeMode(
            Get.isDarkMode ? ThemeMode.light : ThemeMode.dark,
          );
        },
          ),
        ],
      ),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.users.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.users.length) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: controller.isFetching.value
                  ? const CupertinoActivityIndicator()
                  : const SizedBox()
              );
            }
            final user = controller.users[index];
            return _UserListItem(user: user);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed("/new-user"),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _UserListItem extends StatelessWidget {
  final User user;

  const _UserListItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.occupation),
      onTap: () => Get.toNamed('/user/${user.id}'),
    );
  }
}
