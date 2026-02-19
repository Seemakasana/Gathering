import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gathering/services/EventRepository.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventRepository repo;
  final ImagePicker picker = ImagePicker();

  File? selectedImage;
  late final RealtimeChannel channel;

  EventBloc(this.repo) : super(EventInitial()) {
    // create event flow
    on<PickEventImage>(_pickImage);
    on<SubmitEvent>(_submitEvent);

    // list flow
    on<LoadMyEvents>(_loadEvents);
    on<RefreshMyEvents>(_loadEvents);

    // 🔥 realtime auto-refresh
    channel = repo.supabase
        .channel('events_changes')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'Events',
      callback: (_) {
        add(RefreshMyEvents());
      },
    )
        .subscribe();
  }

  // ---------------- IMAGE PICK ----------------
  Future<void> _pickImage(
      PickEventImage event,
      Emitter<EventState> emit,
      ) async {
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      emit(EventImagePicked(selectedImage!));
    }
  }

  // ---------------- SUBMIT EVENT ----------------
  Future<void> _submitEvent(
      SubmitEvent event,
      Emitter<EventState> emit,
      ) async {
    try {
      emit(EventLoading());

      await repo.createEvent(
        heading: event.heading,
        description: event.description,
        eventDate: event.eventDate,
        image: selectedImage,
      );

      emit(EventSuccess());

      // 🔄 refresh list after successful creation
      add(RefreshMyEvents());
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  // ---------------- LOAD EVENTS LIST ----------------
  Future<void> _loadEvents(
      EventEvent event,
      Emitter<EventState> emit,
      ) async {
    try {
      emit(EventLoading());

      final userId = repo.supabase.auth.currentUser!.id;
      final events = await repo.fetchMyEvents(userId);

      emit(EventsLoaded(events));
    } catch (e) {
      emit(EventFailure(e.toString()));
    }
  }

  // ---------------- CLEANUP ----------------
  @override
  Future<void> close() {
    repo.supabase.removeChannel(channel);
    return super.close();
  }
}