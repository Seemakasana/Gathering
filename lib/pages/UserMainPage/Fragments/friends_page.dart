import 'package:flutter/material.dart';
import 'package:gathering/constants/app_colors.dart';
import 'package:gathering/widgets/customAppbar.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final List<Map<String, dynamic>> _peopleYouMet = [
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.background,
         appBar: CustomAppBar(),
        body: Column(
          children: [
            // Header
            // Container(
            //   padding: EdgeInsets.symmetric(
            //     horizontal: size.width * 0.04,
            //     vertical: size.height * 0.015,
            //   ),
            //   child: Row(
            //     children: [
            //       Expanded(
            //         child: Text(
            //           'Connections',
            //           style: TextStyle(
            //             fontSize: size.width * 0.06,
            //             fontWeight: FontWeight.bold,
            //             color: AppColors.textPrimary,
            //           ),
            //         ),
            //       ),
            //       Container(
            //         width: size.width * 0.7,
            //         height: size.height * 0.055,
            //         decoration: BoxDecoration(
            //           color: AppColors.surface,
            //           borderRadius: BorderRadius.circular(size.width * 0.03),
            //           border: Border.all(color: AppColors.textLight.withOpacity(0.3)),
            //         ),
            //         child: Row(
            //           children: [
            //             Padding(
            //               padding: EdgeInsets.only(left: size.width * 0.04),
            //               child: Icon(
            //                 Icons.search,
            //                 color: AppColors.textSecondary,
            //                 size: size.width * 0.05,
            //               ),
            //             ),
            //             Expanded(
            //               child: TextField(
            //                 style: TextStyle(color: AppColors.textPrimary),
            //                 decoration: InputDecoration(
            //                   hintText: 'Search...',
            //                   hintStyle: TextStyle(
            //                     color: AppColors.textSecondary,
            //                     fontSize: size.width * 0.038,
            //                   ),
            //                   border: InputBorder.none,
            //                   contentPadding: EdgeInsets.symmetric(
            //                     horizontal: size.width * 0.03,
            //                     vertical: size.height * 0.015,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // ),


            Container(
              height: size.width * 0.13,
              padding: EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 2,
              ),
              margin: EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 6,
                    color: Colors.black12,
                  )
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search people, group...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),

            // Tabs
            Container(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
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
                    child: _buildTabButton(
                      size,
                      'People You Met',
                      0,
                      _selectedTab == 0,
                    ),
                  ),
                  SizedBox(width: size.width * 0.04),
                  Expanded(
                    child: _buildTabButton(
                      size,
                      'Groups',
                      1,
                      _selectedTab == 1,
                    ),
                  ),
                  SizedBox(width: size.width * 0.04),
                  Expanded(
                    child: _buildTabButton(
                      size,
                      'Requests',
                      2,
                      _selectedTab == 2,
                    ),
                  ),
                ],
              ),
            ),

            // List
            Expanded(
              child: _selectedTab == 0
                  ? _buildPeopleYouMetList(size)
                  : _selectedTab == 1? _buildGroupsList(size): _buildPeopleYouMetList(size),
            ),
          ],
        ),
      ),
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

  Widget _buildPeopleYouMetList(Size size) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
      itemCount: _peopleYouMet.length,
      itemBuilder: (context, index) {
        final person = _peopleYouMet[index];
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
