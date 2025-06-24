// /*import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rick/buisiness_logic/cubit/characters_cubit.dart';
// import 'package:rick/data/repository/characters_repository.dart';
// import 'package:rick/presentation/screens/characterDetailsScreen.dart';
// import 'package:rick/presentation/screens/characters_screen.dart';
// import 'constants/strings.dart';
// import 'data/models/characters.dart';
// import 'data/web_services/characters_web_services.dart';
//
// class AppRouter{
//   late CharactersRepository charactersRepository;
//   late CharactersCubit charactersCubit;
//
//   AppRouter(){
//     charactersRepository=CharactersRepository(CharactersWebServices());
//     charactersCubit=CharactersCubit(charactersRepository);
//   }
//   Route? generateRoute(RouteSettings settings){
//     switch(settings.name){
//       case CharactersScreen:
//         return MaterialPageRoute(builder: (_)=>BlocProvider(
//             create: (BuildContext context)=>CharactersCubit(charactersRepository),
//           child: CharactersScreen(),
//         )
//             );
//       case characterDetailsScreen:
//         final result = settings.arguments as Result;
//         return MaterialPageRoute(
//           builder: (_) => CharacterDetailsScreen(character: result),
//         );
//     }
//   }
// }*/
//
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:rick/data/repository/characters_repository.dart';
// import 'package:rick/buisiness_logic/cubit/characters_cubit.dart';
// import 'package:rick/presentation/screens/characters_screen.dart';
// import 'package:rick/presentation/screens/characterDetailsScreen.dart';
// import 'package:rick/data/models/characters.dart';
// import 'package:rick/constants/strings.dart';
// import 'package:rick/presentation/screens/locationScreen.dart';
//
//
// class AppRouter {
//   final CharactersRepository charactersRepository;
//
//   AppRouter(this.charactersRepository);
//
//   Route<dynamic>? generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//     // شاشة قائمة الشخصيات
//       case characterScreen:
//         return MaterialPageRoute(
//           builder: (_) => BlocProvider(
//             create: (context) =>
//             CharactersCubit(charactersRepository)..getAllCharacters(),
//             child: const CharactersScreen(),
//           ),
//         );
//
//     // شاشة تفاصيل الشخصية
//       case characterDetailsScreen:
//         final args = settings.arguments;
//         if (args is Result) {
//           return MaterialPageRoute(
//             builder: (_) => CharacterDetailsScreen(character: args),
//           );
//         }
//         // إذا لم يكن النوع الصحيح
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             appBar: AppBar(title: const Text('خطأ')),
//             body: const Center(child: Text('بيانات غير صحيحة لعرض تفاصيل الشخصية')),
//           ),
//         );
//
//     // شاشة تفاصيل الموقع (تُمرر هنا ID الموقع كـ int)
//       case locationDetailsScreen:
//         final args = settings.arguments;
//         if (args is int) {
//           return MaterialPageRoute(
//             builder: (_) => LocationDetailsScreen(locationId: args,repository: charactersRepository,),
//           );
//         }
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             appBar: AppBar(title: const Text('خطأ')),
//             body: const Center(child: Text('بيانات غير صحيحة لعرض تفاصيل الموقع')),
//           ),
//         );
//
//     // المسار غير معروف
//       default:
//         return MaterialPageRoute(
//           builder: (_) => Scaffold(
//             appBar: AppBar(title: const Text('404')),
//             body: Center(child: Text('لا يوجد مسار معرف لـ ${settings.name}')),
//           ),
//         );
//     }
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick/data/repository/characters_repository.dart';
import 'package:rick/buisiness_logic/cubit/characters_cubit.dart';
import 'package:rick/presentation/screens/RegisterScreen.dart';
import 'package:rick/presentation/screens/characters_screen.dart';
import 'package:rick/presentation/screens/characterDetailsScreen.dart';
import 'package:rick/data/models/characters.dart';
import 'package:rick/constants/strings.dart';
import 'package:rick/presentation/screens/locationScreen.dart';
import 'package:rick/presentation/screens/loginscreen.dart';
import 'package:rick/presentation/screens/splash_screen.dart';

class AppRouter {
  final CharactersRepository charactersRepository;
  AppRouter(this.charactersRepository);

  Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashscreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );



    // صفحة التسجيل
      case registerscreen:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
        );

    // صفحة الدخول
      case loginscreen:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

    // شاشة قائمة الشخصيات (الرئيسية)
      case characterScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) =>
            CharactersCubit(charactersRepository)..getAllCharacters(),
            child: const CharactersScreen(),
          ),
        );

    // شاشة تفاصيل الشخصية
      case characterDetailsScreen:
        final args = settings.arguments;
        if (args is Result) {
          return MaterialPageRoute(
            builder: (_) => CharacterDetailsScreen(character: args),
          );
        }
        // بيانات غير صحيحة
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('خطأ')),
            body: const Center(
              child: Text('بيانات غير صحيحة لعرض تفاصيل الشخصية'),
            ),
          ),
        );

    // شاشة تفاصيل الموقع (تُمرر هنا ID الموقع كـ int)
      case locationDetailsScreen:
        final args = settings.arguments;
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => LocationDetailsScreen(
              locationId: args,
              repository: charactersRepository,
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('خطأ')),
            body: const Center(
              child: Text('بيانات غير صحيحة لعرض تفاصيل الموقع'),
            ),
          ),
        );

    // في حالة المسار غير معروف
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            appBar: AppBar(title: const Text('404')),
            body: Center(
              child: Text('لا يوجد مسار معرف لـ ${settings.name}'),
            ),
          ),
        );
    }
  }
}
