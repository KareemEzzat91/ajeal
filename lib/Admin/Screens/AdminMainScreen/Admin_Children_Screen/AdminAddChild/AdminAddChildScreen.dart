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
  final TextEditingController PeriodController = TextEditingController();
  final _key = GlobalKey<FormState>();
  late final String? Function(String?)? validator ;

  DateTime? selectedDate;
  DateTime? StartDate;
  DateTime? EndDate;
  int  age =2 ;
  List <Goal>Selecteditems = [ ];
  Future<void> _selectDate( context, DateTime? dateType) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateType ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate:dateType == selectedDate? DateTime.now():DateTime.utc(2030),
    );

    if (picked != null) {
      setState(() {
        if (dateType == selectedDate) {
          selectedDate = picked;
          _updateAge();
        } else if (dateType == StartDate) {
          StartDate = picked;
          if (EndDate == null) {
            PeriodController.text = " اشهر 3 "; // Default period of 3 months
          } else {
            PeriodController.text = _calculatePeriod(StartDate!, EndDate!);
          }
        } else if (dateType == EndDate) {
          EndDate = picked;
          if (StartDate == null) {
            PeriodController.text = _calculatePeriod(DateTime.now(), EndDate!);
          } else {
            PeriodController.text = _calculatePeriod(StartDate!, EndDate!);
          }
        }
      });
    }
  }

  void _updateAge() {
    if (selectedDate != null) {
      final currentDate = DateTime.now();
      age = currentDate.year - selectedDate!.year;

      if (currentDate.month < selectedDate!.month ||
          (currentDate.month == selectedDate!.month &&
              currentDate.day < selectedDate!.day)) {
        age--;
      }

      ageController.text = age.toString();
    }
  }

  String _calculatePeriod(DateTime start, DateTime end) {
    final difference = end.difference(start);
    final years = (difference.inDays ~/ 365);
    final months = (difference.inDays % 365) ~/ 30;
    final days = (difference.inDays % 365) % 30;

    return " سنوات ${years} شهور $months ايام $days  ";
  }


  @override
  Widget build(BuildContext context) {
    final bloc =context.read<AddChildCubit>();
    final height = MediaQuery.sizeOf(context).height;

    return BlocListener<AddChildCubit, AddChildState>(
      listener: (context, state) {
        if (state is AddLoadingState) {
          // Show a loading indicator when in AddLoadingState
          showDialog(
            context: context,
            barrierDismissible: false, // Prevent dismissal while loading
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );
        } else if (state is AddScuccesState) {
          // Close the loading dialog when the operation succeeds
          Navigator.pop(context);
        } else if (state is AddFailureState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred.'),
            ),
          );
        }
      },  child: Scaffold(
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
                onTap: () => _selectDate(context,selectedDate),
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
              GestureDetector(
                onTap: () => _selectDate(context,StartDate),
                child: AbsorbPointer(
                  child: CustomTextField(
                    height: height,
                    controller: TextEditingController(
                      text: StartDate != null
                          ? "${StartDate!.day}/${StartDate!.month}/${StartDate!.year}"
                          : "",
                    ),
                    icon: const Icon(Icons.calendar_today),
                    text: "تاريخ البداية",
                    validator: (val){
                      if( val!.isEmpty)
                      {
                        return "StarteDate shouldn't be empty";
                      }
                      return null;
                    },

                  ),
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectDate(context,EndDate),
                child: AbsorbPointer(
                  child: CustomTextField(
                    height: height,
                    controller: TextEditingController(
                      text: EndDate != null
                          ? "${EndDate!.day}/${EndDate!.month}/${EndDate!.year}"
                          : "",
                    ),
                    icon: const Icon(Icons.calendar_today),
                    text: "تاريخ الانتهاء",
                    validator: (val){
                      if( val!.isEmpty)
                      {
                        return "EndDate shouldn't be empty";
                      }
                      return null;
                    },

                  ),
                ),
              ),
              const SizedBox(height: 10),
              CustomTextField(
                height: height,
                controller: PeriodController,
                icon: const Icon(Icons.timer),
                text: "المدة",
                validator:(val){
                  if( val!.isEmpty)
                  {
                    return "Period shouldn't be empty";
                  }
                  return null;
                } ,
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
              height: 120,
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
                          ),const Spacer(),InkWell(child: const Icon(Icons.delete,color: Colors.white,),onTap: (){
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
                  if (bloc.selectedGoals[parentOccupationController.text]==null)
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'قم باضافة اهداف ',
                              style: TextStyle(color: Colors.blue[400]),
                            ),
                          ));
                    }
                  else{
                    bloc.saveChild(nameController.text, ageController.text, selectedDate!,StartDate!,EndDate!,PeriodController.text, parentOccupationController.text, notesController.text,context);

                  }
                  /* if (_key.currentState!.validate())
                    {
                } */},
                child: const Text("حفظ"),
              ),
            ],
          ),
        ),
      ),
    ),
);
  }
}
