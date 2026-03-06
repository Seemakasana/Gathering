import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gathering/bloc/event/event_bloc.dart';
import 'package:gathering/constants/app_colors.dart';
import 'package:gathering/pages/UserMainPage/DrawerItmes/Events/CreateEvent.dart';
import 'package:gathering/pages/UserMainPage/DrawerItmes/Events/EventDetailPage.dart';
import 'package:gathering/widgets/DateFormate.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  String _selectedCategory = 'Posted';

  final List<String> _categories = [
    'Posted',
    'Attended',
    'Wishlist',
    'Registered'
  ];

  final List<Map<String, dynamic>> _groups = [
    {
      'name': 'Weekend Party Crew',
      'avatar': 'WPC',
      'members': 12,
      'lastMessage': 'Sarah: New event added!',
      'time': '30m ago',
      'unread': 3,
    },
    {
      'name': 'Music Lovers',
      'avatar': 'ML',
      'members': 25,
      'lastMessage': 'Mike: Concert tickets available',
      'time': '2h ago',
      'unread': 0,
    },
    {
      'name': 'Foodie Group',
      'avatar': 'FG',
      'members': 8,
      'lastMessage': 'Emma: Restaurant recommendation',
      'time': '1d ago',
      'unread': 1,
    },
  ];

  int _selectedTab = 0; // 0 = People You Met, 1 = Groups

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventBloc>().add(LoadMyEvents());
    });
  }



  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            "Events",
            style: TextStyle(
              fontSize: size.height/40
            ),
          ),
        ),
        body: Column(
          children: [



            _buildContainer(size),

            // category Filter
            Container(
              margin: const EdgeInsets.all( 10, ),
              height: size.height/20,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final selected = cat == _selectedCategory;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10, ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: selected
                            ? Colors.deepPurple
                            :AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 4,
                            color: Colors.black12,
                          )
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cat,
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: selected
                              ? Colors.white
                              : AppColors.textSecondary
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),


            Expanded(
              child: _selectedCategory == _categories[0]
                  ? _buildPosted(size)
                  : _selectedCategory == _categories[1]
                  ? _buildGroupsList(size)
                  : _selectedCategory == _categories[2]
                  ? _buildGroupsList(size)
                  : _selectedCategory == _categories[3]
                  ? _buildGroupsList(size)
                  : _buildPosted(size),
            )

            // List

          ],
        ),
        floatingActionButton:  InkWell(onTap: (){
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) =>  CreateEventPage()),
          );
        }, child: Container(
          height: size.height/22*2,
          width: size.height/22*2,
          margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.008,
          ),
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color:  AppColors.accent,
            // gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(size.width * 0.04),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline,
                size: size.height/35, color: AppColors.textPrimaryDark,),
              // Text("Add Events",
              // overflow: TextOverflow.ellipsis,
              // maxLines: 1,
              // style: TextStyle(
              //   fontSize: size.height/65,
              //   color: AppColors.textPrimary
              // ),)
            ],
          ),
        )),
      ),
    );
  }



  Widget _buildContainer(Size size) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.008,
      ),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        gradient: AppColors.secondaryGradient,
        borderRadius: BorderRadius.circular(size.width * 0.04),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                  "Event Posted",
                style: TextStyle(
                  fontSize: size.height/50,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimaryDark
                ),
              ),

              Text(
                  "20",
                style: TextStyle(
                  fontSize: size.height/60,
                  color:AppColors.textPrimary
                ),
              )
            ],
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "Attended",
                    style: TextStyle(
                      fontSize: size.height/50,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryDark
                    ),
                  ),

                  Text(
                      "5",
                    style: TextStyle(
                      fontSize: size.height/60,
                      color:AppColors.textPrimary
                    ),
                  )
                ],
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                      "Wishlist",
                    style: TextStyle(
                      fontSize: size.height/50,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimaryDark
                    ),
                  ),

                  Text(
                      "2",
                    style: TextStyle(
                      fontSize: size.height/60,
                      color:AppColors.textPrimary
                    ),
                  )
                ],
              ),
            ],
          )

        ],
      )
    );
  }


  Widget _buildTabButton(Size size, String label, int index, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: size.height * 0.015),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? AppColors.accent : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: size.width * 0.04,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPosted(Size size ) {
    return  BlocBuilder<EventBloc, EventState>(
      builder: (context, state) {
        if (state is EventLoading) {
          return const Center(child: CircularProgressIndicator(
            color: AppColors.accent,
          ));
        }

        if (state is EventsLoaded) {
          return RefreshIndicator(
            color: AppColors.accent,
            onRefresh: () async {
              context.read<EventBloc>().add(RefreshMyEvents());
            },
            child:SingleChildScrollView(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  print(" fetch created events: ${event} ");
                  // final List<String> cohosts =
                  //     (event['cohost'] as List?)?.cast<String>() ?? [];
                  // final List<String> cohostNames =
                  // (event['event_cohosts'] as List? ?? [])
                  //     .map((e) => e['user']?['name'] as String?)
                  //     .where((name) => name != null && name.isNotEmpty)
                  //     .cast<String>()
                  //     .toList();
              
                  final names = event['host_user']["name"].split(' ');
                  var userInitial = names.length > 1
                      ? '${names[0][0]}${names[1][0]}'
                      : event['host_user']["name"][0];
              
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) =>  EventDetailsPage(eventId: event['EventID'])),
                      );
              
                      // TODO: Navigate to event detail
                    },
                    child: Container(
                      height: size.height * 0.2,
                      margin: EdgeInsets.symmetric(
                        horizontal: size.width * 0.04,
                        vertical: size.height * 0.012,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.width * 0.045),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(size.width * 0.045),
                        child: Stack(
                          children: [
                            /// 🔹 Background Image
                            Positioned.fill(
                              child: Image.network(
                                event['EventImage'],
                                fit: BoxFit.cover,
                              ),
                            ),
              
                            /// 🔹 Gradient Overlay (vibe + readability)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.black.withOpacity(0.25),
                                      Colors.black.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                              ),
                            ),
              
                            /// 🔹 Content
                            Padding(
                              padding: EdgeInsets.all(size.width * 0.04),
                              child: Row(
                                children: [
                                  /// HOST AVATAR
                                  CircleAvatar(
                                    radius: size.width * 0.075,
                                    backgroundColor: Colors.white.withOpacity(0.9),
                                    child: Text(
                                      userInitial,
                                      style: TextStyle(
                                        color: AppColors.accent,
                                        fontSize: size.width * 0.045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
              
                                  SizedBox(width: size.width * 0.04),
              
                                  /// EVENT INFO
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          event['Heading'],
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: size.width * 0.045,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: size.height * 0.006),
                                        Text(
                                          customFormat.formatEventDate(event['EventDate']),
                                          style: TextStyle(
                                            fontSize: size.width * 0.035,
                                            color: Colors.white.withOpacity(0.85),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
              
                                  /// CO-HOST STACKED AVATARS
                                  // Visibility(
                                  //   visible:  cohosts.isNotEmpty,
                                  //   child: SizedBox(
                                  //     height: size.width * 0.1,
                                  //     width: size.width * 0.2,
                                  //     child: Stack(
                                  //       children: List.generate(
                                  //         cohostNames.length,
                                  //             (index) {
                                  //           final avatar = cohostNames[index];
                                  //
                                  //
                                  //           return Positioned(
                                  //             left: index * (size.width * 0.045),
                                  //             child: Container(
                                  //               decoration: BoxDecoration(
                                  //                 shape: BoxShape.circle,
                                  //                 border: Border.all(
                                  //                   color: Colors.white,
                                  //                   width: 1.5,
                                  //                 ),
                                  //               ),
                                  //               child: CircleAvatar(
                                  //                 radius: size.width * 0.04,
                                  //                 backgroundColor: AppColors.electricBlue,
                                  //                 child: Text(
                                  //                   avatar,
                                  //                   style: TextStyle(
                                  //                     color: Colors.white,
                                  //                     fontSize: size.width * 0.025,
                                  //                     fontWeight: FontWeight.bold,
                                  //                   ),
                                  //                 ),
                                  //               ),
                                  //             ),
                                  //           );
                                  //         },
                                  //       ),
                                  //     ),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
              
              
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }

        if (state is EventFailure) {
          print("state.error: ${state.error}");
          return Center(child: Text("Error occurred, try again later!"));
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildGroupsList(Size size) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      itemCount: _groups.length,
      itemBuilder: (context, index) {
        final group = _groups[index];
        return Container(
          margin: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.008,
          ),
          padding: EdgeInsets.all(size.width * 0.04),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(size.width * 0.04),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: size.width * 0.08,
                backgroundColor: AppColors.electricBlue,
                child: Text(
                  group['avatar'] as String,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group['name'] as String,
                      style: TextStyle(
                        fontSize: size.width * 0.042,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: size.height * 0.003),
                    Text(
                      '${group['members']} members',
                      style: TextStyle(
                        fontSize: size.width * 0.032,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: size.height * 0.003),
                    Text(
                      group['lastMessage'] as String,
                      style: TextStyle(
                        fontSize: size.width * 0.035,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    group['time'] as String,
                    style: TextStyle(
                      fontSize: size.width * 0.03,
                      color: AppColors.textLight,
                    ),
                  ),
                  if ((group['unread'] as int) > 0) ...[
                    SizedBox(height: size.height * 0.005),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.025,
                        vertical: size.height * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(size.width * 0.05),
                      ),
                      child: Text(
                        group['unread'].toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: size.width * 0.028,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
