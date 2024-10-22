import 'package:flutter/material.dart';
import 'package:todo_app/My%20folders/TaskFormPage.dart';

// Used colors in app
Color customColor1 = const Color(0XFFF2F3E7);
Color customColor2 = const Color(0XFF4C4646);
Color customColor3 = const Color(0XFFFF7F00);
Color customColor4 = const Color(0XFF005F6A);

class HomePage extends StatefulWidget{
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage>{
  //List of all tasks user puts
  List<Task> tasks = [];
  

  //(Function) Sorting user tasks (News - Oldest)
  void sortTasks(){
    tasks.sort((a, b) => b.date.compareTo(a.date));
  }

  //(Function) Adding users tasks to the list
  void addTasks (Task newTask){
    setState(() {
      //Pushing tasks to list
      tasks.add(newTask);
      //Using Sort Function
      sortTasks();
    });
  }
  //(Function) Editing on existing Task
  void editTask (int index, Task updatedTask){
    setState(() {
      tasks[index] = updatedTask;
      //Sorting with new edits if found
      sortTasks();
    });
  }

  // (Function) Counting completed tasks
  int completedTasks() {
    return tasks.where((task) => task.isCompleted).length;
  }

  @override
   Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Your Daily To DO ; )", style: TextStyle(color: customColor1, fontSize: 20),),
          centerTitle: true,
          toolbarHeight: 40,
          shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(50),
              bottomLeft: Radius.circular(50)),
        ),
        backgroundColor: customColor4,
        ),
        backgroundColor: customColor1,
        body: SafeArea(
          child: Column(
            children: [
              //First Row
              Container(
                margin:  const EdgeInsets.all(20.0),
                width: 350,
                height: 120,
                child: Row(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            "Let's Achieve More!",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: customColor4,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                               // Total tasks count
                               Text(
                                "Total Tasks: ${tasks.length}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: customColor4
                                ),
                               ),
                               //Completed tasks count
                               Text(
                                "Completed: ${completedTasks()}",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: customColor3
                                ),
                               )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 140,
                      height: 140,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        image: DecorationImage(image: AssetImage("assets/image1.png"))
                      ),
                    ),
                  ],
                ),
              ),
              //Second Row
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(10),
                  padding: const EdgeInsets.all(10),
                  //Default Set up for the container when ther is no tasks
                  child: tasks.isEmpty? Center(
                    child: Text("There's No Tasks. Want to Add Some!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: customColor3),
                    ),
                    //Set up for the container if there are tasks
                  ):ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index){
                      return GestureDetector(
                        //Double Click for editing the task
                        onDoubleTap: (){
                          Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => TaskFormPage(
                              task: tasks[index],
                              onSaveTask: (updatedTask){
                                editTask(index, updatedTask);
                              }
                            )
                          )
                          );
                        },
                        //The Cards of tasks with its style
                        child: Card(
                          color: customColor4,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              //Set up for the checkbox, task, subtasks, and delete
                              children: [
                                Row(
                                  children: [
                                    //Checkbox
                                    Checkbox(
                                      value: tasks[index].isCompleted,
                                      onChanged: (bool? value){
                                        setState(() {
                                          tasks[index].isCompleted = value ?? false;
                                        });
                                      },
                                      activeColor: customColor4,
                                      checkColor: customColor1,
                                    ),
                                    Expanded(
                                      child: Text(
                                        tasks[index].task,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          decoration: tasks[index].isCompleted? TextDecoration.lineThrough:TextDecoration.none,color: customColor1,
                                        ),
                                      )
                                    ),
                                    //Delete Button
                                    IconButton(
                                      onPressed: (){
                                        //check delete
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context){
                                            return AlertDialog(
                                              title: Text("Delete Task?", style: TextStyle(color: customColor4),),
                                              content: const Text("Are you sure you want to delete this task?"),
                                              //options
                                              actions: [
                                                TextButton(
                                                  onPressed: (){
                                                    //return the user to the home page
                                                    Navigator.pop(context);
                                                  },
                                                  child:  Text("Cancel", style: TextStyle(color: customColor3),),
                                                  ),
                                                  TextButton(
                                                    onPressed: (){
                                                      setState(() {
                                                        tasks.removeAt(index);
                                                        //Sorting after delete 
                                                        sortTasks();
                                                      });
                                                      //return the user to the home page after deleting
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Delete",style: TextStyle(color: customColor3),),
                                                  ),
                                              ],
                                            );
                                            
                                          }
                                          );
                                      },
                                      icon: Icon(Icons.delete,color: customColor1,size: 22,),
                                    )
                                  ],
                                ),
                                //Showing subtasks if there are any
                                if(tasks[index].subTasks.isNotEmpty)
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "SubTasks:",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: customColor1,
                                        ),
                                      ),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: tasks[index].subTasks.length,
                                        itemBuilder: (context, subIndex) {
                                          return Row(
                                            children: [
                                              Checkbox(
                                                value: tasks[index].subTasks[subIndex].isCompleted,
                                                onChanged: (bool? value){
                                                  setState(() {
                                                    tasks[index].subTasks[subIndex].isCompleted = value ?? false;
                                                  });
                                                },
                                                activeColor: customColor4,
                                                checkColor: customColor1,                                             
                                                 ),
                                                 //Style when subtask checked
                                                 Expanded(
                                                  child: Text(
                                                    tasks[index].subTasks[subIndex].name,
                                                    style: TextStyle(
                                                      decoration: tasks[index].subTasks[subIndex].isCompleted?TextDecoration.lineThrough:TextDecoration.none,color: customColor1,
                                                    ),
                                                  ),
                                                 ),
                                                 IconButton(
                                                  onPressed: (){
                                                    setState(() {
                                                      tasks[index].subTasks.removeAt(subIndex);
                                                    });
                                                  },
                                                 icon: Icon(Icons.delete, color: customColor1, size: 20,),
                                                 )
                                            ],
                                          );
                                        },
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  )
                ),
              ),
              //Part Three
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 50,
                  width: 50,
                  margin: const EdgeInsets.only(right: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: customColor4,
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: IconButton(
                    onPressed: (){
                      Navigator.push(
                        context, MaterialPageRoute(
                          builder: (context) => TaskFormPage(onSaveTask: (task){addTasks(task);})
                        )
                      );
                    },
                    icon: Icon(Icons.add, color: customColor1,),
                    ),
                ),
              )
            ],
          ),
        ),
      ),
    );
   }
}
