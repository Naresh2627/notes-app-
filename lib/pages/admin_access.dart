import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/admin_provider.dart';

class AdminUserListPage extends StatelessWidget {
  const AdminUserListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Admin Panel")),
      body: StreamBuilder(
        stream: provider.getUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              final data = user.data() as Map<String, dynamic>;

              final email = data['email'] ?? '';
              final role = data['role'] ?? 'user';

              return ListTile(
                title: Text(email),
                subtitle: Text("Role: $role"),

                trailing: role == "admin"
                    ? const Text("Admin", style: TextStyle(color: Colors.green))
                    : ElevatedButton(
                        onPressed: () async {
                          try {
                            await provider.makeAdmin(user.id);
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("User is now an admin!")),
                              );
                            }
                          } catch (e) {
                            debugPrint("FIREBASE ERROR: $e");
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error: $e"),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 5),
                                ),
                              );
                            }
                          }
                        },
                        child: const Text("Make Admin"),
                      ),
              );
            },
          );
        },
      ),
    );
  }
}