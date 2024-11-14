import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenSelectGooals/GoalDetailScreen.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminSelectGoals extends StatelessWidget {
   AdminSelectGoals({super.key});
   final List<Goals> goalList = [
     Goals(
       goalName: "تحسين القراءة",
       goalDescription: "تعزيز مهارات الطفل في التعرف على الحروف وقراءتها بشكل صحيح.",
       sessions: [
         {"date": "2024-11-15", "focus": "قراءة الحروف من أ إلى ج"},
         {"date": "2024-11-22", "focus": "قراءة الحروف من د إلى ز"},
       ],
       evaluations: [
         {"date": "2024-11-15", "rating": "متوسط", "notes": "تحسن ملحوظ، يحتاج لمزيد من التدريب."},
         {"date": "2024-11-22", "rating": "ممتاز", "notes": "تمكن من القراءة بثقة."},
       ],
       progressData: [60.0, 80.0],
     ),
     Goals(
       goalName: "تحسين الكتابة",
       goalDescription: "تنمية قدرة الطفل على الكتابة بخط واضح ومرتب.",
       sessions: [
         {"date": "2024-11-15", "focus": "كتابة الحروف من أ إلى ج"},
         {"date": "2024-11-22", "focus": "كتابة الحروف من د إلى ز"},
       ],
       evaluations: [
         {"date": "2024-11-15", "rating": "ضعيف", "notes": "يحتاج إلى تحسين في التحكم بالقلم."},
         {"date": "2024-11-22", "rating": "متوسط", "notes": "تحسن في مستوى الكتابة."},
       ],
       progressData: [50.0, 70.0],
     ),
     Goals(
       goalName: "تنمية المهارات الحسابية",
       goalDescription: "مساعدة الطفل على التعرف على الأرقام وإجراء عمليات حسابية بسيطة.",
       sessions: [
         {"date": "2024-11-15", "focus": "العد من 1 إلى 10"},
         {"date": "2024-11-22", "focus": "إضافة الأعداد البسيطة"},
       ],
       evaluations: [
         {"date": "2024-11-15", "rating": "ممتاز", "notes": "التعرف على الأرقام جيد."},
         {"date": "2024-11-22", "rating": "متوسط", "notes": "يحتاج إلى تدريب إضافي على الجمع."},
       ],
       progressData: [70.0, 85.0],
     ),
     Goals(
       goalName: "تقوية الذاكرة",
       goalDescription: "تعزيز قدرة الطفل على تذكر الأشياء والتسلسل الزمني للأحداث.",
       sessions: [
         {"date": "2024-11-15", "focus": "تذكر الأشياء المحيطة"},
         {"date": "2024-11-22", "focus": "تذكر التسلسل الزمني للأحداث"},
       ],
       evaluations: [
         {"date": "2024-11-15", "rating": "متوسط", "notes": "تحسن تدريجي في تذكر التفاصيل."},
         {"date": "2024-11-22", "rating": "ممتاز", "notes": "تقدم كبير في تذكر الأحداث."},
       ],
       progressData: [65.0, 90.0],
     ),
     Goals(
       goalName: "زيادة الانتباه والتركيز",
       goalDescription: "تطوير قدرة الطفل على الانتباه لمهام معينة وزيادة مدة التركيز.",
       sessions: [
         {"date": "2024-11-15", "focus": "تمارين الانتباه لمدة قصيرة"},
         {"date": "2024-11-22", "focus": "تمارين الانتباه لمدة أطول"},
       ],
       evaluations: [
         {"date": "2024-11-15", "rating": "ضعيف", "notes": "يحتاج إلى تحسين في التركيز على المهام."},
         {"date": "2024-11-22", "rating": "متوسط", "notes": "تحسن بسيط في التركيز."},
       ],
       progressData: [50.0, 65.0],
     ),
     Goals(
       goalName: "تنمية الإدراك",
       goalDescription: "مساعدة الطفل على تحسين فهمه وتفسيره للأشياء من حوله.",
       sessions: [
         {"date": "2024-11-15", "focus": "التعرف على الأشكال والألوان"},
         {"date": "2024-11-22", "focus": "تمييز الأصوات والكلمات"},
       ],
       evaluations: [
         {"date": "2024-11-15", "rating": "متوسط", "notes": "يفهم الأشكال بشكل جيد."},
         {"date": "2024-11-22", "rating": "ممتاز", "notes": "تطور ملحوظ في الإدراك السمعي."},
       ],
       progressData: [70.0, 85.0],
     ),
     Goals(
       goalName: "تعزيز المهارات الاجتماعية",
       goalDescription: "مساعدة الطفل على تطوير مهاراته الاجتماعية والتفاعل مع الآخرين.",
       sessions: [
         {"date": "2024-11-15", "focus": "التفاعل في الألعاب الجماعية"},
         {"date": "2024-11-22", "focus": "ممارسة آداب الحوار"},
       ],
       evaluations: [
         {"date": "2024-11-15", "rating": "ضعيف", "notes": "يحتاج إلى دعم في التعامل مع الأقران."},
         {"date": "2024-11-22", "rating": "متوسط", "notes": "تحسن في التفاعل الاجتماعي."},
       ],
       progressData: [40.0, 65.0],
     ),
     Goals(
       goalName: "تحسين الذاكرة البصرية",
       goalDescription: "مساعدة الطفل على تذكر الأشياء التي يراها بصريًا.",
       sessions: [
         {"date": "2024-11-15", "focus": "تذكر الأشكال"},
         {"date": "2024-11-22", "focus": "تذكر الصور"},
       ],
       evaluations: [
         {"date": "2024-11-15", "rating": "متوسط", "notes": "تحسن تدريجي."},
         {"date": "2024-11-22", "rating": "ممتاز", "notes": "يستطيع تذكر الصور بسهولة."},
       ],
       progressData: [60.0, 80.0],
     ),
     Goals(
       goalName: "التفكير النقدي",
       goalDescription: "تشجيع الطفل على تحليل المعلومات والتفكير النقدي.",
       sessions: [
         {"date": "2024-11-15", "focus": "تحليل قصص بسيطة"},
         {"date": "2024-11-22", "focus": "تحليل أحداث يومية"},
       ],
       evaluations: [
         {"date": "2024-11-15", "rating": "ضعيف", "notes": "يحتاج إلى المساعدة في الفهم العميق."},
         {"date": "2024-11-22", "rating": "متوسط", "notes": "بدأ في التفكير النقدي بشكل أفضل."},
       ],
       progressData: [45.0, 65.0],
     ),
     Goals(
       goalName: "تنمية الإبداع",
       goalDescription: "تشجيع الطفل على التعبير عن أفكاره بطرق إبداعية.",
       sessions: [
         {"date": "2024-11-15", "focus": "رسم وتلوين"},
         {"date": "2024-11-22", "focus": "صنع أشكال باستخدام الصلصال"},
       ],
       evaluations: [
         {"date": "2024-11-15", "rating": "متوسط", "notes": "يميل إلى التجريب."},
         {"date": "2024-11-22", "rating": "ممتاز", "notes": "أظهر أفكارًا إبداعية جديدة."},
       ],
       progressData: [55.0, 80.0],
     ),
   ];


   @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddChildCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("اختيار الأهداف"),
        actions: [
          BlocBuilder<AddChildCubit, AddChildState>(

              builder: (BuildContext context, state) {
                return Text(
                    "${bloc.selectedGoals.length > 9 ? "You have reached the max" : bloc.selectedGoals.length} / 10"
                );
         },)
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) {
            return;
          }

          const bool shouldPop =  true;
          if (context.mounted && shouldPop) {
             Navigator.pop(context,bloc.selectedGoals);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.builder(
            itemCount: goalList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>GoalDetailScreen(goal: goalList[index],)));
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            "https://www.ces-schools.net/wp-content/uploads/2020/07/AdobeStock_234287116-1024x683.jpeg",
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 200,
                          ),
                        ),
                         Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                goalList[index].goalName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                               Text(
                                 goalList[index].goalDescription,
                                style: const TextStyle(fontSize: 14, color: Colors.grey),
                
                
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                
                                  bloc.AddChild( goalList[index],context);
                                  // اكتب هنا وظيفة التحديد
                                },
                                child: const Text("اختر الهدف"),
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                onPressed: () {
                
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
