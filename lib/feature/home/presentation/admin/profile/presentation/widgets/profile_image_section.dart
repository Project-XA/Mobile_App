import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/core/services/spacing.dart';
import 'package:mobile_app/core/themes/app_colors.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_cubit.dart';
import 'package:mobile_app/core/curren_user/presentation/cubits/current_user_state.dart';
import 'package:mobile_app/feature/home/presentation/admin/profile/presentation/widgets/image_source_option.dart';

class ProfileImageSection extends StatelessWidget {
  const ProfileImageSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CurrentUserCubit, CurrentUserState>(
      builder: (context, state) {
        final user = context.read<CurrentUserCubit>().currentUser;
        final profileImage = user?.profileImage;

        return Stack(
          children: [
            Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainTextColorBlack.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.r),
                child: profileImage != null
                    ? Image.file(
                        File(profileImage),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/user.png",
                            fit: BoxFit.cover,
                          );
                        },
                      )
                    : Image.asset(
                        "assets/images/user.png",
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: () => _pickImage(context),
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.mainTextColorBlack.withOpacity(0.15),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 18.sp,
                    color: AppColors.mainTextColorBlack,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose Image Source',
              style: AppTextStyle.font14MediamGrey.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpace(20.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ImageSourceOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () async {
                    Navigator.pop(ctx);
                    final image = await picker.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 80,
                    );
                    if (image != null && context.mounted) {
                      context.read<CurrentUserCubit>().updateProfileImage(
                            File(image.path),
                          );
                    }
                  },
                ),
                ImageSourceOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () async {
                    Navigator.pop(ctx);
                    final image = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 80,
                    );
                    if (image != null && context.mounted) {
                      context.read<CurrentUserCubit>().updateProfileImage(
                            File(image.path),
                          );
                    }
                  },
                ),
              ],
            ),
            verticalSpace(10.h),
          ],
        ),
      ),
    );
  }
}