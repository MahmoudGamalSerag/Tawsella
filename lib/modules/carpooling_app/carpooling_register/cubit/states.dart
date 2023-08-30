abstract class CarpoolingRegisterStates {}

class CarpoolingRegisterInitialState extends CarpoolingRegisterStates {}

class CarpoolingRegisterLoadingState extends CarpoolingRegisterStates {}

class CarpoolingRegisterSuccessState extends CarpoolingRegisterStates {}

class CarpoolingRegisterErrorState extends CarpoolingRegisterStates
{
  final String error;

  CarpoolingRegisterErrorState(this.error);
}

class CarpoolingCreateUserSuccessState extends CarpoolingRegisterStates {}

class CarpoolingCreateUserErrorState extends CarpoolingRegisterStates
{
  final String error;

  CarpoolingCreateUserErrorState(this.error);
}

class CarpoolingRegisterChangePasswordVisibilityState extends CarpoolingRegisterStates {}
