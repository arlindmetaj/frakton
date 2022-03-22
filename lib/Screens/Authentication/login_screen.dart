import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frakton_task/Constants/constants.dart';
import 'package:frakton_task/Screens/Authentication/registration_screen.dart';
import 'package:frakton_task/Screens/HomeScreen/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //form
  final formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  //variable
  bool _isHidden = true;

  //firebase
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: loginForm(),
          ),
        ),
      ),
    );
  }

  Widget loginForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(
            height: 150,
            child: Image.asset("assets/images/tranparent_logo.png"),
          ),
          const SizedBox(
            height: 40,
          ),
          usernameField(),
          passwordField(),
          const SizedBox(
            height: 40,
          ),
          loginButton(),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RegistrationScreen(),
                    ),
                  );
                },
                child: const Text(
                  "SignUp",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget usernameField() {
    return Padding(
      padding: const EdgeInsets.all(Constants.padding),
      child: TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        autofillHints: const [AutofillHints.email],
        textInputAction: TextInputAction.next,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your email';
          }
          if (!RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(value)) {
            return 'Please enter e valid email';
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.email),
          contentPadding: const EdgeInsets.all(Constants.padding),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.radius),
          ),
        ),
      ),
    );
  }

  Widget passwordField() {
    return Padding(
      padding: const EdgeInsets.only(
          left: Constants.padding, right: Constants.padding),
      child: TextFormField(
        autofocus: false,
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: TextInputAction.done,
        obscureText: _isHidden,
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please is required to login';
          }
          return null;
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: GestureDetector(
            onTap: _togglePasswordView,
            child: Icon(
              _isHidden ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey,
            ),
          ),
          contentPadding: const EdgeInsets.all(Constants.padding),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constants.radius),
          ),
        ),
      ),
    );
  }

  Widget loginButton() {
    return SizedBox(
      height: 45,
      child: Padding(
        padding: const EdgeInsets.only(
            left: Constants.padding, right: Constants.padding),
        child: ElevatedButton(
          style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Constants.radius),
              ))),
          onPressed: () {
            signIn(
              emailController.text,
              passwordController.text,
            );
          },
          child: const Center(
            child: Text("LOGIN"),
          ),
        ),
      ),
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void signIn(String email, String password) async {
    if (formKey.currentState!.validate()) {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
            (uid) => {
              showToast("Login Successful"),
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              ),
            },
          )
          .catchError((e) {
        showToast(e.message);
      });
    }
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }
}
