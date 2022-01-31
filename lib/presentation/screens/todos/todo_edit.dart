import 'package:bloc_todo_app/constants/enums.dart';
import 'package:bloc_todo_app/data/models/todo.dart';
import 'package:bloc_todo_app/logic/cubits/todo_cubit/todo_cubit.dart';
import 'package:bloc_todo_app/presentation/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class TodoEdit extends StatelessWidget {
  TodoEdit({Key? key, required this.todo}) : super(key: key);

  final Todo todo;

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tr('edit_page_title')),
      ),
      body: BlocListener<TodosCubit, TodosState>(
        listener: (context, state) {
          if (state.status == Status.updateSuccess) {
            Navigator.pop(context);
            showSnackBar(context, Colors.green, "Todo saved 🙂");
            return;
          } else if (state.status == Status.deleteSuccess) {
            Navigator.pop(context);
            showSnackBar(context, Colors.green, "Todo Deleted 🚮");
            return;
          } else if (state.status == Status.failure) {
            showSnackBar(context, Colors.red, state.error.toString());
            return;
          }
        },
        child: _body(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          BlocProvider.of<TodosCubit>(context).deleteTodo(todo);
        },
        child: const Icon(Icons.delete),
        backgroundColor: Colors.red[400],
      ),
    );
  }

  Widget _body(context) {
    _textController.text = todo.content;
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
            BlocProvider.of<TodosCubit>(context)
                .updateTodo({"content": todoBody}, todo);
          }, child:
              BlocBuilder<TodosCubit, TodosState>(builder: (context, state) {
            if (state.status == Status.updatePending) {
              return const CircularProgressIndicator();
            }
            return const Text("Save todo");
          }))
        ],
      ),
    );
  }
}
