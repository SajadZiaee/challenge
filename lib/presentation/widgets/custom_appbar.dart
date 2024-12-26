import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_challenge/core/constants/app_colors.dart';
import 'package:chat_challenge/core/constants/app_icons.dart';
import 'package:chat_challenge/core/constants/app_text_styles.dart';
import 'package:chat_challenge/application/providers/current_user_provider.dart';
import 'package:chat_challenge/application/providers/s3_providers.dart'; // Import the upload provider

class CustomAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final uploadState =
        ref.watch(uploadDownloadProvider); // Access upload state

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          toolbarHeight: 90,
          backgroundColor: AppColors.appbarBackgroundColor,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: SvgPicture.asset(AppIcons.chevronLeft),
                onPressed: () {},
              ),
              GestureDetector(
                onTap: uploadState.isUploading
                    ? null // Disable toggling if an image is being uploaded
                    : () {
                        ref.read(currentUserProvider.notifier).toggleUser();
                      },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(user.profilePicture),
                      radius: 30,
                    ),
                    Row(
                      children: [
                        Text(user.name, style: AppTextStyles.avatarTextStyle),
                        const SizedBox(
                          width: 4,
                        ),
                        SvgPicture.asset(
                          AppIcons.chevronRight,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: SvgPicture.asset(AppIcons.video),
                onPressed: () {},
              ),
            ],
          ),
        ),
        Container(
          height: 1, // Border height
          color: AppColors.inputBorder, // Define your border color
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(91); // Adjust for border height
}
