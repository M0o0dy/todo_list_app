


import 'package:flutter/material.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_list_app/shared/cubit/cubit.dart';

void showToast({required String msg, required state})=>Fluttertoast.showToast(
    msg: msg,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);


enum ToastStates{SUCCESS,WARNING,ERROR}


Color chooseColor (ToastStates state){
  Color color;
  switch(state){
    case ToastStates.SUCCESS : color = Colors.green;break;
    case ToastStates.WARNING : color = Colors.amber;break;
    case ToastStates.ERROR : color = Colors.red;break;
  }return color;
}



Widget defaultButton ({required String label, required Function onPressed,Color? color})=>Container(
width: double.infinity,
decoration: BoxDecoration(
  color: color?? Colors.blue,
  borderRadius: BorderRadius.circular(20),
),
child: MaterialButton(
onPressed:(){
  onPressed();
},
child: Text(
  label,
style: TextStyle(
fontSize: 20,
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
),
);




Widget defaultFormField ({
  required TextEditingController controller,
 required String label,
 required IconData prefixIcon,
  String? hintText,
  Color? outLineColor,
  Color? fillColor,
  Color? focusColor,
  Color? hoverColor,
  IconData? suffixIcon,
    VoidCallback? suffixPressed,
  FormFieldValidator<String>? validate,
  ValueChanged<String>? onChanged,
   ValueChanged<String>? onSubmitted,
  GestureTapCallback? onTab,
  required TextInputType keyboard,
  bool isPassword = false,
  bool noInput = false,
}) => TextFormField(

  cursorColor: outLineColor,
  onChanged:onChanged,
  onFieldSubmitted:onSubmitted,
  readOnly:noInput ,
  validator: validate ,
  controller: controller,
  decoration: InputDecoration(
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),),
    labelText: label,
    prefixIcon: Icon(prefixIcon),
    suffixIcon: IconButton(icon: Icon(suffixIcon),onPressed:(){
      suffixPressed!();
    } ,),
    hintText: hintText,
  ),
  keyboardType: keyboard,
  obscureText: isPassword ,
  onTap: onTab
);

Widget buildTasksItem(Map model, context)=> Dismissible(

  background: Container(alignment: AlignmentDirectional.centerEnd,
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Spacer(),
          Text('Deleted',style: TextStyle(
            color: Colors.white,
            fontSize: 30
          ),),
          Spacer(),

          Icon(Icons.delete_forever_sharp,color: Colors.white,size: 35,),
        ],
      ),
    ),
    decoration: BoxDecoration(
      color: Colors.red
    ),
  ),
  direction: DismissDirection.endToStart,

  onDismissed: (direction){
    AppCubit.get(context).deleteFromDatabase(id: model['id']);
  },
  key: Key(model['id'].toString()),

  child:   Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            child: Text(
                '${model['time']}'
            ),
          ),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
            '${model['title']}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${model['date']}',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(icon: Icon(Icons.check_circle_outline,color: Colors.green,), onPressed: (){AppCubit.get(context).updateDatabase(status: 'Done', id: model['id']);},),
          IconButton(icon: Icon(Icons.archive_outlined,color: Colors.black45,), onPressed: (){AppCubit.get(context).updateDatabase(status: 'Archived', id: model['id']);},),
        ],
      ),
  ),
);

 Widget tasksBuilder(context,{required List<Map>tasks })=> Conditional.single(
   context: context,
  conditionBuilder:(context)=> tasks.length>0,
  widgetBuilder: (context)=>ListView.separated(
    itemBuilder: (context, index) => buildTasksItem(tasks[index], context),
    separatorBuilder: (context, index) =>
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 20,),
          child: Container(
            height: 1, width: double.infinity, color: Colors.grey[300],),
        ),
    itemCount: tasks.length,
  ),
  fallbackBuilder: (context)=> Center(
    child: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.menu,
            color: Colors.grey,
            size: 150,),
          Text(
            'No Tasks Yet, Add A New Tasks',
            style: TextStyle(
              color: Colors.black45,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    ),
  ),
);



Widget myDivider()=>Padding(
  padding: const EdgeInsetsDirectional.only(start: 20,),
  child: Container(
    height: 1, width: double.infinity, color: Colors.grey[300],),
);


void navigateTo(context, widget) => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context)=> widget ));

void navigateAndFinishTo(context, widget) => Navigator.pushReplacement(context , MaterialPageRoute(builder: (BuildContext context)=> widget ),result:(route)=>false);

void printFullText(String text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}