abstract class AdminStates {}

class AdminInitialState extends AdminStates {}

class AdminGetUserLoadingState extends AdminStates {}

class AdminGetUserSuccessState extends AdminStates {}

class AdminGetUserErrorState extends AdminStates
{
  final String error;

  AdminGetUserErrorState(this.error);
}

class AdminGetAllUsersLoadingState extends AdminStates {}

class AdminGetAllUsersSuccessState extends AdminStates {}

class AdminGetAllUsersErrorState extends AdminStates
{
  final String error;

  AdminGetAllUsersErrorState(this.error);
}

class AdminGetPostsLoadingState extends AdminStates {}

class AdminGetPostsSuccessState extends AdminStates {}

class AdminGetPostsErrorState extends AdminStates
{
  final String error;

  AdminGetPostsErrorState(this.error);
}

class AdminLikePostSuccessState extends AdminStates {}

class AdminLikePostErrorState extends AdminStates
{
  final String error;

  AdminLikePostErrorState(this.error);
}

class AdminChangeBottomNavState extends AdminStates {}

class AdminNewPostState extends AdminStates {}

class AdminProfileImagePickedSuccessState extends AdminStates {}

class AdminProfileImagePickedErrorState extends AdminStates {}

class AdminCoverImagePickedSuccessState extends AdminStates {}

class AdminCoverImagePickedErrorState extends AdminStates {}

class AdminUploadProfileImageSuccessState extends AdminStates {}

class AdminUploadProfileImageErrorState extends AdminStates {}

class AdminUploadCoverImageSuccessState extends AdminStates {}

class AdminUploadCoverImageErrorState extends AdminStates {}

class AdminUserUpdateSuccessState extends AdminStates {}

class AdminUserUpdateLoadingState extends AdminStates {}

class AdminUserUpdateErrorState extends AdminStates {}


//Car
class AdminNewCarState extends AdminStates {}

class AdminCarLoadingState extends AdminStates {}

class AdminCarSuccessState extends AdminStates {}

class AdminCarErrorState extends AdminStates {}

class AdminGetCarLoadingState extends AdminStates {}

class AdminGetCarSuccessState extends AdminStates {}

class AdminGetCarErrorState extends AdminStates
{
  final String error;

  AdminGetCarErrorState(this.error);
}
class AdminCarUpdateSuccessState extends AdminStates {}

class AdminCarUpdateLoadingState extends AdminStates {}

class AdminCarUpdateErrorState extends AdminStates {}

// create post

class AdminCreatePostLoadingState extends AdminStates {}

class AdminCreatePostSuccessState extends AdminStates {}

class AdminCreatePostErrorState extends AdminStates {}

class AdminPostImagePickedSuccessState extends AdminStates {}

class AdminPostImagePickedErrorState extends AdminStates {}

class AdminRemovePostImageState extends AdminStates {}

//visit get posts
class AdminGetVisitPostsLoadingState extends AdminStates {}

class AdminGetVisitPostsSuccessState extends AdminStates {}

class AdminGetVisitPostsErrorState extends AdminStates
{
  final String error;

  AdminGetVisitPostsErrorState(this.error);
}

// chat

class AdminSendMessageSuccessState extends AdminStates {}

class AdminSendMessageErrorState extends AdminStates {}

class AdminGetMessagesSuccessState extends AdminStates {}


// Make chat objects
class AdminSenderSuccessState extends AdminStates {}

class AdminReceiverSuccessState extends AdminStates {}

class AdminSenderErrorState extends AdminStates {}

class AdminReceiverErrorState extends AdminStates {}

class AdminGetChatersSuccessState extends AdminStates {}

class AdminGetChatersErrorState extends AdminStates {}

//rate
class AdminRateState extends AdminStates {}

class AdminAddUserState extends AdminStates {}

class AdminGetAllTripsSuccessState extends AdminStates {}

class AdminGetAllTripsErrorState extends AdminStates {
  final String error;

  AdminGetAllTripsErrorState(this.error);
}