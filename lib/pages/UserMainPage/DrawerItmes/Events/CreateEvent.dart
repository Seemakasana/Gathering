import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gathering/bloc/event/event_bloc.dart';
import 'package:gathering/constants/app_colors.dart';
import 'package:gathering/services/EventRepository.dart';

class CreateEventPage extends StatefulWidget {
  CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  // Controllers
  final TextEditingController _headingController = TextEditingController();

  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _eventDate;

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}-'
        '${dateTime.month.toString().padLeft(2, '0')}-'
        '${dateTime.year}  '
        '${dateTime.hour.toString().padLeft(2, '0')}:'
        '${dateTime.minute.toString().padLeft(2, '0')}';
  }


  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time == null) return;

    setState(() {
      _eventDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EventBloc(EventRepository()),
      child: BlocListener<EventBloc, EventState>(
        listener: (context, state) {
          if (state is EventSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Event created successfully 🎉')),
            );
            Navigator.pop(context);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<EventBloc>().add(RefreshMyEvents());
            });
          }

          if (state is EventFailure) {
            print("event Failure error : ${state.error}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: const Text(
              'Create Event',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(color: AppColors.textPrimary),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                eventImagePicker(context),
                const SizedBox(height: 20),
                eventHeadingField(_headingController),
                const SizedBox(height: 16),
                eventDescriptionField(_descriptionController),
                const SizedBox(height: 20),

                eventDatePicker(
                  onTap: _pickDateTime,
                  selectedDateText:
                  _eventDate == null ? null : _formatDateTime(_eventDate!),
                ),

              ],
            ),
          ),
          bottomNavigationBar: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          return createEventButton(
            isLoading: state is EventLoading,
            onPressed: () {
              if (_headingController.text.isEmpty ||
                  _descriptionController.text.isEmpty ||
                  _eventDate == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
                return;
              }

              context.read<EventBloc>().add(
                SubmitEvent(
                  heading: _headingController.text.trim(),
                  description: _descriptionController.text.trim(),
                  eventDate: _eventDate!,
                ),
              );
            },
          );
        },
        ),

        ),
      ),
    );
  }

  // ---------------- IMAGE PICKER ----------------
  Widget eventImagePicker(BuildContext context) {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        File? image;

        if (state is EventImagePicked) {
          image = state.image;
        }

        return GestureDetector(
          onTap: () =>
              context.read<EventBloc>().add(PickEventImage()),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accent.withOpacity(0.6),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.25),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),

            /// 👇 SHOW IMAGE OR PLACEHOLDER
            child: image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            )
                : const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_a_photo,
                  color: AppColors.accent,
                  size: 40,
                ),
                SizedBox(height: 12),
                Text(
                  'Add Event Image',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  // ---------------- HEADING FIELD ----------------
  Widget eventHeadingField(TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Event Heading',
        hintStyle: const TextStyle(color: AppColors.textLight),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 2,
          ),
        ),
      ),
    );
  }

  // ---------------- DESCRIPTION FIELD ----------------
  Widget eventDescriptionField(TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 4,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: 'Event Description',
        hintStyle: const TextStyle(color: AppColors.textLight),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 2,
          ),
        ),
      ),
    );
  }

  // ---------------- DATE PICKER ----------------
  Widget eventDatePicker({
    required VoidCallback onTap,
    String? selectedDateText,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.textLight.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: AppColors.electricBlue,
            ),
            const SizedBox(width: 12),
            Text(
              selectedDateText ?? 'Pick Event Date & Time',
              style: TextStyle(
                color: selectedDateText == null
                    ? AppColors.textSecondary
                    : AppColors.textPrimary,
                fontSize: 15,
                fontWeight: selectedDateText == null
                    ? FontWeight.normal
                    : FontWeight.w600,
              ),
            ),

          ],
        ),
      ),
    );
  }

  // ---------------- CREATE BUTTON ----------------
  Widget createEventButton({
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: isLoading
              ? const SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Colors.white,
            ),
          )
              : const Text(
            'Create Event',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
