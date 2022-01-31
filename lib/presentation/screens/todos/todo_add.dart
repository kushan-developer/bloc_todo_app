import 'package:bloc_todo_app/constants/enums.dart';
import 'package:bloc_todo_app/logic/cubits/todo_cubit/todo_cubit.dart';
import 'package:bloc_todo_app/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class TodoAdd extends StatelessWidget {
  TodoAdd({Key? key}) : super(key: key);

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('add_page_title')),
      ),
      body: BlocListener<TodosCubit, TodosState>(
        listener: (context, state) {
          if (state.status == Status.createSuccess) {
            Navigator.pop(context);
            showSnackBar(context, Colors.green, "Todo created 🙂");
            return;
          } else if (state.status == Status.failure) {
            showSnackBar(context, Colors.red, state.error.toString());
            return;
          }
        },
        child: _body(context),
      ),
    );
  }

  Widget _body(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            autofocus: true,
            controller: _textController,
            decoration: const InputDecoration(hintText: "Enter todo..."),
          ),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(onPressed: () {
            final todoBody = _textController.text;
            BlocProvider.of<TodosCubit>(context).addTodo(
                {"content": todoBody, "isCompleted": false},
                BlocProvider.of<TodosCubit>(context).state.todos);
          }, child:
              BlocBuilder<TodosCubit, TodosState>(builder: (context, state) {
            if (state.status == Status.createPending) {
              return const CircularProgressIndicator();
            }
            return const Text("Create todo");
          }))
        ],
      ),
    );
  }
}
