import 'package:ajeal/Admin/Screens/AdminLoginScreen/LoginScreen.dart';
import 'package:ajeal/Screens/WelcomeScreen/WelcomeScreen.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:flutter/material.dart';

class AdminOrParentsScreen extends StatelessWidget {
  const AdminOrParentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
             Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                S.of(context).AdminOrParents,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const welcomescreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Colors.redAccent, Colors.orange],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child:  Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.family_restroom,
                              size: 70,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              S.of(context).Parents,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminLoginScreen()));
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: const LinearGradient(
                          colors: [Colors.blueAccent, Colors.lightBlue],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child:  Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.admin_panel_settings_outlined,
                              size: 70,
                              color: Colors.white,
                            ),
                            SizedBox(height: 10),
                            Text(
                              S.of(context).Admin,
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
