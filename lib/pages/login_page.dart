import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/base_bloc.dart';
import '../constants/constant.dart';
import '../constants/image.dart';
import '../dependencies.dart';
import '../models/auth/login_req.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberMe = false;
  bool _isObscured = true;
  final _loginReq = LoginReq();
  late final AuthBloc bloc;
  final _usernameTextController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    bloc = AppDependencies.injector.get<AuthBloc>();
    _scrollController.addListener(
      () {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          FocusScope.of(context).requestFocus(
            FocusNode(),
          );
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(
          FocusNode(),
        ),
        child: BlocConsumer(
          bloc: bloc,
          listener: (context, state) {
            if (state is LoadedState) {
              if (context.canPop()) {
                context.pop();
              }
              if (state.isShowLoading) {
                showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => const SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator.adaptive(),
                  ),
                );
                return;
              }
              if ((state.errorMessage?.isNotEmpty ?? false) &&
                  state.errorMessage != null) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    actions: [
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('OK'),
                      ),
                    ],
                    title: const Text('Error'),
                    content: Text(state.errorMessage ?? ''),
                  ),
                );
                return;
              }
              context.go(AppPath.map);
            }
          },
          builder: (context, state) {
            return ListView(
              // shrinkWrap: true,
              controller: _scrollController,
              padding: const EdgeInsets.only(
                top: 100,
                left: 32,
                right: 32,
              ),
              children: [
                const Text(
                  'H??? TH???NG QUAN TR???C M??I TR?????NG N?????C',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 16,
                    bottom: 16,
                  ),
                  child: Image.asset(
                    AppImage.mainIcon,
                    height: 200,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _usernameTextController,
                  decoration: const InputDecoration(
                    hintText: 'T??n ????ng Nh???p',
                  ),
                  onChanged: (value) => _loginReq.userName = value,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _isObscured,
                  decoration: InputDecoration(
                    hintText: 'M???t Kh???u',
                    suffixIcon: IconButton(
                      onPressed: () => setState(
                        () => _isObscured = !_isObscured,
                      ),
                      icon: Icon(
                        _isObscured ? Icons.visibility : Icons.visibility_off,
                      ),
                    ),
                  ),
                  onChanged: (value) => _loginReq.password = value,
                ),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) {
                        setState(
                          () => _rememberMe = value ?? false,
                        );
                      },
                    ),
                    const Text(
                      'Nh??? th??ng tin ????ng nh???p c???a t??i',
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 42,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    child: const Text(
                      '????NG NH???P',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      bloc.login(
                        loginReq: _loginReq,
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ch??a c?? t??i kho???n? ',
                    ),
                    TextButton(
                      onPressed: () {
                        context.go(AppPath.register);
                      },
                      child: const Text(
                        '????ng k??',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
