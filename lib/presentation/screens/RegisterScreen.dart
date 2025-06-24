import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../buisiness_logic/cubit/auth_cubit.dart';
import '../../buisiness_logic/cubit/auth_state.dart';
import '../../constants/my_colors.dart';
import '../../constants/strings.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}
class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }
  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthCubit>().register(
        emailController.text,
        passwordController.text,
        confirmController.text,
      );
    }}

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red,),
          );
        }
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, characterScreen);
        }
      },
      child: Scaffold(
        backgroundColor: Mycolors.mygrey,
        appBar: AppBar(
          title: Text(
            'Register',
            style: TextStyle(color: Mycolors.mywhite, fontSize: 20.sp,),
          ),
          backgroundColor: Mycolors.myyellow,
          iconTheme: const IconThemeData(color: Mycolors.mywhite),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: 20.h),
                _buildInput(emailController, 'Email'),
                SizedBox(height: 16.h),
                _buildInput(passwordController, 'Password', isPassword: true),
                SizedBox(height: 16.h),
                _buildInput(confirmController, 'Confirm Password', isPassword: true,),
                SizedBox(height: 24.h),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Mycolors.myyellow,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r),),
                      ),
                      onPressed: isLoading ? null : _onRegisterPressed,
                      child: isLoading
                          ? CircularProgressIndicator(color: Mycolors.mywhite)
                          : Text(
                        'Create Account',
                        style: TextStyle(color: Mycolors.mywhite, fontSize: 18.sp,),
                      ),
                    );},),
                SizedBox(height: 16.h),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, loginscreen);
                  },
                  child: Text("Already have an account? Login",
                    style: TextStyle(color: Mycolors.mywhite, fontSize: 14.sp),
                  ),
                ),],
            ),),
        ),),);
  }
  Widget _buildInput(
      TextEditingController ctrl,
      String hint, {
        bool isPassword = false,
      }) {
    return TextFormField(
      controller: ctrl,
      obscureText: isPassword,
      style: TextStyle(color: Mycolors.mywhite, fontSize: 16.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Mycolors.mywhite, fontSize: 16.sp),
        filled: true,
        fillColor: Colors.black12,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r),),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h,),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return '$hint لا يمكن أن يكون فارغًا';
        if (isPassword && v.length < 6) {
          return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
        }
        return null;
      },
    );}
}
