import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد flutter_screenutil
import 'buisiness_logic/cubit/auth_cubit.dart';
import 'buisiness_logic/cubit/characters_cubit.dart';
import 'constants/strings.dart';
import 'data/repository/authentication_repository.dart';
import 'data/repository/characters_repository.dart';
import 'data/web_services/characters_web_services.dart';
import 'app_router.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final charactersRepository = CharactersRepository(CharactersWebServices());
  final authRepository = AuthenticationRepository();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => authRepository,
        ),
        RepositoryProvider<CharactersRepository>(
          create: (_) => charactersRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (ctx) => AuthCubit(ctx.read<AuthenticationRepository>()),
          ),
          BlocProvider<CharactersCubit>(
            create: (ctx) =>
            CharactersCubit(ctx.read<CharactersRepository>())..getAllCharacters(),
          ),
        ],
        child: MyApp(appRouter: AppRouter(charactersRepository)),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter appRouter;
  const MyApp({Key? key, required this.appRouter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 852), // عدلها بناءً على مسودة التصميم لديك
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: splashscreen,
          onGenerateRoute: appRouter.generateRoute,

        );
      },

    );
  }
}
