import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tomato/Timer_service.dart';
import 'package:tomato/chart.dart';
import 'package:tomato/clock.dart';

class task extends StatefulWidget {
  const task({super.key});

  @override
  State<task> createState() => _taskState();
}

class _taskState extends State<task> {
  List<TaskModel> tasks = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  double Frange = 0;
  double Rrange = 0;

  void addTask() {
    TextEditingController _taskController = TextEditingController();
    double _frange = Frange;
    double _rrange = Rrange;

    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setDState) {
            return AlertDialog(
              title: Text("Add Task"),
              backgroundColor: Theme.of(context).colorScheme.background,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _taskController,
                    decoration: InputDecoration(
                      hintText: "Enter Task",
                      hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text("FocusTime:  ${_frange.toInt()}  mines",style: TextStyle(fontSize: 20),),
                  Slider(
                      value: _frange,
                      max: 60,
                      min: 0,
                      activeColor: Colors.lime,
                      label: "${_frange.toInt()} mines",
                      onChanged: (value) {
                        setDState(() {
                          _frange = value;
                        });
                      }),
                  Text("RestTime:  ${_rrange.toInt()}  mines",style: TextStyle(fontSize: 20),),
                  Slider(
                      value: _rrange,
                      max: 60,
                      min: 0,
                      activeColor: Colors.orangeAccent[100],
                      label: "${_rrange.toInt()} mines",
                      onChanged: (value) {
                        setDState(() {
                          _rrange = value;
                        });
                      })
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary),
                    )),
                TextButton(
                    onPressed: () {
                      if (_taskController.text.isNotEmpty) {
                        final newTask = TaskModel(
                          title:  _taskController.text,
                          Focus:  _frange.toInt(),
                          Rest:                      _rrange.toInt()
                      );
                        setState(() {
                          tasks.add(newTask);
                        });
                        _listKey.currentState?.insertItem(tasks.length - 1);
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Add",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary),
                    ))
              ],
            );
          });
        });
  }

  void DeleteTask(int index) {
    final removeTask = tasks[index];

    _listKey.currentState?.removeItem(index, (context, animation) {
      return SizeTransition(
        sizeFactor: animation,
        child: Card(
          color: Theme.of(context).colorScheme.inversePrimary,
          child: ListTile(
            title: Text(removeTask.title),
            subtitle:
                Text("Focus${removeTask.Focus},rest ${removeTask.Rest}"),
          ),
        ),
      );
    }, duration: Duration(milliseconds: 300));

    Future.delayed(Duration(milliseconds: 300), (){
      setState(() {
        tasks.removeAt(index);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                List<String> focusTime = tasks.map((task) => task.Focus.toString()).toList();
                Navigator.push(context, MaterialPageRoute(builder: (context) => chart(focusTime: focusTime,)));
              },
              icon: Icon(
                Icons.bar_chart_sharp,
                color: Theme.of(context).colorScheme.tertiary,
              )),
        ],
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Center(
            child: Text(
          "Your Task ",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.tertiary,
              fontSize: 30),
        )),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
                child: tasks.isEmpty
                    ? Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            Text(
                              "Let's create a task !",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 25),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            Icon(
                              Icons.task_outlined,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 65,
                            )
                          ]))
                    : AnimatedList(
                        key: _listKey,
                        initialItemCount: tasks.length,
                        itemBuilder: (context, index, animation) {
                          return SizeTransition(
                            sizeFactor: animation,
                            child: Card(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              child: ListTile(
                                  title: Text(
                                    tasks[index].title,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .tertiary),
                                  ),
                                  subtitle: Text(
                                      "Focus: ${tasks[index].Focus}, Rest: ${tasks[index].Rest}",style: TextStyle(fontSize: 20),),
                                  trailing: IconButton(
                                      onPressed: () => DeleteTask(index),
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                  onTap: () {
                                    final timerService =
                                        Provider.of<TimerService>(context,
                                            listen: false);
                                    timerService.setTime(tasks[index].Focus);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TimerScreen(
                                              tasks: tasks,
                                                focusT: tasks[index].Focus,
                                                restT: tasks[index].Rest)));
                                  }),
                            ),
                          );
                        },
                      ))
          ],
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            right: 40,
            bottom: 60,
            child: FloatingActionButton(
              onPressed: addTask,
              child: Icon(
                Icons.add,
                size: 35,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          )
        ],
      ),
    );
  }
}

class TaskModel {
  final String title;
  final int Focus;
  final int Rest;
  TaskModel({required this.title, required this.Focus,required this.Rest});
}
