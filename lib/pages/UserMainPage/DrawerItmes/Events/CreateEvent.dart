import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gathering/bloc/event/event_bloc.dart';
import 'package:gathering/constants/app_colors.dart';
import 'package:gathering/services/EventRepository.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {

  // ---------------- BASIC CONTROLLERS ----------------
  final _headingController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _formLinkController = TextEditingController();
  int _participantLimit = 1;

  final TextEditingController _participantLimitController =
  TextEditingController(text: "1");

  final FixedExtentScrollController _wheelController =
  FixedExtentScrollController(initialItem: 0);

  DateTime? _eventDate;

  // ---------------- EXTRA STATES ----------------
  bool _isAddressPublic = true;

  String _registrationType = "none"; // none | form | group | both
  bool _createGroup = false;
  bool _isGroupPublic = true;

  String _selectedGender = "any"; // any | male | female

  bool _isLimited = false;

  double? _latitude;
  double? _longitude;

  // ---------------- FORMAT DATE ----------------
  String _formatDateTime(DateTime dateTime) {
    return "${dateTime.day.toString().padLeft(2, '0')}-"
        "${dateTime.month.toString().padLeft(2, '0')}-"
        "${dateTime.year}  "
        "${dateTime.hour.toString().padLeft(2, '0')}:"
        "${dateTime.minute.toString().padLeft(2, '0')}";
  }

  // ---------------- PICK DATE TIME ----------------
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent, // header & selected date
              onPrimary: AppColors.surface,
                surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.accent,
          ),
          child: child!,
        );
      },
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.input, // 👈 keyboard mode
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppColors.accent, // clock & header
              secondary: AppColors.accent,// clock color
              onPrimary: AppColors.surface,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
            dialogBackgroundColor: AppColors.accent,
          ),
          child: child!,
        );
      },
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

  // ---------------- BUILD ----------------
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
          }
          if (state is EventFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            title: const Text("Create Event",
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold)),
            iconTheme:
            const IconThemeData(color: AppColors.textPrimary),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                eventImagePicker(),
                const SizedBox(height: 20),

                buildTextField(_headingController, "Event Heading"),
                const SizedBox(height: 16),

                buildTextField(_descriptionController, "Event Description",
                    maxLines: 4),
                const SizedBox(height: 20),

                eventDatePicker(),
                const SizedBox(height: 20),

                addressSection(),
                const SizedBox(height: 20),

                registrationSection(),
                const SizedBox(height: 20),

                genderSection(),
                const SizedBox(height: 20),

                participantLimitSection(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          bottomNavigationBar:
          BlocBuilder<EventBloc, EventState>(
            builder: (context, state) {
              return createEventButton(
                isLoading: state is EventLoading,
                onPressed: _submitEvent,
              );
            },
          ),
        ),
      ),
    );
  }

  // ---------------- SUBMIT ----------------
  void _submitEvent() {
    if (_headingController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _eventDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please fill required fields")));
      return;
    }

    context.read<EventBloc>().add(
      SubmitEvent(
        heading: _headingController.text.trim(),
        description: _descriptionController.text.trim(),
        eventDate: _eventDate!,
        // address: _addressController.text.trim(),
        // latitude: _latitude,
        // longitude: _longitude,
        // isAddressPublic: _isAddressPublic,
        // registrationType: _registrationType,
        // formLink: _formLinkController.text.trim(),
        // createGroup: _createGroup,
        // isGroupPublic: _isGroupPublic,
        // participantGender: _selectedGender,
        // isLimited: _isLimited,
        // participantLimit:
        // _isLimited ? _participantLimit : null,
      ),
    );
  }

  // ---------------- COMMON TEXT FIELD ----------------
  Widget buildTextField(TextEditingController controller,
      String hint,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(
        color: AppColors.textPrimary
      ),
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.surface,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.accent, // color when focused
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ---------------- IMAGE PICKER ----------------
  Widget eventImagePicker() {
    return BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        File? image;
        if (state is EventImagePicked) image = state.image;

        return GestureDetector(
          onTap: () =>
              context.read<EventBloc>().add(PickEventImage()),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(
                color: AppColors.textLightDark,   // Border color
                width: 1,            // Border width
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: image != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(image, fit: BoxFit.fill),
            )
                : const Center(
              child: Icon(Icons.add_a_photo,
                  size: 40,
                  color: AppColors.accent),
            ),
          ),
        );
      },
    );
  }

  // ---------------- DATE PICKER ----------------
  Widget eventDatePicker() {
    return GestureDetector(
      onTap: _pickDateTime,
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.textLightDark,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month,
                color: AppColors.electricBlue),
            const SizedBox(width: 12),
            Text(
              _eventDate == null
                  ? "Pick Event Date & Time"
                  : _formatDateTime(_eventDate!),
              style: TextStyle(
                color: _eventDate == null ?AppColors.textLight: AppColors.textPrimary
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- ADDRESS ----------------
  Widget addressSection() {
    return Column(
      children: [
        buildTextField(_addressController, "Event Address"),
        SwitchListTile(
          value: _isAddressPublic,
          activeColor: AppColors.accentLight,
          title:  Text("Make Address Public",
            style: TextStyle(
                color: AppColors.textLight
            ),),
          onChanged: (val) =>
              setState(() => _isAddressPublic = val),
        ),
      ],
    );
  }

  // ---------------- REGISTRATION ----------------
  Widget registrationSection() {
    return Column(
      children: [
        DropdownButtonFormField<String>(
          value: _registrationType,
          items:  [
            DropdownMenuItem(
                value: "none",
                child: Text(
                    "No Registration",
                style: TextStyle(
                  color: AppColors.textLight
                ),)),
            DropdownMenuItem(
                value: "form",
                child: Text(
                    "Form Only",
                    style: TextStyle(
                        color: AppColors.textLight
                    ))),
            DropdownMenuItem(
                value: "group",
                child: Text(
                    "Group Only",
                    style: TextStyle(
                        color: AppColors.textLight
                    ))),
            DropdownMenuItem(
                value: "both",
                child: Text(
                    "Form + Group",
                    style: TextStyle(
                        color: AppColors.textLight
                    )
                )),
          ],
          onChanged: (val) =>
              setState(() => _registrationType = val!),
          decoration:
          const InputDecoration(labelText: "Registration Type"),
        ),
         (_registrationType == "form" )
         ? Container(
            margin: EdgeInsets.symmetric(vertical: 10),
              child: buildTextField(_formLinkController, "Enter Form Link"))
        : (_registrationType == "group" )
    ? groupSection()
        :(_registrationType == "both" )
    ? Column(
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: buildTextField(_formLinkController, "Enter Form Link")),
        const SizedBox(height: 20),
        groupSection(),
      ],
    ):Container(),
    const SizedBox(height: 20),


      ],
    );
  }

  // ---------------- GROUP ----------------
  Widget groupSection() {
    return Column(
      children: [
        SwitchListTile(
          activeColor: AppColors.accentLight,
          title:  Text("Create Event Group",
              style: TextStyle(
                  color: AppColors.textLight
              )),
          value: _createGroup,
          onChanged: (val) =>
              setState(() => _createGroup = val),
        ),
        if (_createGroup)
          SwitchListTile(
        activeColor: AppColors.accentLight,
            title:  Text("Group Public",
                style: TextStyle(
                    color: AppColors.textLight
                )),
            value: _isGroupPublic,
            onChanged: (val) =>
                setState(() => _isGroupPublic = val),
          ),
      ],
    );
  }

  // ---------------- GENDER ----------------
  Widget genderSection() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      items: const [
        DropdownMenuItem(
            value: "any", child: Text(
            "Any",
            style: TextStyle(
                color: AppColors.textLight
            )
        )),
        DropdownMenuItem(
            value: "male",
            child: Text(
                "Male Only",
                style: TextStyle(
                    color: AppColors.textLight
                ))),
        DropdownMenuItem(
            value: "female",
            child: Text(
                "Female Only",
                style: TextStyle(
                    color: AppColors.textLight
                ))),
      ],
      onChanged: (val) =>
          setState(() => _selectedGender = val!),
      decoration:
      const InputDecoration(labelText: "Participant Gender"),
    );
  }

  // ---------------- PARTICIPANT LIMIT ----------------
  Widget participantLimitSection() {
    return Column(
      children: [
        SwitchListTile(
    activeColor: AppColors.accentLight,
          title:  Text("Limit Participants",
              style: TextStyle(
                  color: AppColors.textLight
              )),
          value: _isLimited,
          onChanged: (val) =>
              setState(() => _isLimited = val),
        ),
        if (_isLimited)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  "Participants Count",
                  style: TextStyle(color: AppColors.textLight),
                ),
              ),

              SizedBox(
                height: 150,
                width: 120,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    /// Wheel Picker
                    ListWheelScrollView.useDelegate(
                      controller: _wheelController,
                      itemExtent: 40,
                      physics: const FixedExtentScrollPhysics(),
                      onSelectedItemChanged: (index) {
                        setState(() {
                          _participantLimit = index + 1;
                          _participantLimitController.text =
                              _participantLimit.toString();
                        });
                      },
                      childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context, index) {
                          return Center(
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(
                                fontSize: 18,
                                color: AppColors.textLight,
                              ),
                            ),
                          );
                        },
                        childCount: 10000,
                      ),
                    ),

                    /// Center Editable Field
                    Container(
                      height: 40,
                      width: 70,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // color: Colors.white,
                        // border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: TextField(
                        controller: _participantLimitController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: AppColors.textPrimary
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        onChanged: (value) {
                          int? number = int.tryParse(value);

                          if (number != null && number > 0 && number <= 10000) {
                            _wheelController.animateToItem(
                              number - 1,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.ease,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              )
            ],
          )
      ],
    );
  }

  // ---------------- BUTTON ----------------
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
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: isLoading
              ?  CircularProgressIndicator(color: AppColors.accent,)
              :  Text("Create Event",
            style: TextStyle(color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}