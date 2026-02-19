import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventRepository {
  final supabase = Supabase.instance.client;

  Future<void> createEvent({
    required String heading,
    required String description,
    required DateTime eventDate,
    File? image,
  }) async
  {
    final user = supabase.auth.currentUser!;
    String? imageUrl;

    if (image != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';

      await supabase.storage.from('images').upload(
        fileName,
        image,
        fileOptions: const FileOptions(upsert: true),
      );

      imageUrl =
          supabase.storage.from('images').getPublicUrl(fileName);
    }
    DateTime now = DateTime.now();

    await supabase.from('Events').insert({
      'Heading': heading,
      'Description': description,
      'EventImage': imageUrl,
      'Host': user.id,
      'EventDate': eventDate.toUtc().toIso8601String(),
      'created_at': now.toString(),
    });
  }


  Future<List<Map<String, dynamic>>> fetchMyEvents(String userId) async {
    final response = await supabase
        .from('Events')
        .select('''
      EventID,
      EventImage,
      Heading,
      EventDate,
      created_at,
      updated_at,
      Host,
      cohost,
      host_user:users (
        name
      )
    ''')
        .or(
      'Host.eq.$userId,cohost.cs.{$userId}',
    )
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> fetchEventById(String eventId) async {
    // 1. Fetch event + host
    final event = await supabase
        .from('Events')
        .select('''
        EventID,
        Heading,
        Description,
        EventImage,
        EventDate,
        Host,
        cohost,
        host_user:users (
          id,
          name
        )
      ''')
        .eq('EventID', eventId)
        .single();

    // 2. Fetch cohost users (from uuid[])
    final List cohostIds = event['cohost'] ?? [];

    if (cohostIds.isNotEmpty) {
      final cohostUsers = await supabase
          .from('users')
          .select('id, name')
          .filter('id', 'in', cohostIds);

      event['cohost_users'] = cohostUsers;
    } else {
      event['cohost_users'] = [];
    }

    return event;
  }

}
