import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ajeal/helpers/generated/l10n.dart';
import 'package:ajeal/helpers/url_launcher/url_launcher.dart';

void showEmergencyContactDialog(BuildContext context, String doctorPhone) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(S.of(context).emergency_contact),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.red),
            title: Text(S.of(context).call_emergency),
            onTap: () {
              LauncherHelper.launchUrlFromString(
                  "https://wa.me/<+20 100 409 2979>?text=السلام عليكم");
            },
          ),
          ListTile(
            leading: const Icon(Icons.message, color: Colors.orange),
            title: Text(S.of(context).message_teacher),
            onTap: () {
              LauncherHelper.launchUrlFromString(
                  "https://wa.me/<+2$doctorPhone>?text=السلام عليكم");
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: Text(S.of(context).logout),
            onPressed: () {
              logout(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: const Text("Close"),
        ),
      ],
    ),
  );
}

Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  final pref = await SharedPreferences.getInstance();
  await pref.setBool("ParentLogin", false);
  if (context.mounted) {
    context.go('/choice');
  }
}
