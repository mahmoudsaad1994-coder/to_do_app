import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:intl/intl.dart';

import '../../shared/componants/components.dart';
import '../../shared/cubit/cubit.dart';
import '../../shared/cubit/states.dart';
import '../models/task_model.dart';

// ignore: must_be_immutable
class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  var scafoldKey = GlobalKey<ScaffoldState>();
  var formKey = GlobalKey<FormState>();

  var titleControlor = TextEditingController();
  var descriptionControlor = TextEditingController();
  var timeControlor = TextEditingController();
  var dateControlor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is AppInsertDatabaseState) {
          Navigator.pop(context);
          titleControlor.text = '';
          descriptionControlor.text = '';
          dateControlor.text = DateFormat.yMd().format(DateTime.now());
          timeControlor.text = DateFormat('hh:mm a')
              .format(DateTime.now().add(const Duration(minutes: 5)))
              .toString();
          AppCubit.get(context).selectedRepeate = 'Only one';
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
            actions: [
              IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: const Text('warning'),
                              content: Text(
                                'You are about to clear all tasks in ${cubit.titles[cubit.currentIndex]}',
                              ),
                              actions: <Widget>[
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('Yes, I\'m sure'),
                                  onPressed: () {
                                    if (cubit.currentIndex == 0) {
                                      cubit.deleteTasksInList(status: 'new');
                                    } else if (cubit.currentIndex == 1) {
                                      cubit.deleteTasksInList(status: 'done');
                                    } else {
                                      cubit.deleteTasksInList(
                                          status: 'archive');
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  style: TextButton.styleFrom(
                                    textStyle:
                                        Theme.of(context).textTheme.labelLarge,
                                  ),
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ));
                  },
                  icon: const Icon(Icons.delete))
            ],
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
                      model: TaskModel(
                    repeat: cubit.selectedRepeate,
                    date: dateControlor.text,
                    description: descriptionControlor.text,
                    title: titleControlor.text,
                    time: timeControlor.text,
                    status: 'new',
                  ));
                }
              } else {
                dateControlor.text = DateFormat.yMd().format(DateTime.now());
                timeControlor.text = DateFormat('hh:mm a')
                    .format(DateTime.now().add(const Duration(minutes: 5)))
                    .toString();

                scafoldKey.currentState!
                    .showBottomSheet(
                      (context) => Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          ),
                        ),
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
                                controller: descriptionControlor,
                                inputType: TextInputType.text,
                                labelText: 'Description',
                                validat: (String? value) {
                                  if (value!.isEmpty) {
                                    return 'type your description';
                                  }
                                  return null;
                                },
                                prefixIcon: Icons.description,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: defaultFormFeild(
                                      controller: timeControlor,
                                      readOnly: true,
                                      inputType: TextInputType.datetime,
                                      onTap: () {
                                        showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now(),
                                        ).then((value) {
                                          timeControlor.text =
                                              value!.format(context).toString();
                                          cubit.isDateTimeTrue(value);
                                        });
                                      },
                                      labelText: 'Task Time',
                                      validat: (String? value) {
                                        if (cubit.isDateTime) {
                                          return null;
                                        }
                                        return 'Enter a valid time';
                                      },
                                      prefixIcon: Icons.watch_later_outlined,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: defaultFormFeild(
                                    controller: dateControlor,
                                    inputType: TextInputType.datetime,
                                    readOnly: true,
                                    onTap: () {
                                      showDatePicker(
                                        context: context,
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2060),
                                        initialDate: DateTime.now(),
                                      ).then((DateTime? value) {
                                        dateControlor.text =
                                            DateFormat.yMd().format(value!);
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
                                  )),
                                ],
                              ),
                              const SizedBox(height: 15),
                              DropdownButtonFormField(
                                hint: Text(cubit.selectedRepeate),
                                items: cubit.repeatList
                                    .map((label) => DropdownMenuItem<String>(
                                          value: label,
                                          child:
                                              Center(child: Text(' $label ')),
                                        ))
                                    .toList(),
                                onChanged: (String? newValue) {
                                  cubit.newSelectedRepeate(newValue!);
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Repeat',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.repeat),
                                ),
                                iconSize: 30,
                              ),
                              const SizedBox(height: 15),
                            ],
                          ),
                        ),
                      ),
                      elevation: 50,
                    )
                    .closed
                    .then((value) {
                  cubit.changeBottomSheetState(isShow: false, icon: Icons.edit);
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
    );
  }
}
