import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolcg_qr_code/res/colors.dart';
import 'package:wolcg_qr_code/res/theme.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;
  final AxisDirection direction;
  final Color? bgColor;
  const LoadingDialog({
    super.key,
    this.message,
    this.direction = AxisDirection.right,
    this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (message == null)
          ? _buildLoadingWidgetNoMessage()
          : _buildLoadingWidgetMessage(context),
    );
  }

  Widget _buildLoadingWidgetNoMessage() {
    return SizedBox(
      width: 36.w,
      height: 36.w,
      child: CircularProgressIndicator(
        color: colorPrimary,
        backgroundColor: colorPrimary.withOpacity(0.2),
        strokeWidth: 3.5,
      ),
    );
  }

  Widget _buildLoadingWidgetMessage(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: bgColor ?? Colors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (direction == AxisDirection.right)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 28.w,
                  height: 28.w,
                  child: CircularProgressIndicator(
                    color: colorPrimary,
                    backgroundColor: colorPrimary.withOpacity(0.3),
                    strokeWidth: 3,
                  ),
                ),
                SizedBox(width: 12.w),
                DefaultTextStyle(
                  style: text14.lSpacing(0.4).withColor(Colors.black),
                  child: Text(message!),
                ),
              ],
            )
          else ...[
            SizedBox(
              width: 28.w,
              height: 28.w,
              child: CircularProgressIndicator(
                color: colorPrimary,
                backgroundColor: colorPrimary.withOpacity(0.3),
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 12.h),
            DefaultTextStyle(
              style: text14.lSpacing(0.4),
              child: Text(message!),
            ),
          ],
        ],
      ),
    );
  }
}
