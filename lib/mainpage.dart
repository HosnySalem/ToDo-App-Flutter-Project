import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'tools/shared.dart';

class todoApp extends StatelessWidget {

  var scaffoldkey = GlobalKey<ScaffoldState>();

  var formkey = GlobalKey<FormState>();

  var title =TextEditingController();

  var date =TextEditingController();

  var time =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>Todocubit()..createadatabase(),
      child: BlocConsumer<Todocubit,Todostates>(
        listener: (BuildContext context,state){},
        builder: (BuildContext context,state){
          var cubit = Todocubit.get(context);
          return Scaffold(
            key: scaffoldkey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentindex]),
            ),
            bottomNavigationBar:BottomNavigationBar(
              items: cubit.item,
              onTap: (index){
                cubit.changeBottomNavIndex(index);
              },
              currentIndex: cubit.currentindex,
              type: BottomNavigationBarType.fixed,
            ),
            body:
            /*cubit.tasks.length < 0 ? const Center(child: CircularProgressIndicator(
              color: Colors.blue,
            )):*/
            cubit.screens[cubit.currentindex] ,

            floatingActionButton: FloatingActionButton(
              onPressed: (){
                if(cubit.showsheet){
                  if(formkey.currentState!.validate()){
                   cubit.insertToDatabase(
                        title: title.text,
                        date: date.text,
                        time: time.text);
                   // cubit.getDataFromDatabase(cubit.database);
                    Navigator.pop(context);
                    cubit.changeBottomSheet(false);
                  }
                }
                else{
                  title.text='';
                  date.text='';
                  time.text='';
                  cubit.changeBottomSheet(true);
                  scaffoldkey.currentState!.showBottomSheet((context){
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      color: Colors.white,
                      child: Form(
                        key: formkey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            myField(control: title, type: TextInputType.text, label: "Title", icon: Icons.title),
                            const SizedBox(height: 10,),
                            myField(control: time,
                                type: TextInputType.datetime,
                                label: 'Time',
                                icon: Icons.watch_later_outlined,
                                c: context,
                              onTap: (){
                                showTimePicker(context: context,
                                  initialTime: TimeOfDay.now(),
                                ).then((value){
                                  time.text =value!.format(context).toString();
                                }).catchError((error){
                                  print('$error');
                                });
                              },
                            ),
                            const SizedBox(height: 10,),
                            myField(control: date,
                              type: TextInputType.datetime,
                              label: 'Date',
                              icon: Icons.calendar_month,
                              c: context,
                              onTap:  (){
                                showDatePicker(context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate:  DateTime.parse('2023-05-03')).then((value){
                                  print(DateFormat.yMMMEd().format(value!));
                                  date.text=DateFormat.yMMMEd().format(value);
                                }).catchError((error){
                                  print('$error');
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                    elevation: 15,
                  ).closed.then((value){
                    cubit.changeBottomSheet(false);
                  });
                 cubit.createadatabase();
                }
              },
              child: Icon(cubit.showsheet?Icons.add:Icons.edit),
            ),
          );
        },

      ),
    );


  }


}


