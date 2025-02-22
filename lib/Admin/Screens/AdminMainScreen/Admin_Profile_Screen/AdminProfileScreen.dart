import 'package:ajeal/Admin/Screens/AdminLoginScreen/cubit/sign_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الملف الشخصي"),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // صورة الحساب
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/Mohsen.jpg"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.edit, color: Colors.white),
                        onPressed: () {
                          // تعديل الصورة
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 20),

            // معلومات الحساب
            const ProfileInfoTile(
                icon: Icons.person, title: "الاسم", value: "محمد "),
            const ProfileInfoTile(
                icon: Icons.email,
                title: "البريد الإلكتروني",
                value: "admin@example.com"),
            const ProfileInfoTile(
                icon: Icons.phone,
                title: "رقم الهاتف",
                value: "+20 123 456 789"),
            const ProfileInfoTile(
                icon: Icons.badge, title: "الدور الوظيفي", value: "مدير"),
            const SizedBox(height: 20),

            // أزرار الإجراءات
            ElevatedButton.icon(
              icon: const Icon(Icons.lock),
              label: const Text("تغيير كلمة المرور"),
              onPressed: () {
                // تغيير كلمة المرور
              },
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
            ),
            const SizedBox(height: 10),
            BlocBuilder<SignCubit, SignState>(
                bloc: SignCubit(),
                builder: (context, snap) {
                  final bloc = context.read<SignCubit>();

                  return ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text("تسجيل الخروج"),
                    onPressed: () {
                      bloc.logout(context);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent),
                  );
                }),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.blueAccent),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value),
        trailing: IconButton(
          icon: const Icon(Icons.edit, color: Colors.grey),
          onPressed: () {
            // تعديل البيانات
          },
        ),
      ),
    );
  }
}
