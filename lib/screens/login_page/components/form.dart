import 'package:app_medicine/controller/auth_service.dart';
import 'package:app_medicine/screens/login_page/components/login_button.dart';
import 'package:app_medicine/screens/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FormLogin extends StatefulWidget {
  const FormLogin({Key? key}) : super(key: key);

  @override
  State<FormLogin> createState() => _FormLoginState();
}

class _FormLoginState extends State<FormLogin>
    with SingleTickerProviderStateMixin {
  bool isObscure = true;
  late TabController _tabController;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loading = false;

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double heigth = MediaQuery.of(context).size.height / 2.5;
    final AuthService auth = Provider.of<AuthService>(context);

    return Padding(
      padding: const EdgeInsets.all(25),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 35),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: kGreyColor,
              ),
              height: heigth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Login'),
                        Tab(text: 'Cadastrar'),
                        Tab(
                          text: 'Recuperar',
                        )
                      ],
                      indicatorColor: Colors.blue,
                      indicatorSize: TabBarIndicatorSize.values[1],
                      labelColor: Colors.blue,
                      labelStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                      unselectedLabelColor: Colors.white,
                    ),
                  ),
                  _buildTabView(),
                  const SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          ),
          LoginButton(
            icon: !auth.isLoading
                ? const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  )
                : const CircularProgressIndicator(
                    color: Colors.white,
                  ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                _emailController.text = _emailController.text.trim();
                if (_tabController.index == 0) {
                  login();
                } else if (_tabController.index == 2) {
                  forgotPassword();
                } else {
                  registrar();
                }
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildTabView() {
    const kFormPadding = EdgeInsets.only(top: 25);
    return Expanded(
      child: Form(
        key: formKey,
        child: Padding(
          padding: kFormPadding,
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  Column(
                    children: [
                      _buildTextFields(),
                      _buildForgotAndRemerber(),
                    ],
                  ),
                ],
              ),
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  Column(
                    children: [
                      _buildTextFields(),
                    ],
                  ),
                ],
              ),
              ListView(
                padding: EdgeInsets.zero,
                children: [
                  Column(
                    children: [
                      _buildTextField(
                        text: 'E-mail',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        isPassword: false,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildTextFields() {
    return Column(
      children: [
        _buildTextField(
          text: 'E-mail',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          isPassword: false,
        ),
        _buildTextField(
          text: 'Senha',
          controller: _passwordController,
          isPassword: true,
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }

  Row _buildForgotAndRemerber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        InkWell(
          onTap: () {
            _tabController.index = 2;
            setState(() {});
          },
          child: const Text(
            'Esqueceu a senha?',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String text,
    required TextInputType keyboardType,
    required TextEditingController controller,
    required bool isPassword,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20, right: 12, left: 12),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.left,
        keyboardType: keyboardType,
        // ignore: avoid_bool_literals_in_conditional_expressions
        obscureText: isPassword ? isObscure : false,
        cursorColor: Colors.blue,
        validator: isPassword
            ? (value) {
                if (value!.isEmpty) {
                  return 'Informa sua senha!';
                } else if (value.length < 6) {
                  return 'Sua senha deve ter no mínimo 6 caracteres';
                }
                return null;
              }
            : (value) {
                if (value!.isEmpty) {
                  return 'Informe o email corretamente!';
                }
                return null;
              },

        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(
            left: 30,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility : Icons.visibility_off,
                    color: Colors.white,
                  ),
                )
              : null,
          hintText: text,
          hintStyle: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
          errorStyle: const TextStyle(color: Color.fromARGB(255, 255, 66, 66)),
          border: kBorder,
          disabledBorder: kBorder,
          enabledBorder: kBorder,
          focusedBorder: kBorder,
          errorBorder: kBorder.copyWith(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 255, 66, 66),
            ),
          ),
        ),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
      ),
    );
  }

  final kBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(50),
    borderSide: const BorderSide(
      color: Colors.white,
      width: 2,
    ),
  );

  Future login() async {
    setState(() => loading = true);
    try {
      await context
          .read<AuthService>()
          .login(_emailController.text, _passwordController.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future registrar() async {
    setState(() => loading = true);
    try {
      await context
          .read<AuthService>()
          .registrar(_emailController.text, _passwordController.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future forgotPassword() async {
    String? error;
    try {
      await context.read<AuthService>().forgotPassword(_emailController.text);
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
      error = e.message;
    }
    if (error == null) {
      _buildSnackBar();
    }
  }

  void _buildSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Recuperação de senha enviado para: ${_emailController.text}. Verifique seu email!',
        ),
      ),
    );
  }
}
