import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/posts_screen.dart';
import 'package:social_media_app/screens/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String id = 'sign_in';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';

  String _password = '';

  late final FocusNode _passwordFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      //Invalid
      return;
    }
    _formKey.currentState!.save();
    context.read<AuthCubit>().signIn(email: _email, password: _password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (prevState, currentState) {
          if (currentState is AuthSignedIn) {
            // Navigator.of(context).pushReplacementNamed(PostsScreen.id);
          }
          if (currentState is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(currentState.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return SafeArea(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18.0),
                        child: Text("Войдите",
                            style: Theme.of(context).textTheme.headline3),
                      ),
                      const SizedBox(height: 15),
                      //* email
                      TextFormField(
                        //! проверка формы ввода email
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            //! цвет выделенного бордера
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Введите ваш email"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        onSaved: (value) {
                          _email = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Пожалуйста введите email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),

                      //* password
                      TextFormField(
                        focusNode: _passwordFocusNode,
                        obscureText: true,
                        decoration: const InputDecoration(
                            //! цвет выделенного бордера
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Введите пароль"),
                        onFieldSubmitted: (_) {
                          _submit(context);
                        },
                        onSaved: (value) {
                          _password = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Пожалуйста введите пароль";
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: const Text(
                          'Войти',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFBFC6CC),
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed(SignUpScreen.id);
                        },
                        child: const Text(
                          'Перейти к регистрации',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFBFC6CC),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
