part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventImagePicked extends EventState {
  final File image;
  EventImagePicked(this.image);

  @override
  List<Object?> get props => [image];
}

class EventSuccess extends EventState {}

class EventsLoaded extends EventState {
  final List<Map<String, dynamic>> events;

  EventsLoaded(this.events);

  @override
  List<Object?> get props => [events];
}

class EventFailure extends EventState {
  final String error;
  EventFailure(this.error);

  @override
  List<Object?> get props => [error];
}
