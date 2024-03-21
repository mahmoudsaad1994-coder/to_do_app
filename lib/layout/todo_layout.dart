import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:intl/intl.dart';

import '../../shared/componants/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scafoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleControlor = TextEditingController();
  var timeControlor = TextEditingController();
  var dateControlor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // .. like take object from class and get the body(methods and feilds)
      create: (context) => AppCubit()..createDataBase(),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is AppInsertDatabaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);
          return Scaffold(
            key: scafoldKey,
            appBar: AppBar(
              title: Text(cubit.titles[cubit.currentIndex],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  )),
              centerTitle: true,
            ),
            body: ConditionalBuilder(
              condition: state is! AppGetDatabaseLoadingState,
              builder: (context) => cubit.screens[cubit.currentIndex],
              fallback: (context) =>
                  const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(cubit.fadeIcon),
              onPressed: () {
                if (cubit.isBottomSheetShown) {
                  if (formKey.currentState!.validate()) {
                    cubit.insertToDataBase(
                      title: titleControlor.text,
                      date: dateControlor.text,
                      time: timeControlor.text,
                    );
                  }
                } else {
                  scafoldKey.currentState!
                      .showBottomSheet(
                        (context) => Container(
                          color: Colors.white70,
                          padding: const EdgeInsets.all(20),
                          child: Form(
                            key: formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                defaultFormFeild(
                                  controller: titleControlor,
                                  inputType: TextInputType.text,
                                  labelText: 'Task Title',
                                  validat: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'title muse not be empty';
                                    }
                                    return null;
                                  },
                                  prefixIcon: Icons.title,
                                ),
                                const SizedBox(height: 15),
                                defaultFormFeild(
                                  controller: timeControlor,
                                  readOnly: true,
                                  inputType: TextInputType.datetime,
                                  onTap: () {
                                    showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.now(),
                                    ).then((value) => {
                                          timeControlor.text =
                                              value!.format(context).toString()
                                        });
                                  },
                                  labelText: 'Task Time',
                                  validat: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'time muse not be empty';
                                    }
                                    return null;
                                  },
                                  prefixIcon: Icons.watch_later_outlined,
                                ),
                                const SizedBox(height: 15),
                                defaultFormFeild(
                                  controller: dateControlor,
                                  inputType: TextInputType.datetime,
                                  readOnly: true,
                                  onTap: () {
                                    showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate:
                                                DateTime.parse('2024-08-03'),
                                            initialDate: DateTime.now())
                                        .then((DateTime? value) {
                                      dateControlor.text =
                                          DateFormat.yMMMd().format(value!);
                                    });
                                  },
                                  labelText: 'Task Date',
                                  validat: (String? value) {
                                    if (value!.isEmpty) {
                                      return 'date muse not be empty';
                                    }
                                    return null;
                                  },
                                  prefixIcon: Icons.calendar_today,
                                ),
                              ],
                            ),
                          ),
                        ),
                        elevation: 50,
                      )
                      .closed
                      .then((value) {
                    cubit.changeBottomSheetState(
                        isShow: false, icon: Icons.edit);
                  });
                  cubit.changeBottomSheetState(isShow: true, icon: Icons.add);
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                cubit.changeIndex(index);
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.menu), label: 'Tasks'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.check_circle_outline), label: 'Done'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.archive_outlined), label: 'Archive'),
              ],
            ),
          );
        },
      ),
    );
  }
}
