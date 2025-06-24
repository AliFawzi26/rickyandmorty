import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repository/authentication_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthenticationRepository _repo;
  late final Stream<User?> _authStateSub;

  AuthCubit(this._repo) : super(AuthInitial()) {
    _authStateSub = _repo.authStateChanges;
    _authStateSub.listen((user) {
      if (user != null) emit(AuthAuthenticated(user));
      else emit(AuthUnauthenticated());
    });
  }

  Future<void> register(String email, String password, String confirmPassword) async {
    if (password != confirmPassword) {
      emit(AuthFailure("كلمتا المرور غير متطابقتين"));
      return;
    }
    emit(AuthLoading());
    try {
      final cred = await _repo.register(email: email, password: password);
      emit(AuthAuthenticated(cred.user!));
    } on FirebaseAuthException catch (e) {
      final msg = {
        'weak-password': 'كلمة المرور ضعيفة جدًا',
        'email-already-in-use': 'البريد الإلكتروني مستخدم مسبقًا',
        'invalid-email': 'صيغة البريد الإلكتروني غير صحيحة',
      }[e.code] ?? e.message ?? 'حدث خطأ غير معروف';
      emit(AuthFailure(msg));
    } catch (e) {
      emit(AuthFailure("خطأ: $e"));
    }
  }

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final cred = await _repo.login(email: email, password: password);
      emit(AuthAuthenticated(cred.user!));
    } on FirebaseAuthException catch (e) {
      final msg = {
        'user-not-found': 'المستخدم غير موجود',
        'wrong-password': 'كلمة المرور غير صحيحة',
        'invalid-email': 'صيغة البريد الإلكتروني غير صحيحة',
      }[e.code] ?? e.message ?? 'حدث خطأ غير معروف';
      emit(AuthFailure(msg));
    } catch (e) {
      emit(AuthFailure("خطأ: $e"));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await _repo.logout();
    emit(AuthUnauthenticated());
  }
}
