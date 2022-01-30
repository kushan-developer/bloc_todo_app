import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_app/constants/enums.dart';
import 'package:flutter_bloc_app/logic/cubit/counter_cubit.dart';
import 'package:flutter_bloc_app/logic/cubit/internet_cubit.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocListener<InternetCubit, InternetState>(
      listener: (context, internetState) {
        if (internetState is InternetConnected &&
            internetState.connectionType == ConnectionType.Wifi) {
          BlocProvider.of<CounterCubit>(context).increment();
        } else if (internetState is InternetConnected &&
            internetState.connectionType == ConnectionType.Mobile) {
          BlocProvider.of<CounterCubit>(context).decrement();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Counter App"),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<InternetCubit, InternetState>(
                    builder: (context, state) {
                  if (state is InternetConnected &&
                      state.connectionType == ConnectionType.Wifi) {
                    return const Text("Connected to Wifi");
                  } else if (state is InternetConnected &&
                      state.connectionType == ConnectionType.Mobile) {
                    return const Text("Connected to Mobile Network");
                  } else if (state is InternetDisconnected) {
                    return const Text("Disconnected :/");
                  }
                  return const CircularProgressIndicator();
                }),
                Row(
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
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: 'btn3',
          onPressed: () {
            Navigator.of(context).pushNamed("/second");
          },
          child: const Icon(Icons.navigate_next),
        ),
      ),
    );
  }
}
