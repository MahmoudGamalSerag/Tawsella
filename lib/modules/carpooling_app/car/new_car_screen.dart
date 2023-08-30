//import 'package:conditional_builder/conditional_builder.dart';
import 'package:carpooling/layout/carpooling_app/cubit/cubit.dart';
import 'package:carpooling/layout/carpooling_app/cubit/states.dart';
import 'package:carpooling/shared/components/components.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewCarScreen extends StatelessWidget {
  var modelController = TextEditingController();
  var licenseController = TextEditingController();
  var userlicenseController = TextEditingController();
  var brandController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CarpoolingCubit, CarpoolingStates>(
      listener: (context, state) {
        if (state is CarpoolingCarSuccessState) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: defaultAppBar(
              context: context,
              title: 'Add Car',
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (state is CarpoolingCarLoadingState)
                    LinearProgressIndicator(),
                    SizedBox(
                      height: 10.0,
                    ),
                  Container(
                    height: 230.0,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Align(
                          child: Stack(
                            alignment: AlignmentDirectional.topEnd,
                            children: [
                              Image(

                                image: AssetImage("images/carlogo.jpg"),
                                width: 350,
                                height: 250,
                                alignment: Alignment.center,
                              ),
                            ],
                          ),
                          alignment: AlignmentDirectional.topCenter,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Add your car details for your and other users safety....',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  defaultFormField(
                    controller: userlicenseController,
                    type: TextInputType.text,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'please enter your license';
                      }
                    },
                    label: 'User License',
                    prefix: Icons.person,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  defaultFormField(
                    controller: modelController,
                    type: TextInputType.text,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'please enter car model';
                      }
                    },
                    label: 'Car Model',
                    prefix: Icons.calendar_month,
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  defaultFormField(
                    controller: licenseController,
                    type: TextInputType.text,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'please enter your car license';
                      }
                    },
                    label: 'Car License',
                    prefix: Icons.card_membership,
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  defaultFormField(
                    controller: brandController,
                    type: TextInputType.text,
                    validate: (String value) {
                      if (value.isEmpty) {
                        return 'please enter your car brand';
                      }
                    },
                    label: 'Brand',
                    prefix: Icons.car_crash_outlined,
                  ),
                  SizedBox(height: 30.0,),
                  defaultTextButton(
                    function: () {
                      if(modelController.text.length==0)
                        {
                          showToast(text: "please enter car model", state: ToastStates.ERROR);
                        }
                      else if(licenseController.text.length==0)
                      {
                        showToast(text: "please enter Car license", state: ToastStates.ERROR);
                      }
                      else if(userlicenseController.text.length==0)
                      {
                        showToast(text: "please enter your license", state: ToastStates.ERROR);
                      }
                      else if(brandController.text.length==0)
                      {
                        showToast(text: "please enter car brand", state: ToastStates.ERROR);
                      }
                      else
                        {
                          CarpoolingCubit.get(context).createCar
                            (model: modelController.text,
                              brand: brandController.text,
                              license: licenseController.text,
                              userlicense: userlicenseController.text
                          );
                        }
                        },
                    text: 'Submit',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
