import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/logic/cubit/counter_cubit.dart';

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Screen 2"),
      ),
      body: BlocListener<CounterCubit, CounterState>(
        listener: (context, state) {
          if (state.wasIncremented == true) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Incremented")));
          } else if (state.wasIncremented == false) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Decremented")));
          }
        },
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FloatingActionButton(
                heroTag: 'btn1',
                onPressed: () {
                  BlocProvider.of<CounterCubit>(context).decrement();
                },
                child: const Icon(Icons.remove),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                child: BlocBuilder<CounterCubit, CounterState>(
                  builder: (context, state) {
                    return Text(
                      state.counterValue.toString(),
                      style: const TextStyle(fontSize: 60.0),
                    );
                  },
                ),
              ),
              FloatingActionButton(
                heroTag: 'btn2',
                onPressed: () {
                  BlocProvider.of<CounterCubit>(context).increment();
                },
                child: const Icon(Icons.add),
              )
            ],
          ),
        ),
      ),
    );
  }
}
