import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frakton_task/Screens/HomeScreen/home_screen.dart';
import 'package:frakton_task/models/user_model.dart';

import '../../Constants/constants.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  //firebase
  final auth = FirebaseAuth.instance;

  //Form Key
  final formKey = GlobalKey<FormState>();

  //editing controllers
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  //variable
  bool _isHidden = true;
  bool isHidden2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_sharp,
            color: Colors.redAccent,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(Constants.padding),
              child: registrationForm(),
            ),
          ),
        ),
      ),
    );
  }

  Widget registrationForm() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 130,
            child: Image.asset("assets/images/tranparent_logo.png"),
          ),
          const SizedBox(
            height: 20,
          ),
          firstNameField(),
          const SizedBox(
            height: 20,
          ),
          secondNameField(),
          const SizedBox(
            height: 20,
          ),
          emailField(),
          const SizedBox(
            height: 20,
          ),
          passwordField(),
          const SizedBox(
            height: 20,
          ),
          passwordConfirmationField(),
          const SizedBox(
            height: 25,
          ),
          registrationButton(),
        ],
      ),
    );
  }

  Widget firstNameField() {
    return TextFormField(
      autofocus: false,
      controller: firstnameController,
      keyboardType: TextInputType.name,
      autofillHints: const [AutofillHints.name],
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'First name cannot be empty';
        }
        return null;
      },
      onSaved: (value) {
        firstnameController.text = value!;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.all(Constants.padding),
        hintText: "First Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.radius),
        ),
      ),
    );
  }

  Widget secondNameField() {
    return TextFormField(
      autofocus: false,
      controller: lastnameController,
      keyboardType: TextInputType.name,
      autofillHints: const [AutofillHints.name],
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Last name cannot be empty';
        }
        return null;
      },
      onSaved: (value) {
        lastnameController.text = value!;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person),
        contentPadding: const EdgeInsets.all(Constants.padding),
        hintText: "Last Name",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.radius),
        ),
      ),
    );
  }

  Widget emailField() {
    return TextFormField(
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
    );
  }

  Widget passwordField() {
    return TextFormField(
      autofocus: false,
      controller: passwordController,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.next,
      obscureText: _isHidden,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Password is required to SignUp';
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
    );
  }

  Widget passwordConfirmationField() {
    return TextFormField(
      autofocus: false,
      controller: confirmPasswordController,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      obscureText: _isHidden,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Confirm Password is required to SignUp';
        }
        if (confirmPasswordController.text != passwordController.text) {
          return 'Password don\'t match';
        }
        return null;
      },
      onSaved: (value) {
        passwordController.text = value!;
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: GestureDetector(
          onTap: _togglePasswordView2,
          child: Icon(
            isHidden2 ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
        contentPadding: const EdgeInsets.all(Constants.padding),
        hintText: "Confirm Password",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Constants.radius),
        ),
      ),
    );
  }

  Widget registrationButton() {
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
            signUp(
              emailController.text,
              passwordController.text,
            );
          },
          child: const Center(
            child: Text("Sign Up"),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (formKey.currentState!.validate()) {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {
                postDataToFirebase(),
              })
          .catchError((e) {
        showToast(e!.message);
      });
    }
  }

  postDataToFirebase() async {
    //calling firestore
    //calling user model
    // sending values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = auth.currentUser;

    UserModel userModel = UserModel();

    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.firstName = firstnameController.text;
    userModel.lastName = lastnameController.text;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toMap());

    showToast("Account created successfuly");

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
        (route) => false);
  }

  void showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
  }

  void _togglePasswordView() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  void _togglePasswordView2() {
    setState(() {
      isHidden2 = !isHidden2;
    });
  }
}
