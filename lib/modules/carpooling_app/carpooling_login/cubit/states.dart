abstract class CarpoolingLoginStates {}

class CarpoolingLoginInitialState extends CarpoolingLoginStates {}

class CarpoolingLoginLoadingState extends CarpoolingLoginStates {}

class CarpoolingLoginSuccessState extends CarpoolingLoginStates
{
  final String uId;

  CarpoolingLoginSuccessState(this.uId);
}

class CarpoolingLoginErrorState extends CarpoolingLoginStates
{
  final String error;

  CarpoolingLoginErrorState(this.error);
}

class CarpoolingChangePasswordVisibilityState extends CarpoolingLoginStates {}

class CarpoolingAdminLoginState extends CarpoolingLoginStates {}
