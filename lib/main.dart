import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/todo_layout.dart';
import 'shared/bloc_observer.dart';
import 'shared/cubit/cubit.dart';
import 'shared/network/local/local_notification_service.dart';
import 'shared/styles/themes.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNoticficationService.init();
  Bloc.observer = MyBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..createDataBase(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: HomeLayout(),
      ),
    );
  }
}
