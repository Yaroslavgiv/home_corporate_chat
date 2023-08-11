import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/bloc/auth_cubit.dart';
import 'package:social_media_app/screens/posts_screen.dart';
import 'package:social_media_app/screens/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  static const String id = 'sign_up';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _username = '';
  String _password = '';

  late final FocusNode _passwordFocusNode;
  late final FocusNode _usernameFocusNode;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _usernameFocusNode = FocusNode();
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      //Invalid
      return;
    }
    _formKey.currentState!.save();
    context
        .read<AuthCubit>()
        .signUp(email: _email, username: _username, password: _password);
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _usernameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (prevState, currState) {
          if (currState is AuthSignedUp) {
            // Navigator.of(context).pushReplacementNamed(PostsScreen.id);
          }
          if (currState is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                duration: const Duration(seconds: 2),
                content: Text(currState.message),
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
                        child: Text("Начни общаться",
                            style: Theme.of(context).textTheme.displaySmall),
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
                              .requestFocus(_usernameFocusNode);
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
                      //* username
                      TextFormField(
                        focusNode: _usernameFocusNode,
                        decoration: const InputDecoration(
                            //! цвет выделенного бордера
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Введите ваше Имя"),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_passwordFocusNode);
                        },
                        onSaved: (value) {
                          _username = value!.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Пожалуйста введите Имя";
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
                            labelText: "Придумайте пароль"),
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
                          if (value.length < 5) {
                            return "Должно быть минимум пять символов";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 55),
                      TextButton(
                        onPressed: () {
                          _submit(context);
                        },
                        child: const Text(
                          'Зарегестрироваться',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFFBFC6CC),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () {
                          // TODO: - перейти в окно входа
                          Navigator.of(context)
                              .pushReplacementNamed(SignInScreen.id);
                        },
                        child: const Text(
                          'Перейти в окно входа',
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
