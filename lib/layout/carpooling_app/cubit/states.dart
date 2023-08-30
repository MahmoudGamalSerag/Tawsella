abstract class CarpoolingStates {}

class CarpoolingInitialState extends CarpoolingStates {}

class CarpoolingGetUserLoadingState extends CarpoolingStates {}

class CarpoolingGetUserSuccessState extends CarpoolingStates {}

class CarpoolingGetUserErrorState extends CarpoolingStates
{
  final String error;

  CarpoolingGetUserErrorState(this.error);
}

class CarpoolingGetAllUsersLoadingState extends CarpoolingStates {}

class CarpoolingGetAllUsersSuccessState extends CarpoolingStates {}

class CarpoolingGetAllUsersErrorState extends CarpoolingStates
{
  final String error;

  CarpoolingGetAllUsersErrorState(this.error);
}

class CarpoolingGetPostsLoadingState extends CarpoolingStates {}

class CarpoolingGetPostsSuccessState extends CarpoolingStates {}

class CarpoolingGetPostsErrorState extends CarpoolingStates
{
  final String error;

  CarpoolingGetPostsErrorState(this.error);
}

class CarpoolingLikePostSuccessState extends CarpoolingStates {}

class CarpoolingLikePostErrorState extends CarpoolingStates
{
  final String error;

  CarpoolingLikePostErrorState(this.error);
}

class CarpoolingChangeBottomNavState extends CarpoolingStates {}

class CarpoolingNewPostState extends CarpoolingStates {}

class CarpoolingProfileImagePickedSuccessState extends CarpoolingStates {}

class CarpoolingProfileImagePickedErrorState extends CarpoolingStates {}

class CarpoolingCoverImagePickedSuccessState extends CarpoolingStates {}

class CarpoolingCoverImagePickedErrorState extends CarpoolingStates {}

class CarpoolingUploadProfileImageSuccessState extends CarpoolingStates {}

class CarpoolingUploadProfileImageErrorState extends CarpoolingStates {}

class CarpoolingUploadCoverImageSuccessState extends CarpoolingStates {}

class CarpoolingUploadCoverImageErrorState extends CarpoolingStates {}

class CarpoolingUserUpdateSuccessState extends CarpoolingStates {}

class CarpoolingUserUpdateLoadingState extends CarpoolingStates {}

class CarpoolingUserUpdateErrorState extends CarpoolingStates {}


//Car
class CarpoolingNewCarState extends CarpoolingStates {}

class CarpoolingCarLoadingState extends CarpoolingStates {}

class CarpoolingCarSuccessState extends CarpoolingStates {}

class CarpoolingCarErrorState extends CarpoolingStates {}

class CarpoolingGetCarLoadingState extends CarpoolingStates {}

class CarpoolingGetCarSuccessState extends CarpoolingStates {}

class CarpoolingGetCarErrorState extends CarpoolingStates
{
  final String error;

  CarpoolingGetCarErrorState(this.error);
}
class CarpoolingCarUpdateSuccessState extends CarpoolingStates {}

class CarpoolingCarUpdateLoadingState extends CarpoolingStates {}

class CarpoolingCarUpdateErrorState extends CarpoolingStates {}

// create post

class CarpoolingCreatePostLoadingState extends CarpoolingStates {}

class CarpoolingCreatePostSuccessState extends CarpoolingStates {}

class CarpoolingCreatePostErrorState extends CarpoolingStates {}

class CarpoolingPostImagePickedSuccessState extends CarpoolingStates {}

class CarpoolingPostImagePickedErrorState extends CarpoolingStates {}

class CarpoolingRemovePostImageState extends CarpoolingStates {}

//visit get posts
class CarpoolingGetVisitPostsLoadingState extends CarpoolingStates {}

class CarpoolingGetVisitPostsSuccessState extends CarpoolingStates {}

class CarpoolingGetVisitPostsErrorState extends CarpoolingStates
{
  final String error;

  CarpoolingGetVisitPostsErrorState(this.error);
}

// chat

class CarpoolingSendMessageSuccessState extends CarpoolingStates {}

class CarpoolingSendMessageErrorState extends CarpoolingStates {}

class CarpoolingGetMessagesSuccessState extends CarpoolingStates {}


// Make chat objects
class CarpoolingSenderSuccessState extends CarpoolingStates {}

class CarpoolingReceiverSuccessState extends CarpoolingStates {}

class CarpoolingSenderErrorState extends CarpoolingStates {}

class CarpoolingReceiverErrorState extends CarpoolingStates {}

class CarpoolingGetChatersSuccessState extends CarpoolingStates {}

class CarpoolingGetChatersErrorState extends CarpoolingStates {}

//rate
class CarpoolingRateState extends CarpoolingStates {}

class CarpoolingPreLoginSuccessState extends CarpoolingStates {}

//Trip

class CarpoolingViewTripState extends CarpoolingStates {}

class CarpoolingMakeTripSuccessStateState extends CarpoolingStates {}

class CarpoolingMakeTripErrorStateState extends CarpoolingStates {}

class CarpoolingGetTripsSuccessState extends CarpoolingStates {}

class CarpoolingGetTripsErrorState extends CarpoolingStates {}

class CarpoolingTripUpdateSuccessState extends CarpoolingStates {}

class CarpoolingTripUpdateErrorState extends CarpoolingStates {}


//Request
class CarpoolingSendRequestSuccessState extends CarpoolingStates {}

class CarpoolingSendRequestErrorState extends CarpoolingStates {}

class CarpoolingGetRequestsSuccessState extends CarpoolingStates {}

class CarpoolingRejectSuccessState extends CarpoolingStates {}

class CarpoolingRejectErrorState extends CarpoolingStates {}

class CarpoolingRequestSeenSuccessState extends CarpoolingStates {}

class CarpoolingRequestSeenErrorState extends CarpoolingStates {}

class CarpoolingChangeBottomSheetState extends CarpoolingStates {}