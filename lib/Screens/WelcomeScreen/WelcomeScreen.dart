import 'package:ajeal/Parents/ParentLoginPage/ParentLoginPage.dart';
import 'package:ajeal/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class welcomescreen extends StatelessWidget {
  const welcomescreen({super.key});

  @override
  Widget build(BuildContext context) {
    final height =MediaQuery.sizeOf(context).height;
    return  Scaffold(backgroundColor: Colors.white,
      body: Stack(children: [
      Image(image: const AssetImage("assets/images/3.png"),fit: BoxFit.cover,height: height,),
      Image(image: const AssetImage("assets/images/2.png"),fit: BoxFit.cover,height: height,),
      Image(image: const AssetImage("assets/images/1.png"),fit: BoxFit.cover,height: height,),
        Center(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage("assets/images/Rectangle 27.png"),fit: BoxFit.cover,width: double.infinity,),
            const SizedBox(height: 28,),

            buildTextButton(S.of(context).Login,Color(0xffFFCB7C),context),
            const SizedBox(height: 15,),
            Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(40),border: Border.all(color: Colors.green)),child: buildTextButton(S.of(context).Register,Color(0xfffff),context))
    ],
        ),)
      ],),
    );
  }

  TextButton buildTextButton(String Textt,Color color,context) => TextButton(onPressed: (){
    Navigator.push(context, MaterialPageRoute(builder: (c)=>ParentLoginPage ()));
  },style: ButtonStyle(fixedSize:WidgetStateProperty.all(const Size(180, 50)) ,backgroundColor: WidgetStateProperty.all(color)), child: Text(Textt,style: TextStyle(fontSize: 20),),);
}
