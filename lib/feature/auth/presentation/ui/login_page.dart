import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_bloc.dart';
import 'package:themoviedb/feature/auth/presentation/bloc/profile/profile_event.dart';
import 'package:themoviedb/main_page.dart';
import 'package:themoviedb/utils/color_palettes.dart';
import 'package:themoviedb/widget/custom_button.dart';
import 'package:themoviedb/widget/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoaded) {
            // ✅ Sinkronkan user ke ProfileBloc
            context.read<ProfileBloc>().add(UpdateProfileFromAuth(state.user));

            // ✅ Arahkan ke MainPage setelah login sukses
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const MainPage()),
              (route) => false,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                SizedBox(height: height * 0.05),
                Image.asset('assets/logo.png', height: height * 0.15),
                const Text(
                  'TMDB',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800),
                ),
                const Text(
                  'Siap-siaplah untuk terjun ke dalam kisah-kisah\nterhebat di TV dan film',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: height * 0.04),
                CustomTextFormField(
                  height: height,
                  title: 'Alamat Email',
                  controller: _emailController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!val.contains('@')) return 'Email tidak valid';
                    return null;
                  },
                ),
                SizedBox(height: height * 0.02),
                CustomTextFormField(
                  height: height,
                  title: 'Password',
                  controller: _passwordController,
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: height * 0.03),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return CustomButton(
                      height: height,
                      widht: width,
                      title: isLoading ? 'Loading...' : 'Login',
                      isActiveBaground: true,
                      onPress:
                          isLoading
                              ? null
                              : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    LoginRequested(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                    ),
                                  );
                                }
                              },
                    );
                  },
                ),
                SizedBox(height: height * 0.04),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: ColorPalettes.greyColor,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'atau',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: ColorPalettes.greyColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: height * 0.04),
                CustomButton(
                  height: height,
                  widht: width,
                  title: 'Masuk Sebagai Tamu',
                  isActiveBaground: false,
                  onPress: () {
                    context.read<AuthBloc>().add(ContinueAsGuest());
                  },
                ),
                SizedBox(height: height * 0.05),
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'Dengan membuat akun atau masuk, Anda setuju dengan',
                      style: const TextStyle(color: Colors.black, fontSize: 12),
                      children: [
                        TextSpan(
                          text: '\nKetentuan Layanan ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            color: ColorPalettes.primaryColor,
                          ),
                        ),
                        const TextSpan(
                          text: 'dan ',
                          style: TextStyle(color: Colors.black),
                        ),
                        TextSpan(
                          text: 'Kebijakan Privasi ',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                            color: ColorPalettes.primaryColor,
                          ),
                        ),
                        const TextSpan(
                          text: 'kami',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
