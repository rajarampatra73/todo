import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo/todo_Bloc/todo_bloc.dart';

import 'Data/todo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  addTodo(Todo t) {
    context.read<TodoBloc>().add(AddTodo(t));
  }

  removeTodo(Todo t) {
    context.read<TodoBloc>().add(RemoveTodo(t));
  }

  alertTodo(int index) {
    context.read<TodoBloc>().add(AlterTodo(index));
  }

  TextEditingController controller = TextEditingController();
  TextEditingController controller1 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        title: Center(
          child: Text("Todo",style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontWeight: FontWeight.bold
          ),),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Add New Todo"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: controller,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                            hintText: "Todo title",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            )),
                      ),
                      TextField(
                        controller: controller1,
                        cursorColor: Theme.of(context).colorScheme.secondary,
                        decoration: InputDecoration(
                            hintText: "Todo Description",
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: const BorderSide(color: Colors.grey),
                            )),
                      ),
                      const SizedBox(height: 10.0),

                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: TextButton(
                        onPressed: () {
                          addTodo(
                            Todo(
                                title: controller.text,
                                subTitle: controller1.text),
                          );
                          controller.text="";
                          controller1.text = "";
                          Navigator.pop(context);
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(

                            side: BorderSide(
                              color:  Theme.of(context).colorScheme.secondary,
                            ),
                            borderRadius: BorderRadius.circular(10.0)
                          ),
                          foregroundColor: Theme.of(context).colorScheme.secondary,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: const Icon(
                            CupertinoIcons.check_mark,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    )
                  ],
                );
              });
        },
        child: const Icon(
          CupertinoIcons.add,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state.status == TodoStatus.success) {
              return
                ListView.builder(
                itemCount: state.todos.length,
                itemBuilder: (context, int i ){
                  return Card(
                    color: Theme.of(context).colorScheme.primary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Slidable(
                      startActionPane: ActionPane(motion: const ScrollMotion(),
                      children: [
                        SlidableAction(onPressed: (_){
                          removeTodo(state.todos[i]);
                        },
                        backgroundColor: Colors.red,
                          foregroundColor: CupertinoColors.white,
                          icon: Icons.delete,
                          label: "Delete",
                        )
                      ],
                      ),

                      key: const ValueKey(0),
                      child: ListTile(
                        trailing: Checkbox(value: state.todos[i].isDone,
                        activeColor: Theme.of(context).colorScheme.secondary,
                        onChanged: (value){
                          alertTodo(i);
                        },),
                        subtitle: Text(state.todos[i].subTitle),
                        title: Text(state.todos[i].title),
                      ),
                    ),

                  );

                },);
            } else if (state.status == TodoStatus.initial) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Container(
                child: const Text("Created Todo"),
              );
            }
          },
        ),
      ),
    );
  }
}
