//import 'package:conditional_builder/conditional_builder.dart';
import 'package:carpooling/layout/carpooling_app/admin_layout.dart';
import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:carpooling/shared/styles/colors.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carpooling/main.dart';
import '../../../layout/carpooling_app/carpooling_layout.dart';
import '../../../shared/network/local/cache_helper.dart';
import '../carpooling_register/carpooling_register_screen.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class CarpoolingLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CarpoolingLoginCubit(),
      child: BlocConsumer<CarpoolingLoginCubit, CarpoolingLoginStates>(
        listener: (context, state) {
          if (state is CarpoolingLoginErrorState) {
            showToast(
              text: state.error,
              state: ToastStates.ERROR,
            );
          }
          if(state is CarpoolingLoginSuccessState)
          {
            CacheHelper.saveData(
              key: 'uId',
              value: state.uId,
            ).then((value)
            {
              CarpoolingCubit.get(context).prelogin();


                navigateAndFinish(
                context,
                CarpoolingLayout(),);
                showToast(text: "Welcome to Carpooling", state: ToastStates.SUCCESS);


            });

          }
          if(state is CarpoolingAdminLoginState)
            {
              navigateAndFinish(context, AdminLayout());
            }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image(

                          image: AssetImage("images/carlogo.jpg"),
                          width: 350,
                          height: 250,
                          alignment: Alignment.center,
                        ),
                        // Text(
                        //   'LOGIN',
                        //   style: Theme.of(context).textTheme.headline4!.copyWith(
                        //         color: defaultColor,
                        //       ),
                        // ),
                        SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'please enter your email address';
                            }
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: CarpoolingLoginCubit.get(context).suffix,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              // CarpoolingLoginCubit.get(context).userLogin(
                              //   email: emailController.text,
                              //   password: passwordController.text,
                              // );
                            }
                          },
                          isPassword: CarpoolingLoginCubit.get(context).isPassword,
                          suffixPressed: () {
                            CarpoolingLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                          validate: (String value) {
                            if (value.isEmpty) {
                              return 'password is too short';
                            }
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! CarpoolingLoginLoadingState,
                          builder: (context) => defaultButton(
                            function: () {
                              if (formKey.currentState!.validate()) {
                                CarpoolingLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            text: 'login',
                            isUpperCase: true,
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account?',
                              style: TextStyle(color: textColor),
                            ),
                            defaultTextButton(
                              function: () {
                                navigateTo(
                                  context,
                                  CarpoolingRegisterScreen(),
                                );
                              },
                              text: 'register',
                            ),
                          ],
                        ),
                      ],
                    ),
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
