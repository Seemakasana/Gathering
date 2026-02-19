part of 'event_bloc.dart';


abstract class EventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class PickEventImage extends EventEvent {}

class SubmitEvent extends EventEvent {
  final String heading;
  final String description;
  final DateTime eventDate;

  SubmitEvent({
    required this.heading,
    required this.description,
    required this.eventDate,
  });

  @override
  List<Object?> get props => [heading, description, eventDate];
}

class LoadMyEvents extends EventEvent {}

class RefreshMyEvents extends EventEvent {}

