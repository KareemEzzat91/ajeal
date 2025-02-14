import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/ChildModel/ChildModel.dart';
import 'package:ajeal/Parents/ParentHomeScreen/ParentHomeScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParentLoginPage extends StatefulWidget {
  @override
  _ParentLoginPageState createState() => _ParentLoginPageState();
}

class _ParentLoginPageState extends State<ParentLoginPage> {
  final _parentCodeController = TextEditingController();
  final _admincodeController = TextEditingController();

  void login() async {
    try {
      final parentCode = _parentCodeController.text;

      if (parentCode.isNotEmpty) {
        final adminID = _admincodeController.text;
        // تحقق من الـ parentCode
        final DoctorKeysnapshot = await FirebaseFirestore.instance.collection("Doctors").doc(adminID).get() ; 
        if (DoctorKeysnapshot.data()!.isNotEmpty) {
          final doctorkey =DoctorKeysnapshot['Doctor_id'];
          final userDoc = await FirebaseFirestore.instance.collection("users")
              .doc(doctorkey).collection("children").doc(parentCode)
              .get();
          if (userDoc.data()!.isNotEmpty) {
            // جلب بيانات الطفل المرتبطة بالكود
            final child =Child.fromJson(userDoc.data()!);
            final Adminid=doctorkey;

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (c)=>ParentHomePage(parentCode:parentCode ,child:child,AdminId: Adminid,)));



          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter The Right code")));
          }
        }

      }else{
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please Enter The Right code")));

      }
    }catch(e){

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Parent Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _parentCodeController,
              decoration: InputDecoration(labelText: "Enter Parent Code"),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _admincodeController,
              decoration: const InputDecoration(labelText: "Enter Admin Code"),
            ),

            ElevatedButton(
              onPressed: login,
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
