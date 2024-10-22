import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color customColor1 = const Color(0XFFF2F3E7);
Color customColor2 = const Color(0XFF4C4646);
Color customColor3 = const Color(0XFFFF7F00);
Color customColor4 = const Color(0XFF005F6A);

// Main Tasks
class Task {
  String task;
  DateTime date;
  bool isCompleted;
  List<SubTask> subTasks;

  Task({
    required this.task,
    required this.date,
    this.isCompleted = false,
    this.subTasks = const [],
  });
}

// Subtasks class
class SubTask {
  String name;
  bool isCompleted;

  SubTask({
    required this.name,
    this.isCompleted = false,
  });
}

class TaskFormPage extends StatefulWidget {
  final Task? task;
  final Function(Task) onSaveTask;

  const TaskFormPage({super.key, this.task, required this.onSaveTask});

  @override
  State<TaskFormPage> createState() => _TaskFormPage();
}


class _TaskFormPage extends State<TaskFormPage> {
  // Store tasks
  List<Task> tasks = [];
  // Store subTasks
  List<SubTask> _subTasks = [];
  // To add SubTasks without Saving Everytime
  FocusNode focusMood = FocusNode();
  // Automatic selection for date
  DateTime _selectedDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subTaskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _nameController.text = widget.task!.task;
      _subTasks = widget.task!.subTasks;
      _selectedDate = widget.task!.date; 
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subTaskController.dispose();
    focusMood.dispose();
    super.dispose();
  }

  // Add subtasks
  void addSubTask() {
    if (_subTaskController.text.isNotEmpty) {
      setState(() {
        _subTasks.add(SubTask(name: _subTaskController.text));
        _subTaskController.clear();
      });
    }
  }

  // Delete subTasks
  void removeSubTask(int index) {
    setState(() {
      _subTasks.removeAt(index);
    });
  }

  // Select date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(3000),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }
//auto save when use arrow icon
 void _autoSaveTask() {
    if (_nameController.text.isNotEmpty) {
      Task newTask = Task(
        task: _nameController.text,
        date: _selectedDate,
        subTasks: _subTasks,
      );
      widget.onSaveTask(newTask);
    }
  }
//auto save when use back botton (phone)
 Future<bool> _onWillPop() async {
    _autoSaveTask(); 
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
    child: Scaffold(
      backgroundColor: customColor1,
      body: Padding(
        padding: const EdgeInsets.all(38),
        child: ListView(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color:customColor4,
                    borderRadius: const BorderRadius.all(Radius.circular(20))
                  ),
                  child: IconButton(
                    onPressed: () {
                      _autoSaveTask();
                      Navigator.pop(context); 
                      },
                    icon: Icon(Icons.arrow_back, color: customColor1,),
                    iconSize: 25,
                    ),
                ),
                const SizedBox(width: 10,),
                //Title
                Text(
                  "Your New Task: ",
                  style: TextStyle(
                    fontSize: 22, color: customColor4, fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40,),
            //Part Two
            Form(
              key:  _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: "Task Name",
                      labelStyle: TextStyle(color: customColor2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: customColor4,
                          width: 2.0
                            )
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide(
                          color: customColor4,
                          width: 2.0
                        )
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                          color: customColor4,
                          width: 2.0
                        )
                      )
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                         return 'Please Enter a Name for your Task';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  datePicker(),
                  const SizedBox(height: 20),
                   _buildSubtaskInput(),
                   SizedBox(
                    height: 290,
                    child: SingleChildScrollView(
                      child:  _buildSubtaskList(),
                    ),
                   ),
                   const SizedBox(height: 10),
                   Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: (){
                        if (_formKey.currentState!.validate()){
                          Task newTask = Task(
                            task: _nameController.text,
                            date: _selectedDate,
                            subTasks: _subTasks,
                          );
                          widget.onSaveTask(newTask);
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0
                        ),
                        minimumSize: const Size(100, 40),
                        backgroundColor: customColor4
                      ),
                      child: Text('Save!', style: TextStyle(color:customColor3 ),),
                      ),
                   )
                ],
              ),
            )
          ],
        ),
      ),
    )
    );

  }
  

  // Date Widget
  Widget datePicker(){
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: customColor4,
        borderRadius: BorderRadius.circular(25)
      ),
      child: ListTile(
        title: Text(
          'Date: ${DateFormat.yMd().format(_selectedDate)}',
          style: TextStyle(fontWeight: FontWeight.bold, color: customColor1),
          textAlign: TextAlign.center,
        ),
        onTap: () => selectDate(context), 
      ),
    );
  }
   // SubTask Input
  Widget _buildSubtaskInput() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _subTaskController,
            focusNode: focusMood,
            onSubmitted: (value) {
              addSubTask();
              focusMood.requestFocus();
            },
            decoration: InputDecoration(
              labelText: "Add Subtask",
               labelStyle: TextStyle(color: customColor2),
               border: OutlineInputBorder(
                 borderRadius: BorderRadius.circular(25.0),
                 borderSide: BorderSide(
                  color: customColor4,
                  width: 2.0
                 )
               ),
               focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(
                  color: customColor4,
                  width: 2.0
                )
               ),
               enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                  color: customColor4,
                  width: 2.0
                )
                )
            ),
          ),
        ),
        Container(
          width: 50,
          height: 50,
          margin: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: customColor4,
            borderRadius: const BorderRadius.all(Radius.circular(20)),
          ),
          child: IconButton(
            onPressed: (){
              addSubTask();
            },
            icon: Icon(Icons.add, color: customColor1), iconSize: 25,
            ),
        )
      ],
    );
  }
  //List of subtasks
   Widget _buildSubtaskList() {
    if(_subTasks.isEmpty) {
      return SizedBox(
        height: 230,
        child: Center(
          child: Text(
            'No Subtasks!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:customColor4 ,
            ),
          ),
        ),
      );
    }
    return Column(
      children:_subTasks.asMap().entries.map((entry){
       int index = entry.key;
       SubTask subTask = entry.value;
       return ListTile(
        leading: Checkbox(
          value: subTask.isCompleted,
          onChanged: (bool?value){
            setState(() {
              _subTasks[index].isCompleted = value ?? false;
            });
          },
          activeColor: customColor4,
          checkColor: customColor1,
          ),
          title: Text(
            subTask.name,
            style: TextStyle(
              decoration: subTask.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
          trailing: IconButton(
            onPressed:() => removeSubTask(index),
            icon: Icon(Icons.delete, color: customColor4,),

            ),
       );
      }).toList(),
    );
   }
}