import 'package:get/get.dart';
import 'package:interview/models/user_model.dart';
import 'package:interview/services/api_service.dart';

class UserController extends GetxController {
  var users = <User>[].obs;
  final ApiService api = ApiService();
  final isDeleting = false.obs;
  final isEditing = false.obs;
  final isFetching = false.obs;
  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  Future<void> fetchUsers() async {
    try {
      isFetching.value = true;
      users.value = await api.getUsers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users');
    } finally {
      isFetching.value = false;
    }
  }

  final RxString searchQuery = ''.obs;

  List<User> get filteredUsers {
    if (searchQuery.isEmpty) return users;
    final query = searchQuery.toLowerCase().trim();
    return users.where((user) {
      return user.name.toLowerCase().contains(query) ||
          user.occupation.toLowerCase().contains(query);
    }).toList();
  }

  Future<void> updateUser(User user) async {
    try {
      isEditing.value = true;
      await api.updateUser(user.id, user);
      int index = users.indexWhere((u) => u.id == user.id);
      if (index != -1) users[index] = user;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user');
    } finally {
      isEditing.value = false;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      isDeleting.value = true;
      await api.deleteUser(userId);
      users.removeWhere((u) => u.id == userId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user');
    } finally {
      isDeleting.value = false;
    }
  }
  final isCreating = false.obs;

  Future<void> createUser({
    required String name,
    required String email,
    required String occupation,
    required String bio,
  }) async {
    try {
      isCreating.value = true;
      final newUser = await api.createUser(
        name: name,
        email: email,
        occupation: occupation,
        bio: bio,
      );
      users.add(newUser);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create user');
    } finally {
      isCreating.value = false;
    }
  }
}
