import 'package:equatable/equatable.dart';

import 'package:my_app/drift_test/drift_database.dart';

abstract class UserProfileState extends Equatable {
  const UserProfileState();

  @override
  List<Object?> get props => [];
}

class UserProfileInitial extends UserProfileState {
  const UserProfileInitial();
}

class UserProfileLoading extends UserProfileState {
  const UserProfileLoading();
}

class UserProfileFormSuccess extends UserProfileState {
  const UserProfileFormSuccess();
}

class UserProfileFormError extends UserProfileState {
  const UserProfileFormError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class UserProfileListLoaded extends UserProfileState {
  const UserProfileListLoaded(this.profiles);

  final List<UserProfile> profiles;

  @override
  List<Object?> get props => [profiles];
}

class UserProfileListError extends UserProfileState {
  const UserProfileListError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
