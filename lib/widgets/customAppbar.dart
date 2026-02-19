import 'package:flutter/material.dart';
import 'package:gathering/constants/app_colors.dart';

class CustomAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(90);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: preferredSize.height/8*6,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 5,
        right: 5,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [


          /// TITLE
          Row(
            children: [
              Container(
                child: Image(image: AssetImage("assets/GatheringLogo.png"),
                  fit: BoxFit.fill,
                  // width: size.width/3 ,
                  // height: size.width/5,
                ),
              ),
              Text(
                'Gathering',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.055,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          /// RIGHT (notification)
          IconButton(
            onPressed: () {
              // TODO: notification action
            },
            icon: Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: size.width * 0.065,
            ),
          ),
        ],
      ),
    );
  }
}
