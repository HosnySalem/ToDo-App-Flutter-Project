import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';
import 'tools/shared.dart';

class doneScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Todocubit,Todostates>(
      listener: (context,state){},
      builder: (context,state){
        Todocubit cubit =Todocubit.get(context);
        return  buildtasklist(cubit.doneTasks);
      },

    );
  }
}
