import 'package:bloc_todo_app/data/repositories/locale_repository.dart';
import 'package:bloc_todo_app/data/repositories/todo_repository.dart';
import 'package:bloc_todo_app/localization/LocalizationAssetLoader.dart';
import 'package:bloc_todo_app/logic/cubits/internet_cubit/internet_cubit.dart';
import 'package:bloc_todo_app/logic/cubits/locale_cubit/locale_cubit.dart';
import 'package:bloc_todo_app/logic/cubits/todo_cubit/todo_cubit.dart';
import 'package:bloc_todo_app/presentation/router/app_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  final storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  HydratedBlocOverrides.runZoned(
    () => runApp(EasyLocalization(
        path: 'assets/translations',
        supportedLocales: const [Locale('en'), Locale('ja')],
        fallbackLocale: const Locale('en'),
        assetLoader: LocalizationAssetLoader(),
        useFallbackTranslations: true,
        child: MyApp(
          appRouter: AppRouter(),
          connectivity: Connectivity(),
        ))),
    storage: storage,
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  final Connectivity connectivity;
  final TodosRepository todosRepository = TodosRepository();
  final LocaleRepository localeRepository = LocaleRepository();

  MyApp({Key? key, required this.appRouter, required this.connectivity})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TodosCubit>(
            create: (context) => TodosCubit(todosRepository: todosRepository)),
        BlocProvider<InternetCubit>(
            create: (context) => InternetCubit(connectivity: connectivity)),
        BlocProvider<LocaleCubit>(
            create: (context) =>
                LocaleCubit(localeRepository: localeRepository))
      ],
      child: MaterialApp(
        title: "Todo App",
        onGenerateRoute: appRouter.onGenerateRoute,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        locale: context.locale,
      ),
    );
  }
}
