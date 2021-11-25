import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/shared/components/components.dart';
import 'package:todo_list_app/shared/cubit/cubit.dart';
import 'package:todo_list_app/shared/cubit/states.dart';




class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();
  var titleController = TextEditingController();
  var taskTimeController = TextEditingController();
  var taskDateController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit,AppStates>(
        listener: (BuildContext context, state) { if(state is AppInsertToDatabaseState){Navigator.pop(context);} },
        builder: (context,state){
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scaffoldKey,
            appBar: AppBar(
              title: Text(cubit.screensName[cubit.currentIndex]),
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              items: [
                BottomNavigationBarItem(
                  label: 'New',
                  icon: Icon(Icons.menu),
                ),
                BottomNavigationBarItem(
                  label: 'Done',
                  icon: Icon(Icons.check_circle_outline),
                ),
                BottomNavigationBarItem(
                  label: 'Archived',
                  icon: Icon(Icons.archive_outlined),
                ),
              ],
              type: BottomNavigationBarType.fixed,
              onTap: (index) {
                cubit.changeIndex(index);
              },
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fabIcon),
              onPressed: () {
                if (cubit.isBottomSheetShow) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDatabase(
                      title: titleController.text,
                      time: taskTimeController.text,
                      date: taskDateController.text,
                    );
                    cubit.bottomSheet(isShow: false, icon: Icons.edit);
                  }
                } else {
                  scaffoldKey.currentState!.showBottomSheet((context) =>
                      Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.white,
                        child: Form(
                          key: formKey,
                          child: Column(

                            mainAxisSize: MainAxisSize.min,
                            children: [
                              defaultFormField(
                                controller: titleController,
                                label: 'Task Title',
                                prefixIcon: Icons.title,
                                keyboard: TextInputType.text,
                                validate: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'Title can\'t be Empty';
                                  }
                                  return null;
                                },

                              ),
                              SizedBox(height: 15,),
                              defaultFormField(
                                  noInput: true,
                                  controller: taskTimeController,
                                  label: 'Task Time',
                                  prefixIcon: Icons.watch_later_outlined,
                                  keyboard: TextInputType.datetime,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Task Time can\'t be Empty';
                                    }
                                    return null;
                                  },
                                  onTab: () {
                                    showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now()
                                    ).then((value) {
                                      taskTimeController.text = value!.format(context);
                                    }).catchError((error) {
                                      print('Error On ShowTimePicker ${error
                                          .toString()}');
                                    });
                                  }
                              ),
                              SizedBox(height: 15,),
                              defaultFormField(
                                  noInput: true,
                                  controller: taskDateController,
                                  label: 'Task Date',
                                  prefixIcon: Icons.calendar_today,
                                  keyboard: TextInputType.datetime,
                                  validate: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'Task Date can\'t be Empty';
                                    }
                                    return null;
                                  },
                                  onTab: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime.now(),
                                      lastDate: DateTime.parse('2022-08-05'),
                                    ).then((value) {
                                      taskDateController.text =
                                          DateFormat.yMMMd().format(value!);
                                    }).catchError((error) {
                                      print('Error On ShowDatePicker ${error
                                          .toString()}');
                                    });
                                  }
                              )
                            ],
                          ),
                        ),
                      ),
                    elevation: 150,
                  ).closed.then((value){
                    cubit.bottomSheet(isShow: false, icon: Icons.edit);
                  });
                  cubit.bottomSheet(isShow: true, icon: Icons.add);


                }
              },
            ),
            body: Conditional.single(
              context: context,
              conditionBuilder:(context)=> state is! AppGetFromDatabaseLoadingState,
              widgetBuilder:(context)=> cubit.screens[cubit.currentIndex],
              fallbackBuilder: (context)=>Center(child: CircularProgressIndicator()),
            ),
          );
        },
      ),
    );
  }


}




