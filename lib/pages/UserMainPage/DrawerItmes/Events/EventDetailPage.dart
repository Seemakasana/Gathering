import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gathering/constants/app_colors.dart';
import 'package:gathering/services/EventRepository.dart';
import 'package:gathering/widgets/DateFormate.dart';

class EventDetailsPage extends StatefulWidget {
  final String eventId;
  const EventDetailsPage({required this.eventId, super.key});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final _repo = EventRepository();

  late Future<Map<String, dynamic>> _eventFuture;

  @override
  void initState() {
    super.initState();
    _eventFuture = _repo.fetchEventById(widget.eventId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Details')),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          return _EventDetailsView(event: snapshot.data!);
        },
      ),
    );
  }
}

class _EventDetailsView extends StatelessWidget {
  final Map<String, dynamic> event;

  const _EventDetailsView({required this.event});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final host = event['host_user'];
    final String hostName = host?['name'] ?? 'User';

    final List<String> cohostNames =
    (event['cohost_users'] as List)
        .map((u) => u['name'] as String)
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            event['Heading'] ?? '',
            style:  TextStyle(
              color: AppColors.accentLight,
              fontSize: screenSize.height/40,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.date_range_outlined,
                    size: screenSize.height/ 45,
                    color: AppColors.textSecondaryDark,
                  ),
                  Text(
                    customFormat.formatEventDate(event['EventDate']),
                    style: TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: screenSize.height/65,
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(
                    Icons.watch_later_outlined,
                    size: screenSize.height/ 45,
                    color: AppColors.textSecondaryDark,
                  ),
                  Text(
                    customFormat.formatEventTime(event['EventDate']),
                    style: TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: screenSize.height/65,
                    ),
                  )
                ],
              )
            ],
          ),

          Container(
            alignment: Alignment.center,
            height: screenSize.height * 0.2,
            margin: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.04,
              vertical: screenSize.height * 0.012,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(screenSize.width * 0.045),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(screenSize.width * 0.045),
              child: Image.network(
                event['EventImage'],
                width: screenSize.height/5*3,
                height: screenSize.height/5*3,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // Host
          // Row(
          //   children: [
          //     userAvatar(name: hostName, radius: 24),
          //     const SizedBox(width: 8),
          //     Text(hostName),
          //   ],
          // ),
          //
          // const SizedBox(height: 16),
          //
          // // Cohosts
          // Visibility(
          //   visible: cohostNames.isNotEmpty,
          //   child: SizedBox(
          //     height: 48,
          //     child: Stack(
          //       children: List.generate(cohostNames.length, (index) {
          //         return Positioned(
          //           left: index * 28,
          //           child: userAvatar(
          //             name: cohostNames[index],
          //             radius: 18,
          //           ),
          //         );
          //       }),
          //     ),
          //   ),
          // ),

          const SizedBox(height: 20),

          Container(
            padding: EdgeInsets.all(5),
            child: Text(
              event['Description'] ?? '',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: screenSize.height/60
              ),
            ),
          ),



        ],
      ),
    );
  }

  Widget userAvatar({
    required String name,
    String? imageUrl,
    double radius = 22,
  }) {
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(imageUrl),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.blue,
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}