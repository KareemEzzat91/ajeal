import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminAddChild/Addchildcubit/add_child_cubit.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/AdminChildrenSelectGooals/AdminSelectGooals.dart';
import 'package:ajeal/Admin/Screens/AdminMainScreen/Admin_Children_Screen/Goals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminAddChildScreen extends StatefulWidget {
  final String doctorId;
  final String doctorName;
  const AdminAddChildScreen(
      {super.key, required this.doctorId, required this.doctorName});

  @override
  _AdminAddChildScreenState createState() => _AdminAddChildScreenState();
}

class _AdminAddChildScreenState extends State<AdminAddChildScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController parentOccupationController =
      TextEditingController();
  final TextEditingController goalsController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController periodController = TextEditingController();
  final TextEditingController schoolController = TextEditingController();
  final TextEditingController fatherOccupationController =
      TextEditingController();
  final TextEditingController motherOccupationController =
      TextEditingController();
  final TextEditingController familyMembersController = TextEditingController();
  final TextEditingController residenceController = TextEditingController();
  final TextEditingController motherAgeDuringPregnancyController =
      TextEditingController();
  final TextEditingController relationshipBetweenParentsController =
      TextEditingController();
  final TextEditingController familyRelationshipController =
      TextEditingController();
  final TextEditingController motherNatureController = TextEditingController();
  final _key = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime? startDate;
  DateTime? endDate;
  int age = 2;
  String selectedGender = "Male";
  List<Goal> selectedItems = [];
  Future<void> _selectDate(BuildContext context, DateTime? dateType) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateType ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: dateType == selectedDate ? DateTime.now() : DateTime.utc(2030),
    );

    if (picked != null) {
      setState(() {
        if (dateType == selectedDate) {
          selectedDate = picked;
          _updateAge();
        } else if (dateType == startDate) {
          startDate = picked;
          if (endDate == null) {
            periodController.text = "3 أشهر"; // Default period of 3 months
          } else {
            periodController.text = _calculatePeriod(startDate!, endDate!);
          }
        } else if (dateType == endDate) {
          endDate = picked;
          if (startDate == null) {
            periodController.text = _calculatePeriod(DateTime.now(), endDate!);
          } else {
            periodController.text = _calculatePeriod(startDate!, endDate!);
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

    return "سنوات $years شهور $months أيام $days";
  }

  // Controllers remain the same...

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<AddChildCubit>();
    final theme = Theme.of(context);

    return BlocListener<AddChildCubit, AddChildState>(
      listener: (context, state) {
        if (state is AddLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text('Saving child information...'),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is AddScuccesState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Child added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        } else if (state is AddFailureState) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('An error occurred.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: theme.primaryColor,
          title: const Text(
            "Add New Child",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.primaryColor.withOpacity(0.1),
                Colors.white,
              ],
            ),
          ),
          child: Form(
            key: _key,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSection(
                      "Basic Information",
                      [
                        _buildAnimatedTextField(
                          controller: nameController,
                          label: "Child's Name",
                          icon: Icons.child_care,
                        ),
                        const SizedBox(height: 16),
                        _buildGenderSelector(),
                        const SizedBox(height: 16),
                        _buildDateSelector(
                          label: "Date of Birth",
                          value: selectedDate,
                          onTap: () => _selectDate(context, selectedDate),
                        ),
                        const SizedBox(height: 16),
                        _buildAnimatedTextField(
                          controller: ageController,
                          label: "Age",
                          icon: Icons.cake,
                          readOnly: true,
                        ),
                      ],
                    ),
                    _buildSection(
                      "Treatment Period",
                      [
                        _buildDateSelector(
                          label: "Start Date",
                          value: startDate,
                          onTap: () => _selectDate(context, startDate),
                        ),
                        const SizedBox(height: 16),
                        _buildDateSelector(
                          label: "End Date",
                          value: endDate,
                          onTap: () => _selectDate(context, endDate),
                        ),
                        const SizedBox(height: 16),
                        _buildAnimatedTextField(
                          controller: periodController,
                          label: "Duration",
                          icon: Icons.timer,
                          readOnly: true,
                        ),
                      ],
                    ),
                    _buildSection(
                      "Family Information",
                      [
                        _buildAnimatedTextField(
                          controller: parentOccupationController,
                          label: "Parents' Contact",
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildAnimatedTextField(
                          controller: fatherOccupationController,
                          label: "Father's Occupation",
                          icon: Icons.work,
                        ),
                        const SizedBox(height: 16),
                        _buildAnimatedTextField(
                          controller: motherOccupationController,
                          label: "Mother's Occupation",
                          icon: Icons.work,
                        ),
                      ],
                    ),
                    _buildSection(
                      "Additional Information",
                      [
                        _buildAnimatedTextField(
                          controller: schoolController,
                          label: "School/College",
                          icon: Icons.school,
                        ),
                        const SizedBox(height: 16),
                        _buildAnimatedTextField(
                          controller: residenceController,
                          label: "Residence",
                          icon: Icons.home,
                        ),
                        const SizedBox(height: 16),
                        _buildAnimatedTextField(
                          controller: motherNatureController,
                          label: "Mother's Nature",
                          icon: Icons.psychology,
                        ),
                      ],
                    ),
                    _buildSection(
                      "Goals",
                      [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.add_task),
                          label: const Text("Select Goals"),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () async {
                            if (_key.currentState!.validate()) {
                              selectedItems = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AdminSelectGoals(
                                    Phone: parentOccupationController.text,
                                  ),
                                ),
                              );
                              setState(() {});
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildGoalsList(),
                      ],
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: theme.primaryColor,
                      ),
                      onPressed: () => _handleSave(bloc, context),
                      child: const Text(
                        "Save Child Information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType? keyboardType,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        validator: (val) {
          if (val!.isEmpty) return "$label cannot be empty";
          return null;
        },
      ),
    );
  }

  Widget _buildDateSelector({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        child: Text(
          value != null
              ? "${value.day}/${value.month}/${value.year}"
              : "Select Date",
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gender",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildGenderOption(
                  "Male",
                  Icons.male,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildGenderOption(
                  "Female",
                  Icons.female,
                  Colors.pink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon, Color color) {
    final isSelected = selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => selectedGender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
            ),
            const SizedBox(width: 8),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalsList() {
    return Container(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: selectedItems.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(selectedItems[index].goalName),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    selectedItems.removeAt(index);
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSave(AddChildCubit bloc, BuildContext context) {
    if (!_key.currentState!.validate()) return;

    if (bloc.selectedGoals[parentOccupationController.text] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add goals first'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    bloc.saveChild(
      nameController.text,
      ageController.text,
      selectedDate!,
      startDate!,
      endDate!,
      periodController.text,
      parentOccupationController.text,
      notesController.text,
      schoolController.text,
      fatherOccupationController.text,
      motherOccupationController.text,
      familyMembersController.text,
      residenceController.text,
      motherAgeDuringPregnancyController.text,
      relationshipBetweenParentsController.text,
      familyRelationshipController.text,
      motherNatureController.text,
      selectedGender,
      context,
    );
  }
}
