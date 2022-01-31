import 'dart:async';

import 'package:bloc_todo_app/constants/enums.dart';
import 'package:bloc_todo_app/constants/constants.dart';
import 'package:bloc_todo_app/localization/LocalizationAssetLoader.dart';
import 'package:bloc_todo_app/logic/cubits/internet_cubit/internet_cubit.dart';
import 'package:bloc_todo_app/logic/cubits/locale_cubit/locale_cubit.dart';
import 'package:bloc_todo_app/logic/cubits/todo_cubit/todo_cubit.dart';
import 'package:bloc_todo_app/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class TodoHome extends StatefulWidget {
  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  @override
  void initState() {
    BlocProvider.of<LocaleCubit>(context).updateTranslationsFromServer();
    BlocProvider.of<TodosCubit>(context).fetchTodos();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LocaleCubit, LocaleState>(
      listener: (context, state) {
        if (state.status == Status.failure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.error.toString()),
            action: SnackBarAction(
              label: "Retry",
              onPressed: () {
                BlocProvider.of<LocaleCubit>(context)
                    .updateTranslationsFromServer()
                    .then((translationsUpdated) {
                  if (translationsUpdated) {
                    context.setLocale(const Locale('en')).whenComplete(() {
                      Timer(const Duration(seconds: 2), () {
                        context.setLocale(state.locale as Locale);
                      });
                    });
                  }
                });
              },
            ),
          ));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr('app_title') +
              " (lang: ${context.locale.languageCode.toUpperCase()})"),
          actions: [
            DropdownButton<Locale>(
              value: context.locale,
              icon: const Icon(Icons.keyboard_arrow_down),
              items: context.supportedLocales.map((Locale locale) {
                return DropdownMenuItem(
                  value: locale,
                  child: Text(
                    locale.languageCode,
                    style: const TextStyle(color: Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (Locale? newLocale) async {
                context.setLocale(newLocale as Locale);
                BlocProvider.of<LocaleCubit>(context)
                    .updateLocale(context.locale);
                if (BlocProvider.of<LocaleCubit>(context).state.status !=
                    Status.success) {
                  BlocProvider.of<LocaleCubit>(context)
                      .updateTranslationsFromServer();
                }
              },
            ),
          ],
        ),
        body: BlocListener<TodosCubit, TodosState>(
          listener: (context, state) {
            if (state.status == Status.failure) {
              showSnackBar(context, Colors.red, state.error.toString());
            }
          },
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: BlocBuilder<InternetCubit, InternetState>(
                      builder: (context, state) {
                    if (state is InternetConnected &&
                        state.connectionType == ConnectionType.wifi) {
                      return const Text("Connected to Wifi");
                    } else if (state is InternetConnected &&
                        state.connectionType == ConnectionType.mobile) {
                      return const Text("Connected to Mobile Network");
                    } else if (state is InternetDisconnected) {
                      return const Text("Disconnected :/");
                    }
                    return const CircularProgressIndicator();
                  }),
                ),
                BlocBuilder<TodosCubit, TodosState>(
                  builder: (context, state) {
                    final todos = state.todos;
                    if (state.status == Status.loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Expanded(
                      child: ListView(
                          children: todos
                              .map((todo) => ListTile(
                                    title: Text(todo.content.toString()),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pushNamed(
                                                  context, editTodoRoute,
                                                  arguments: todo);
                                            },
                                            icon: const Icon(Icons.edit)),
                                        IconButton(
                                          onPressed: () async {
                                            BlocProvider.of<TodosCubit>(context)
                                                .updateTodo({
                                              "isCompleted": !todo.isCompleted
                                            }, todo);
                                          },
                                          icon: const Icon(Icons.check),
                                          color: todo.isCompleted
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'addTodoBtn',
          onPressed: () {
            Navigator.of(context).pushNamed(addTodoRoute);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
