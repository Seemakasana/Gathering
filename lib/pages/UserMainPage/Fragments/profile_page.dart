import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gathering/bloc/auth/auth_bloc.dart';
import 'package:gathering/bloc/auth/auth_state.dart';
import 'package:gathering/constants/app_colors.dart';
import 'package:gathering/pages/UserMainPage/DrawerItmes/Events/EventsPage.dart';
import 'package:gathering/widgets/customAppbar.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedTab = 0; // 0 = Attended, 1 = Places, 2 = Wishlist

  final List<Map<String, dynamic>> _attendedEvents = [
    {
      'description': 'DJ Night',
      'date': '1 Jan, 2026',
      "Image": "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800",
      'Host': 'DJ',
      'Co-Host': ['JD', 'SS'],
    },{
      'description': 'Meetups',
      'date': '15 Jan, 2026',
      "Image": "https://images.unsplash.com/photo-1528605248644-14dd04022da1?w=800",
      'Host': 'PK',
      'Co-Host': ['SD', 'KK'],
    },{
      'description': 'Concert',
      'date': '1 Jan, 2026',
      "Image": "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800",
      'Host': 'TT',
      'Co-Host': ['JD', 'SS'],
    },
    // {
      // 'name': 'MeetUps',
      // 'date': 'Feb 15, 2022',
      // 'avatar': 'BP',
      // 'attendees': [
      //   'https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2?w=800',
      //   'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=800'
      // ],
    // },
  ];


  final List<Map<String, dynamic>> FreindList = [
    {
      'name': 'John Doe',
      'avatar': 'J',
      'status': 'Online',
      'lastEvent': 'Neon Night Party',
      'lastMessage': 'Hey! Are you going to the concert?',
      'time': '2m ago',
      'unread': 2,
    },
    {
      'name': 'Sarah Smith',
      'avatar': 'S',
      'status': 'Online',
      'lastEvent': 'Rock Mania Concert',
      'lastMessage': 'Great party last night!',
      'time': '1h ago',
      'unread': 0,
    },
    {
      'name': 'Mike Johnson',
      'avatar': 'M',
      'status': 'Offline',
      'lastEvent': 'DJ Night',
      'lastMessage': 'See you at the event!',
      'time': '3h ago',
      'unread': 1,
    },
    {
      'name': 'Emma Wilson',
      'avatar': 'E',
      'status': 'Online',
      'lastEvent': 'Beach Party',
      'lastMessage': 'Thanks for the recommendation!',
      'time': '5h ago',
      'unread': 0,
    },
  ];

  final List<Map<String, dynamic>> _wishlist = [
    {
      'description': 'DJ Night',
      'date': '1 Jan, 2026',
      "Image": "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800",
      'Host': 'DJ',
      'Co-Host': ['JD', 'SS'],
    },{
      'description': 'Meetups',
      'date': '15 Jan, 2026',
      "Image": "https://images.unsplash.com/photo-1528605248644-14dd04022da1?w=800",
      'Host': 'PK',
      'Co-Host': ['SD', 'KK'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final time = DateTime.now();
    final timeString = '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
        
              // Profile Banner with starry purple background
              InkWell(
                onTap: (){},
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.04),
                  decoration: BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    //   colors: [
                    //     AppColors.accent.withOpacity(0.8),
                    //     AppColors.accentDark,
                    //   ],
                    // ),
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 20,),
                      // Starry background effect
                      Stack(
                        children: [
                          Container(
                            width: size.width * 0.3,
                            height: size.width * 0.3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.background,
                              border: Border.all(color: AppColors.accentLight, width: 2)
                            ),
                            child: CircleAvatar(
                              radius: size.width * 0.15,
                              backgroundColor: AppColors.surface,
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  String userInitial = 'AS';
                                  // bool isPhoto =true;
                                  String photoUrl='';
                                  if (state is AuthAuthenticated && state.name.isNotEmpty) {
                                    final names = state.name.split(' ');
                                    userInitial = names.length > 1
                                        ? '${names[0][0]}${names[1][0]}'
                                        : state.name[0];
                                  }
        
                                  if (state is AuthAuthenticated && state.photoUrl.isNotEmpty) {
                                    photoUrl = "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400";
                                    return ClipOval(
                                      child: Image.network(
                                        state.photoUrl.toString(),
                                        width: size.width * 0.3,
                                        height: size.width * 0.3,
                                        fit: BoxFit.fill,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return const Center(child: CircularProgressIndicator());
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return  Icon(Icons.broken_image, size: size.height/45);
                                        },
                                      ),
                                    );
                                  }else {
                                    return Text(
                                      userInitial.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: size.width * 0.08,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    );
                                  }
        
                                  // return isPhoto ==  false ? Text(
                                  //   userInitial.toUpperCase(),
                                  //   style: TextStyle(
                                  //     fontSize: size.width * 0.08,
                                  //     fontWeight: FontWeight.bold,
                                  //     color: AppColors.textPrimary,
                                  //   ),
                                  // ):ClipOval(
                                  //   child: Image.network(
                                  //     "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=400",
                                  //     width: size.width * 0.3,
                                  //     height: size.width * 0.3,
                                  //     fit: BoxFit.fill,
                                  //     loadingBuilder: (context, child, loadingProgress) {
                                  //       if (loadingProgress == null) return child;
                                  //       return const Center(child: CircularProgressIndicator());
                                  //     },
                                  //     errorBuilder: (context, error, stackTrace) {
                                  //       return  Icon(Icons.broken_image, color: Colors.white ,size: size.height/30);
                                  //     },
                                  //   ),
                                  // );
        
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            right: 2,
                            child: Container(
                              margin: EdgeInsets.only(left: size.width * 0.02),
                              child: CircleAvatar(
                                radius: size.width * 0.04,
                                backgroundColor: AppColors.accent,
                                child: Icon(Icons.edit, color: Colors.white, size: size.height/55,)
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(width: size.height * 0.04),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          String userName = 'Name';
                          String userLocation = 'India';
                          String userBio = 'Party Lover | Traveler';
        
                          if (state is AuthAuthenticated) {
                            userName = state.name.isNotEmpty ? state.name : 'Amit Sharma';
                            userLocation = state.city.isNotEmpty? state.city : 'India';
                            // userBio =  state
                          }
        
                          return Column(
                            children: [
                              Text(
                                userName,
                                style: TextStyle(
                                  fontSize: size.width * 0.06,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: size.height * 0.005),
                              Text(
                                userLocation,
                                style: TextStyle(
                                  fontSize: size.width * 0.038,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              SizedBox(height: size.height * 0.005),
                              Text(
                                userBio,
                                style: TextStyle(
                                  fontSize: size.width * 0.035,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
        
              // Stats Row
              Container(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.025),
                color: AppColors.surface,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStat(size, '12', 'Post/ Video', (){}),
                    Container(
                      width: 1,
                      height: size.height * 0.04,
                      color: AppColors.textLight.withOpacity(0.3),
                    ),
                    _buildStat(size, '34', 'Events', (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const EventsPage()),
                      );
                    }),
                    Container(
                      width: 1,
                      height: size.height * 0.04,
                      color: AppColors.textLight.withOpacity(0.3),
                    ),
                    _buildStat(size, '8', 'Friends Request', (){}),
                  ],
                ),
              ),
        
              // Tabs
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildProfileTab(size, 'Attended', 0),
                    ),
                    Expanded(
                      child: _buildProfileTab(size, 'Wishlist', 1),
                    ),
                    Expanded(
                      child: _buildProfileTab(size, 'Freind Requests', 2),
                    ),
                  ],
                ),
              ),
        
              // Content
              _buildContent(size),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(Size size, String value, String label,var onTap) {
    return InkWell(
      onTap:onTap ,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: size.width * 0.06,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          SizedBox(height: size.height * 0.005),
          Text(
            label,
            style: TextStyle(
              fontSize: size.width * 0.035,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(Size size, String label, int index) {
    final isSelected = _selectedTab == index;
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
            fontSize: size.width * 0.038,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.accent : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Size size) {
    if (_selectedTab == 0) {
      return _buildAttendedList(size, _attendedEvents);
    } else if (_selectedTab == 1) {
      // return _buildWishlistList(size);
      return _buildAttendedList(size, _wishlist);
    } else {
      return _buildFreindRequestList(size);
    }
  }

  Widget _buildAttendedList(Size size, List eventList ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
      itemCount: eventList.length,
      itemBuilder: (context, index) {
        final event = eventList[index];
        print(" attended events: $event ");
        return GestureDetector(
          onTap: () {
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
                      event['Image'],
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
                            event['Host'],
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
                                event['description'],
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
                                event['date'],
                                style: TextStyle(
                                  fontSize: size.width * 0.035,
                                  color: Colors.white.withOpacity(0.85),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// CO-HOST STACKED AVATARS
                        SizedBox(
                          height: size.width * 0.1,
                          width: size.width * 0.2,
                          child: Stack(
                            children: List.generate(
                              (event['Co-Host'] as List<String>).length,
                                  (index) {
                                final avatar = event['Co-Host'][index];

                                return Positioned(
                                  left: index * (size.width * 0.045),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: size.width * 0.04,
                                      backgroundColor: AppColors.electricBlue,
                                      child: Text(
                                        avatar,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: size.width * 0.025,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// 🔹 Floating tag (optional)
                  // Positioned(
                  //   top: size.height * 0.015,
                  //   right: size.width * 0.04,
                  //   child: Container(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: size.width * 0.03,
                  //       vertical: size.height * 0.004,
                  //     ),
                  //     decoration: BoxDecoration(
                  //       color: AppColors.accent,
                  //       borderRadius: BorderRadius.circular(20),
                  //     ),
                  //     child: const Text(
                  //       'LIVE',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //         fontSize: 12,
                  //         fontWeight: FontWeight.bold,
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFreindRequestList(Size size) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      itemCount: FreindList.length,
      itemBuilder: (context, index) {
        final person = FreindList[index];
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
              Stack(
                children: [
                  CircleAvatar(
                    radius: size.width * 0.08,
                    backgroundColor: AppColors.accent,
                    child: Text(
                      person['avatar'] as String,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: size.width * 0.05,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (person['status'] == 'Online')
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: size.width * 0.045,
                        height: size.width * 0.045,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.surface,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(width: size.width * 0.04),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      person['name'] as String,
                      style: TextStyle(
                        fontSize: size.width * 0.042,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: size.height * 0.003),
                    Text(
                      person['lastEvent'] as String,
                      style: TextStyle(
                        fontSize: size.width * 0.035,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: size.height * 0.003),
                    Text(
                      person['lastMessage'] as String,
                      style: TextStyle(
                        fontSize: size.width * 0.033,
                        color: AppColors.textLight,
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
                    person['time'] as String,
                    style: TextStyle(
                      fontSize: size.width * 0.03,
                      color: AppColors.textLight,
                    ),
                  ),
                  if ((person['unread'] as int) > 0) ...[
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
                        person['unread'].toString(),
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

  // Widget _buildWishlistList(Size size) {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     physics: const NeverScrollableScrollPhysics(),
  //     padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
  //     itemCount: _wishlist.length,
  //     itemBuilder: (context, index) {
  //       final event = _wishlist[index];
  //       return Container(
  //         margin: EdgeInsets.symmetric(
  //           horizontal: size.width * 0.04,
  //           vertical: size.height * 0.01,
  //         ),
  //         padding: EdgeInsets.all(size.width * 0.04),
  //         decoration: BoxDecoration(
  //           color: AppColors.surface,
  //           borderRadius: BorderRadius.circular(size.width * 0.04),
  //           boxShadow: [
  //             BoxShadow(
  //               color: Colors.black.withOpacity(0.1),
  //               blurRadius: 8,
  //               offset: const Offset(0, 2),
  //             ),
  //           ],
  //         ),
  //         child: Row(
  //           children: [
  //             Container(
  //               width: size.width * 0.15,
  //               height: size.width * 0.15,
  //               decoration: BoxDecoration(
  //                 color: AppColors.accent.withOpacity(0.2),
  //                 borderRadius: BorderRadius.circular(size.width * 0.03),
  //               ),
  //               child: Icon(
  //                 Icons.favorite,
  //                 color: AppColors.accent,
  //                 size: size.width * 0.06,
  //               ),
  //             ),
  //             SizedBox(width: size.width * 0.04),
  //             Expanded(
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Text(
  //                     event['name'] as String,
  //                     style: TextStyle(
  //                       fontSize: size.width * 0.042,
  //                       fontWeight: FontWeight.w600,
  //                       color: AppColors.textPrimary,
  //                     ),
  //                   ),
  //                   SizedBox(height: size.height * 0.005),
  //                   Text(
  //                     event['date'] as String,
  //                     style: TextStyle(
  //                       fontSize: size.width * 0.035,
  //                       color: AppColors.textSecondary,
  //                     ),
  //                   ),
  //                   SizedBox(height: size.height * 0.003),
  //                   Text(
  //                     event['location'] as String,
  //                     style: TextStyle(
  //                       fontSize: size.width * 0.033,
  //                       color: AppColors.textLight,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
