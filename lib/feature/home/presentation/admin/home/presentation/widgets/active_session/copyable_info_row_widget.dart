import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_app/core/services/toast_service.dart';
import 'package:mobile_app/core/themes/app_text_style.dart';

class CopyableInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const CopyableInfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110.w,
          child: Text(
            label,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyle.font14MediamGrey.copyWith(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            Clipboard.setData(ClipboardData(text: value));
            showToast(message: 'Copied: $value', type: ToastType.success);
          },
          child: Icon(Icons.copy, size: 16.sp, color: Colors.blue),
        ),
      ],
    );
  }
}
