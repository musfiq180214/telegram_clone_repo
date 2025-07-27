import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/auth_controller.dart';
import 'chat_list_screen.dart';
import 'private_chat/user_list_screen.dart';

class HomeScreen extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Telegram Clone"),
        centerTitle: true,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.telegram, size: 80, color: theme.primaryColor),
              const SizedBox(height: 16),
              Text(
                user?.email ?? "User",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "User ID: ${user?.uid ?? 'N/A'}",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 40),

              // 🔹 Public Chat Button
              ElevatedButton.icon(
                icon: const Icon(Icons.public),
                label: const Text("Public Chat Rooms"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: theme.textTheme.titleMedium,
                ),
                onPressed: () => Get.to(() => ChatListScreen()),
              ),

              const SizedBox(height: 16),

              // ✅ Start New Private Chat Button
              ElevatedButton.icon(
                icon: const Icon(Icons.person_add),
                label: const Text("Start New Private Chat"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: theme.textTheme.titleMedium,
                ),
                onPressed: () => Get.to(() => UserListScreen()),
              ),

              const SizedBox(height: 16),

              // Admin Panel Placeholder
              ElevatedButton.icon(
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text("Admin Panel"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: theme.textTheme.titleMedium,
                  backgroundColor: Colors.grey[700],
                ),
                onPressed: () => Get.snackbar(
                  "Coming Soon",
                  "Admin Panel not yet available",
                  snackPosition: SnackPosition.BOTTOM,
                ),
              ),

              const SizedBox(height: 40),

              // 🔻 Logout
              OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  textStyle: theme.textTheme.titleMedium,
                ),
                onPressed: () => authController.logout(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
