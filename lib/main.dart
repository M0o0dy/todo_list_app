import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_app/layout/todo_layout.dart';
import 'package:todo_list_app/shared/bloc_observer.dart';
import 'package:todo_list_app/shared/cubit/cubit.dart';
import 'package:todo_list_app/shared/cubit/states.dart';
import 'package:todo_list_app/shared/network/local/cache_helper.dart';
import 'package:todo_list_app/shared/network/remote/dio_helper.dart';
import 'package:todo_list_app/shared/styles/themes.dart';

void main() async{
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  runApp(MyApp());
}
class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=>AppCubit(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context,state){},
          builder: (context,state) {

            return MaterialApp(
              theme:lightTheme,
              darkTheme:  darkTheme,
              themeMode: ThemeMode.light,
              debugShowCheckedModeBanner: false,
              home: TodoApp(),
            );
          }
      ),
    );
  }

}
