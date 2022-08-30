import 'package:flutter/material.dart';

import '../cubit/cubit.dart';

Widget buildTaskItem(Map task,context) => Dismissible(
  key: Key(task['id'].toString()),
  child:   ListTile(
        leading: CircleAvatar(
          radius: 40,
          backgroundColor: Colors.blue,
          child: Text(
            task['time'],
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        title: Text(
          task['title'],
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(
          task['date'],
          style: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: (){
              Todocubit.get(context).updateData(status: 'done', id: task['id']);
            },
            icon:const Icon(Icons.done)),
        const SizedBox(width: 5,),
        IconButton(
            onPressed: (){
              Todocubit.get(context).updateData(status: 'archived', id: task['id']);
            },
            icon:const Icon(Icons.archive_outlined)),
      ],
    ),

      ),
  onDismissed: (direction){
    Todocubit.get(context).deleteData( id: task['id']);
  },
);

Widget buildtasklist(List tasks) => tasks.length > 0 ?
       ListView.separated(
          itemBuilder: (context, index) => buildTaskItem(tasks[index],context),
          separatorBuilder: (context, index) => const Divider(
                height: 1,
                thickness: 2,
                indent: 7,
                color: Colors.grey,
              ),
          itemCount: tasks.length) :
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:const [
            Icon(Icons.menu, size: 100.0, color: Colors.grey,),
            Text(
              'No Tasks Yet, Please Add Some Tasks',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );

Widget myField({
  BuildContext? c,
  @required TextEditingController? control,
  @required TextInputType? type,
  @required String? label,
  @required IconData? icon,
  Function? Function()? onTap,
}) =>
    TextFormField(
      controller: control,
      keyboardType: type,
      validator: (value) {
        if (value!.isEmpty) return '$label Can\'t be empty';
        control!.text = value;
      },
      onTap: onTap,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
