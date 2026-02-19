import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:gathering/constants/app_colors.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  LatLng? _currentLocation;
  bool _loading = true;

  String _selectedCategory = 'Parties';

  final List<String> _categories = [
    'Parties',
    'Concerts',
    'Clubs',
    'Meetups'
  ];

  final List<Map<String, dynamic>> _events =  [
    {
      'description': 'DJ Night',
      'date': '1 Jan, 2026',
      'category': 'Parties',
      "Image": "https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=800",
      'Host': 'DJ',
      'Co-Host': ['JD', 'SS'],
      'location': LatLng(28.6140, 77.2091),
    },{
      'description': 'Meetups',
      'date': '15 Jan, 2026',
      'category': 'Meetups',
      "Image": "https://images.unsplash.com/photo-1528605248644-14dd04022da1?w=800",
      'Host': 'PK',
      'Co-Host': ['SD', 'KK'],
      'location': LatLng(28.6140, 77.2091),
    },{
      'description': 'Concert',
      'date': '1 Jan, 2026',
      'category': 'Concerts',
      "Image": "https://images.unsplash.com/photo-1470229722913-7c0e2dbbafd3?w=800",
      'Host': 'TT',
      'Co-Host': ['JD', 'SS'],
      'location': LatLng(28.6138, 77.2089),
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
  // [
  //   {
  //     'title': 'Neon Night Party',
  //     'category': 'Parties',
  //     'date': 'Fri, Apr 25',
  //     'rating': 4.4,
  //     'location': LatLng(28.6140, 77.2091),
  //   },
  //   {
  //     'title': 'Rock Mania Concert',
  //     'category': 'Concerts',
  //     'date': 'Sat, May 1',
  //     'rating': 4.3,
  //     'location': LatLng(28.6138, 77.2089),
  //   },
  // ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services disabled';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location permission permanently denied';
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _loading = false;
      });
    } catch (e) {
      debugPrint('Location error: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final markerSize = size.width * 0.1;

    final filteredEvents = _events
        .where((e) => e['category'] == _selectedCategory)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          /// 🗺️ LIGHT MODE MAP
          FlutterMap(
            options: MapOptions(
              initialCenter:
              _currentLocation ?? const LatLng(28.6139, 77.2090),
              initialZoom: 14,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.gathering',
              ),

              /// 📍 Current location marker
              if (_currentLocation != null)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _currentLocation!,
                      width: markerSize,
                      height: markerSize,
                      child: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: markerSize,
                      ),
                    ),
                  ],
                ),

              /// 📌 Event markers
              MarkerLayer(
                markers: filteredEvents.map((event) {
                  return Marker(
                    point: event['location'],
                    width: markerSize,
                    height: markerSize,
                    child: Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: markerSize,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          /// 🔍 TOP UI
          Positioned(
            top: MediaQuery.of(context).padding.top + 12,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Explore',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 12),

                /// Search bar
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                      hintText: 'Search events, places...',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Category filters
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final selected = cat == _selectedCategory;

                      return GestureDetector(
                        onTap: () {
                          setState(() => _selectedCategory = cat);
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 10),
                          padding:
                          const EdgeInsets.symmetric(horizontal: 18),
                          decoration: BoxDecoration(
                            color: selected
                                ? Colors.deepPurple
                                : Colors.white,
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
                              color: selected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          /// 📦 DRAGGABLE EVENT LIST
          DraggableScrollableSheet(
            initialChildSize: 0.25,
            minChildSize: 0.15,
            maxChildSize: 0.65,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    /// Drag handle
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    /// Event list
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: filteredEvents.length,
                        itemBuilder: (context, index) {
                          final event = filteredEvents[index];
                          // final event = eventList[index];
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
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
