import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenSelectGooals/AdminSelectGooals.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:ajeal/helpers/customtextfiled/customtextfiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAddChildScreen extends StatefulWidget {
  const AdminAddChildScreen({super.key});

  @override
  _AdminAddChildScreenState createState() => _AdminAddChildScreenState();
}

class _AdminAddChildScreenState extends State<AdminAddChildScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController parentOccupationController = TextEditingController();
  final TextEditingController goalsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final _key = GlobalKey<FormState>();
  late final String? Function(String?)? validator ;

  DateTime? selectedDate;
  int  age =2 ;
  List <Goals>Selecteditems = [ ];
  // دالة اختيار تاريخ الميلاد
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        final date = DateTime.now();
        age = date.year - selectedDate!.year;

        if (date.month < selectedDate!.month ||
            (date.month == selectedDate!.month && date.day < selectedDate!.day)) {
          age--;
        }

        ageController.text = age.toString();

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc =context.read<AddChildCubit>();
    final height = MediaQuery.sizeOf(context).height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("إضافة طفل جديد"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key:_key ,
          child: ListView(
            children: [
              CustomTextField(
                height: height,
                controller: nameController,
                icon: const Icon(Icons.child_care),
                text: "اسم الطفل",
                validator: (val){
                  if( val!.isEmpty)
                  {
                    return "Name shouldn't be empty";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              CustomTextField(
                height: height,
                controller: ageController,
                icon: const Icon(Icons.cake),
                text: "العمر",
                validator:(val){
                  if( val!.isEmpty)
                    {
                      return "Age shouldn't be empty";
                    }
                  return null;
                } ,
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: CustomTextField(
                    height: height,
                    controller: TextEditingController(
                      text: selectedDate != null
                          ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                          : "",
                    ),
                    icon: const Icon(Icons.calendar_today),
                    text: "تاريخ الميلاد",
                    validator: (val){
                      if( val!.isEmpty)
                      {
                        return "BirthDate shouldn't be empty";
                      }
                      return null;
                    },

                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                height: height,
                controller: parentOccupationController,
                icon: const Icon(Icons.work),
                text: "رقم تواصل الوالدين",
                validator: (val){
                  if( val!.isEmpty)
                  {
                    return "رقم التواصل shouldn't be empty";
                  }
                  else if (val.length!=11){

                    return "رقم التواصل يجب ان يكون من 11 رقم 01xxxxxxxxx";

                  }
                  else if (bloc.selectedGoals.containsKey(val)){
                    return "this Phone Already exist";

                  }
                  else return null;
                },

              ),
              const SizedBox(height: 10),
               CustomTextField(
                height: height,
                controller: notesController,
                icon: const Icon(Icons.note),
                text: "ملاحظات إضافية",
              ),
              const SizedBox(height: 20),
              ElevatedButton(style:ButtonStyle(backgroundColor: WidgetStateProperty.all(Colors.blueAccent)),
                onPressed: ()async {
                  if (_key.currentState!.validate())
                    {
                      Selecteditems = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminSelectGoals(Phone:parentOccupationController.text, ),
                        ),
                      );
                      setState(() {

                      });
                    }


                },
                child: const Text("اختيار الاهداف",style: TextStyle(color: Colors.white),),
              ),
              SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: Selecteditems.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0), // Adds space between items
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: Colors.blueAccent,
                      ),
                      padding: const EdgeInsets.all(9.0), // Adds padding inside each container
                      child:  Row(
                        children: [
                          Text(
                            Selecteditems[index].goalName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),Spacer(),InkWell(child: Icon(Icons.delete,color: Colors.white,),onTap: (){
                            setState(() {
                              Selecteditems.removeAt(index);
                            });
                          },)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
              ElevatedButton(
                onPressed: () {
                  if (_key.currentState!.validate())
                    {
                  bloc.saveChild(nameController.text, ageController.text, selectedDate!, parentOccupationController.text, notesController.text,context)
                 ;} },
                child: const Text("حفظ"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
