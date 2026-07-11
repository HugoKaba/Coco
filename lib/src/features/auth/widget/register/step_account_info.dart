import 'package:easy_localization/easy_localization.dart';
import 'package:coco/src/core/theme/app_spacing.dart';
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
          InputLabel(label: tr('register.firstname')),
          DarkTextField(
            controller: firstNameController,
            hintText: tr('register.firstname'),
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: tr('register.name')),
          DarkTextField(
            controller: nameController,
            hintText: tr('register.name'),
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: tr('register.username')),
          DarkTextField(
            controller: userNameController,
            hintText: tr('register.username'),
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: tr('register.email')),
          DarkTextField(
            controller: emailController,
            hintText: tr('register.email'),
            keyboardType: TextInputType.emailAddress,
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
          const SizedBox(height: AppSpacing.xl),
          InputLabel(label: tr('register.password')),
          DarkTextField(
            controller: passwordController,
            hintText: tr('register.password'),
            obscureText: true,
            fieldColor: fieldColor,
            innerShadow: innerShadow,
          ),
        ],
      ),
    );
  }
}
