import 'package:flutter/material.dart';
import '../dark_text_field.dart';
import '../input_label.dart';

class StepAccountInfo extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameController;
  final TextEditingController nameController;
  final TextEditingController userNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final Color accentColor;
  final Color fieldColor;
  final Color innerShadow;

  const StepAccountInfo({
    super.key,
    required this.formKey,
    required this.firstNameController,
    required this.nameController,
    required this.userNameController,
    required this.emailController,
    required this.passwordController,
    required this.accentColor,
    required this.fieldColor,
    required this.innerShadow,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          const SizedBox(height: 36),
          InputLabel(label: "Prénom"),
          DarkTextField(
            controller: firstNameController,
            hintText: "Firstname",
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
          const SizedBox(height: 20),
          InputLabel(label: "Nom"),
          DarkTextField(
            controller: nameController,
            hintText: "Name",
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
          const SizedBox(height: 20),
          InputLabel(label: "Nom d'utilisateur"),
          DarkTextField(
            controller: userNameController,
            hintText: "Username",
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
          const SizedBox(height: 20),
          InputLabel(label: "Email"),
          DarkTextField(
            controller: emailController,
            hintText: "Email",
            keyboardType: TextInputType.emailAddress,
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
          const SizedBox(height: 20),
          InputLabel(label: "Password"),
          DarkTextField(
            controller: passwordController,
            hintText: "Password",
            obscureText: true,
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
        ],
      ),
    );
  }
}
