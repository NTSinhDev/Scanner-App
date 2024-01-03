import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolcg_qr_code/utils/widgets/loading_dialog.dart';

extension BuildContextExt on BuildContext {
  static LoadingDialog? _loadingDialog;

  Size get size => MediaQuery.sizeOf(this);

  NavigatorState get navigator => Navigator.of(this);

  ModalRoute<dynamic>? get route => ModalRoute.of(this);

  Map<String, dynamic>? get routeArguments {
    return route!.settings.arguments as Map<String, dynamic>;
  }

  FocusScopeNode get focus => FocusScope.of(this);

  ScaffoldMessengerState get scaffoldMessagerState =>
      ScaffoldMessenger.of(this);

  ThemeData get theme => Theme.of(this);

  // Future<DateTime?> showMyDatePicker({
  //   required DateTime initialDate,
  //   required DateTime firstDate,
  // }) async =>
  //     await showDatePicker(
  //       context: this,
  //       initialDate: initialDate,
  //       firstDate: firstDate,
  //       lastDate: DateTime.now(),
  //       fieldHintText: lang.day_month_year_hint,
  //       builder: (BuildContext context, Widget? child) {
  //         return Theme(
  //           data: ThemeData.light().copyWith(
  //             colorScheme: const ColorScheme.light(
  //               primary: AppColors.primary,
  //               onPrimary: Colors.white,
  //               onBackground: Colors.red,
  //             ),
  //             textButtonTheme: TextButtonThemeData(
  //               style: TextButton.styleFrom(
  //                 textStyle: text16.bold.tColorPrimary,
  //                 backgroundColor: AppColors.primary.withOpacity(0.1),
  //                 visualDensity: const VisualDensity(horizontal: 4.0),
  //               ),
  //             ),
  //           ),
  //           child: child!,
  //         );
  //       },
  //     );

  // Future<DateTimeRange?> showMyDateRangePicker({
  //   required DateTime firstDate,
  //   DateTime? lastDate,
  //   DateTimeRange? initialDateRange,
  // }) async =>
  //     await showDateRangePicker(
  //       context: this,
  //       firstDate: firstDate,
  //       lastDate: lastDate ?? DateTime.now(),
  //       currentDate: DateTime.now(),
  //       initialDateRange: initialDateRange,
  //       builder: (BuildContext context, Widget? child) {
  //         return Theme(
  //           data: ThemeData.light().copyWith(
  //             colorScheme: const ColorScheme.light(
  //               primary: AppColors.primary,
  //               onPrimary: Colors.white,
  //               onBackground: Colors.red,
  //             ),
  //             textButtonTheme: TextButtonThemeData(
  //               style: TextButton.styleFrom(
  //                 textStyle: text16.bold.tColorPrimary,
  //                 backgroundColor: AppColors.primary.withOpacity(0.1),
  //                 visualDensity: const VisualDensity(horizontal: 4.0),
  //               ),
  //             ),
  //           ),
  //           child: child!,
  //         );
  //       },
  //     );

  // void showFlashMsgSnackBar({
  //   required String message,
  //   required FlashMessageType type,
  // }) {
  //   FlashMessageSnackBar(context: this, message: message, type: type);
  // }

  Future<T?> showCustomDialog<T>({
    bool canPhysicalBack = true,
    bool canDismiss = true,
    double? height,
    Color? barrierColor,
    Color? backgroundColor,
    double? radius,
    Future<bool> Function()? onWillPop,
    required Widget child,
  }) {
    return showDialog(
      context: this,
      barrierDismissible: canDismiss,
      barrierColor: barrierColor,
      builder: (context) => WillPopScope(
        onWillPop: onWillPop,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          clipBehavior: Clip.hardEdge,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius ?? 8.r),
          ),
          content: WillPopScope(
            onWillPop: () async => canPhysicalBack,
            child: Container(
              width: 300.w,
              color: Colors.transparent,
              height: height ?? 400.h,
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  // void showNotificationDialog({
  //   String? title,
  //   required String message,
  //   Widget? content,
  //   Widget? cancleWidget,
  //   String? action,
  //   MessageNotificationType? type,
  //   Function()? ontap,
  //   Color? themeColor,
  // }) {
  //   showDialog(
  //     context: this,
  //     builder: (BuildContext childContext) {
  //       return AlertDialog(
  //         title: title != null
  //             ? Row(
  //                 children: [
  //                   Text(
  //                     title,
  //                     style: text16.medium
  //                         .withColor(themeColor ?? AppColors.primary)
  //                         .lSpacing04,
  //                   ),
  //                   if (type != null) ...[
  //                     width(width: 4),
  //                     if (type == MessageNotificationType.error)
  //                       Icon(
  //                         CupertinoIcons.xmark_circle,
  //                         color: AppColors.scarlet,
  //                         size: 20.sp,
  //                       )
  //                     else if (type == MessageNotificationType.success)
  //                       Icon(
  //                         CupertinoIcons.check_mark_circled,
  //                         color: AppColors.green,
  //                         size: 20.sp,
  //                       )
  //                     else
  //                       Container(),
  //                   ],
  //                 ],
  //               )
  //             : null,
  //         content: content ??
  //             Text(
  //               message,
  //               style: (title == null ? text14 : text12)
  //                   .copyWith(
  //                     color: AppColors.gray4B,
  //                     height: 1.38,
  //                   )
  //                   .lSpacing04,
  //             ),
  //         actionsPadding:
  //             EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 12.w),
  //         contentPadding:
  //             EdgeInsets.symmetric(vertical: 12.w, horizontal: 24.w),
  //         actions: <Widget>[
  //           cancleWidget ??
  //               CustomButtonWidget(
  //                 onTap: () => childContext.navigator.pop(),
  //                 width: 80.w,
  //                 height: 32.h,
  //                 radius: 4.r,
  //                 borderColor: AppColors.primary,
  //                 color: action == null ? AppColors.primary : AppColors.white,
  //                 boxShadows: const [],
  //                 child: Center(
  //                   child: Text(
  //                     lang.cancel,
  //                     style: text12.medium
  //                         .withColor(
  //                           action == null
  //                               ? AppColors.white
  //                               : AppColors.primary,
  //                         )
  //                         .lSpacing04,
  //                   ),
  //                 ),
  //               ),
  //           if (action != null)
  //             CustomButtonWidget(
  //               onTap: () {
  //                 if (ontap != null) ontap();
  //                 childContext.navigator.pop();
  //               },
  //               width: 80.w,
  //               height: 32.h,
  //               radius: 5.r,
  //               borderColor: themeColor ?? AppColors.primary,
  //               color: themeColor != null ? AppColors.white : null,
  //               boxShadows: const [],
  //               child: Center(
  //                 child: Text(
  //                   action,
  //                   style: text12.medium
  //                       .withColor(
  //                         themeColor ?? AppColors.white,
  //                       )
  //                       .lSpacing04,
  //                 ),
  //               ),
  //             ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void showBottomSheet({required Widget child}) {
    showModalBottomSheet(
      context: this,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      builder: (_) => child,
    );
  }

  void showLoading({String? message}) {
    if (_loadingDialog == null) {
      _loadingDialog = LoadingDialog(message: message);
      showDialog<dynamic>(
        context: this,
        builder: (_) => WillPopScope(
          child: _loadingDialog!,
          onWillPop: () {
            return Future<bool>.value(false);
          },
        ),
        barrierDismissible: false,
      );
    }
  }

  void hideLoading() {
    if (_loadingDialog == null) return;
    navigator.pop();
    _loadingDialog = null;
  }
}
