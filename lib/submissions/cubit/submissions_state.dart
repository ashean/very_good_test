part of 'submissions_cubit.dart';

abstract class SubmissionsState extends Equatable {
  const SubmissionsState();

  @override
  List<Object> get props => [];
}

class SubmissionsInitial extends SubmissionsState {
  const SubmissionsInitial();
}

class SubmissionsLoading extends SubmissionsState {
  const SubmissionsLoading();
}

class SubmissionsLoaded extends SubmissionsState {
  const SubmissionsLoaded(this.submissions);

  final List<Submission> submissions;

  @override
  List<Object> get props => [submissions];
}

class SubmissionsError extends SubmissionsState {
  const SubmissionsError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
