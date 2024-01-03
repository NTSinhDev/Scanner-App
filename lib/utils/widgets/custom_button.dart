import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolcg_qr_code/res/colors.dart';
import 'package:wolcg_qr_code/res/theme.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function()? onTap;
  final String? label;
  final double? width;
  final double? height;
  final Widget? child;
  final EdgeInsets? padding;
  final Color? color;
  final double? radius;
  final Color? borderColor;
  final List<BoxShadow>? boxShadows;
  final Color? labelColor;
  const CustomButtonWidget({
    super.key,
    this.onTap,
    this.label,
    this.width,
    this.child,
    this.padding,
    this.color,
    this.height,
    this.radius,
    this.borderColor,
    this.boxShadows,
    this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: padding != null ? null : height ?? 55.h,
        padding: padding,
        width: padding != null ? null : width ?? double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 15.r),
          color: color ?? colorPrimary,
          border: Border.all(color: borderColor ?? colorPrimary),
          boxShadow: boxShadows ??
              <BoxShadow>[
                BoxShadow(
                  color: colorPrimary.withOpacity(0.2),
                  offset: const Offset(0.0, 4.0),
                  blurRadius: 4.r,
                ),
              ],
        ),
        child: child ??
            Center(
              child: label!.isEmpty
                  ? SizedBox(
                      width: 32.w,
                      height: 32.w,
                      child: CircularProgressIndicator(
                        color: colorPrimary,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text(
                      label!,
                      style: text18.bold
                          .lSpacing(0.5)
                          .withColor(labelColor ?? Colors.white),
                    ),
            ),
      ),
    );
  }
}
