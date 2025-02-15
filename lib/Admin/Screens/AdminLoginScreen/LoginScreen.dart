
import 'package:ajeal/Admin/Screens/AdminLoginScreen/ResetPasswordScreen.dart';
import 'package:ajeal/Admin/Screens/AdminLoginScreen/SignUpScreen.dart';
import 'package:ajeal/Admin/Screens/AdminLoginScreen/cubit/sign_cubit.dart';
import 'package:ajeal/helpers/customtextfiled/customtextfiled.dart';
import 'package:ajeal/helpers/responsive/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class AdminLoginScreen extends StatelessWidget {
   AdminLoginScreen({super.key,});
  final bool issignedin =false;


   late final String? Function(String?)? validator ;
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SignCubit>();
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return  BlocListener <SignCubit, SignState>(
      listener: (BuildContext context, state) {
        if (state is SignFaliureState) {
          Get.snackbar(
            "Error",
            state.error,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }

      },
      child: Scaffold(
        backgroundColor: Color(0xffF1F0EB),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset("assets/images/Untitled design.png",scale: 0.5,height:height/4,width: width/2, )
               ,    Row(
                    children: [
                      Text("لنقم بتسجيل دخولك ",style :TextStyle(
                        fontSize:Responsive.TextSize(context,isExtraSmallSize:18,isMobileSize: 25,isMobileLarge:30,isIpadSize: 40,isTabletSize: 43,isLargeTabletSize: 50,defaultSize: 20  ),shadows: const [
                        Shadow(
                          offset: Offset(2, 2),
                          blurRadius: 4,
                          color: Colors.black38,
                        ),
                      ],
                      ),),
                    ],
                  ),
                  const SizedBox(height: 8,),
                  Text("قم بادخال المعلومات اسفل ",style: TextStyle(color: Colors.grey.shade400,fontSize:Responsive.TextSize(context,isExtraSmallSize:10,isMobileSize: 17,isMobileLarge:19,isIpadSize: 26,isTabletSize: 25,isLargeTabletSize: 40,defaultSize: 15  )),)
                  ,const Padding(
                    padding: EdgeInsets.all(20.0),
                  ),

                  Form(
                      key: _key,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextField(
                              icon: const Icon(Icons.email_outlined,color:  Color(0xff0186c7)),
                              controller: _nameController,
                              height: height,
                              text: "Email",
                              validator: (val) {
                                if (!val!.isEmail) {
                                  return "this should be valid Email.";
                                } else if (val.length < 10) {
                                  return " email should be more than 10 letters";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          Padding(

                            padding: const EdgeInsets.all(8.0),
                            child: CustomTextField(
                              icon: const Icon(Icons.lock,color:  Color(0xff0186c7)),
                              height: height,
                              controller: _passwordController,
                              text: "Password",
                              isPassword: true,
                              validator: (val) {
                                if (val!.length < 6) {
                                  return "Password should be more than 7 letters";
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      )

                  ),
                  Row(children: [const Spacer(),InkWell(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const ResetPasswordScreen()));
                  }, child:   Text("لا تتذكر الباسورد ",style:TextStyle(color: Color(0xff0186c7),fontWeight: FontWeight.bold,fontSize: Responsive.TextSize(context,isExtraSmallSize:13,isMobileSize: 15,isMobileLarge:18,isIpadSize: 20,isTabletSize: 22,isLargeTabletSize: 30,defaultSize: 18  ))/*GoogleFonts.agbalumo(color: Color(0xff0186c7))*/ ,))],)
                  ,const SizedBox(height:40,),
                GestureDetector(
                  onTap: (){
                    bloc.Login(context,_key,_nameController,_passwordController);

                  },
                  child: Container (height: 70,
                      decoration: BoxDecoration(
                        color: const Color(0xff0186c7),
                          borderRadius: BorderRadius.circular(15), // Optional: Rounded corners
                        boxShadow: const [BoxShadow(
                          color: Colors.grey,
                          offset:Offset(0.5, 0.5)
                        )]

                      ),

                    child: Row(mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BlocBuilder <SignCubit, SignState>(

                          builder: (BuildContext context, SignState state) {
                            if (state is SignLoadingState)
                              {
                                return const CircularProgressIndicator();
                              }
                            return  Center(
                              child: Text(
                                "تسجيل الدخول",style:TextStyle(fontSize: Responsive.TextSize(context,isExtraSmallSize:25,isMobileSize: 30,isMobileLarge:35,isIpadSize: 70,isTabletSize: 90,isLargeTabletSize: 100,defaultSize: 40  ),color: Colors.white,) /*GoogleFonts.agbalumo(fontSize: 40,color: Colors.white)*/,),
                            );


                          },
                        )],),
                  ),
                )
                ,const SizedBox(height:30,)

                , Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                     Text("Dont have any account ? ",style: TextStyle(fontSize: Responsive.TextSize(context,isExtraSmallSize:13,isMobileSize: 15,isMobileLarge:18,isIpadSize: 20,isTabletSize: 22,isLargeTabletSize: 30,defaultSize: 18  )),),
                    InkWell(onTap: (){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Signupscreen()),
                      );

                    }, child:  Text("Register Now",style:TextStyle(color: Color(0xff0186c7),fontWeight: FontWeight.bold,fontSize: Responsive.TextSize(context,isExtraSmallSize:13,isMobileSize: 15,isMobileLarge:18,isIpadSize: 20,isTabletSize: 22,isLargeTabletSize: 30,defaultSize: 18  )) /*GoogleFonts.agbalumo(color: Color(0xff0186c7))*/,))
                  ],)


                ],
              ),
            ),
          ),
      ),
    );
  }
}
