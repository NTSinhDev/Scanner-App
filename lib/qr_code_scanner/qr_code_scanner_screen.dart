import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:wolcg_qr_code/bloc/checkin/checkin_cubit.dart';
import 'package:wolcg_qr_code/di/dependency_injection.dart';
import 'package:wolcg_qr_code/res/colors.dart';
import 'package:wolcg_qr_code/res/theme.dart';
import 'package:wolcg_qr_code/utils/extension/build_context.dart';
import 'package:wolcg_qr_code/utils/widgets/custom_button.dart';
import 'package:wolcg_qr_code/utils/widgets/custom_modal_bottom_sheet.dart';
import 'package:wolcg_qr_code/utils/widgets/system_ui_overlay.dart';

class QRCodeScannerScreen extends StatefulWidget {
  const QRCodeScannerScreen({Key? key, required this.eventId})
      : super(key: key);
  final int eventId;
  @override
  State<StatefulWidget> createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final CheckInCubit _checkCubit = di<CheckInCubit>();
  QRViewController? _controller;
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  final Color _foregroundBGColor = Colors.black45;
  final Color _foregroundColor = Colors.white;
  bool _showNotificationNoPermission = false;

  bool isTurnOnFlash = false;
  bool isFrontCamera = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      _controller!.pauseCamera();
    } else if (Platform.isIOS) {
      _controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SystemUIOverlayWidget(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      child: BlocListener<CheckInCubit, CheckInState>(
        bloc: _checkCubit,
        listener: (_, state) {
          if (state is WaitingCheckinState) {
            context.showLoading(message: "Đang kiểm tra user...");
          } else if (state is CheckinSuccessState) {
            context.hideLoading();
            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  backgroundColor: Colors.white,
                  title: Row(
                    children: [
                      const Icon(Icons.check, color: Colors.green),
                      SizedBox(width: 4.w),
                      Text(
                        "Thông báo",
                        style: text14.bold.withColor(Colors.green),
                      ),
                    ],
                  ),
                  content: Text(
                    "${state.username} được điểm danh thành công!",
                    style: text16.h13,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.navigator.pop();
                        _controller?.resumeCamera();
                      },
                      child: Text(
                        "Đóng",
                        style: text12.withColor(Colors.black),
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (state is CheckinFailedState) {
            if (state.error.status == -1) {
              context.hideLoading();
              showDialog(
                context: context,
                builder: (dialogContext) {
                  return AlertDialog(
                    title:
                        Text("Mất kết nối", style: text14.bold.tColorPrimary),
                    content: Text(
                      "Không thể kết nối đến server. Vui lòng kiểm tra lại!",
                      style: text16.h13,
                    ),
                  );
                },
              );
              return;
            }
            String message = "";
            if (state.error.message == 'Not found user') {
              message = "${state.username} Không có trong danh sách sự kiện.";
            } else if (state.error.message == 'Already checked in') {
              message = "${state.username} đã được điểm danh!";
            } else if (state.error.message == 'Not found event') {
              message = "Không tìm thấy sự kiện";
            } else if (state.error.message == 'Not found user event') {
              message = "Người dùng không đáp ứng đủ các yêu cầu về điều kiện";
            } else {
              message = state.error.message;
            }
            context.hideLoading();
            showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: Row(
                    children: [
                      const Icon(Icons.clear, color: Colors.red),
                      SizedBox(width: 4.w),
                      Text("Thông báo", style: text14.bold.tColorPrimary)
                    ],
                  ),
                  content: Text(
                    message,
                    style: text16.withColor(Colors.black).h13,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        context.navigator.pop();
                        _controller?.resumeCamera();
                      },
                      child: Text(
                        "Đóng",
                        style: text12,
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Scaffold(
          body: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height,
            child: Stack(
              children: [
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  child: _buildQrView(context),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width,
                  height: MediaQuery.sizeOf(context).height,
                  padding:
                      EdgeInsets.symmetric(vertical: 40.h, horizontal: 20.w),
                  child: Column(
                    children: [
                      _topScreenComp(context),
                      const Spacer(flex: 8),
                      Text(
                        "Hướng camera của bạn về phía mã QR. Hãy đảm báo QR nằm trong khung!",
                        style: text14
                            .withColor(_foregroundColor)
                            .lSpacing(0.5)
                            .h13,
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(flex: 36),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topScreenComp(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => context.navigator.pop(),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _foregroundBGColor,
            ),
            child: Icon(
              Icons.clear,
              color: _foregroundColor,
              size: 24.sp,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.r),
            color: _foregroundBGColor,
          ),
          child: Text(
            "Quét mã QR",
            style: text16.withColor(_foregroundColor).lSpacing(0.5).bold,
          ),
        ),
        InkWell(
          onTap: () => context.showBottomSheet(
            child: _extensionView(),
          ),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _foregroundBGColor,
            ),
            child: Icon(
              CupertinoIcons.ellipsis_vertical,
              color: _foregroundColor,
              size: 22.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _extensionView() {
    return LayoutModalBottomSheet.basic(
      height: 150.h,
      children: [
        ListTile(
          onTap: () async {
            await _controller?.toggleFlash();
            setState(() {
              isTurnOnFlash = !isTurnOnFlash;
            });
            if (mounted) {
              context.navigator.pop();
            }
          },
          leading: Icon(
            isTurnOnFlash ? Icons.flash_off : Icons.flash_on,
            color: isTurnOnFlash ? null : Colors.yellow,
          ),
          title: Text(
            isTurnOnFlash ? "Tắt flash" : "Bật flash",
            style: text15.lSpacing(0.5),
          ),
          subtitle: isTurnOnFlash
              ? null
              : Text(
                  "Bật flash để quét mã trong điều kiện thiếu sáng",
                  style:
                      text12.lSpacing(0.5).withColor(const Color(0xFF848484)),
                ),
          visualDensity: const VisualDensity(horizontal: 0.0, vertical: 0.0),
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
          titleAlignment: ListTileTitleAlignment.center,
        ),
        ListTile(
          onTap: () async {
            await _controller?.flipCamera();
            setState(() {
              isFrontCamera = !isFrontCamera;
            });
            if (mounted) {
              context.navigator.pop();
            }
          },
          leading: Icon(Icons.cameraswitch, color: colorPrimary),
          title: Text(
            "Xoay camera",
            style: text15.lSpacing(0.5),
          ),
          subtitle: Text(
            isFrontCamera
                ? "Xoay camera về phía sau"
                : "Xoay camera về phía trước",
            style: text12.lSpacing(0.5).withColor(const Color(0xFF848484)),
          ),
          visualDensity: const VisualDensity(horizontal: 0.0, vertical: 0.0),
          contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
          titleAlignment: ListTileTitleAlignment.center,
        ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    return QRView(
      key: _qrKey,
      onQRViewCreated: (QRViewController controller) {
        setState(() => _controller = controller);
        controller.scannedDataStream.listen(
          (Barcode scanData) => _onScannerQRCodeHasResult(scanData),
        );
      },
      onPermissionSet: (qrViewController, hasPermission) {
        if (!hasPermission && !_showNotificationNoPermission) {
          _showNotificationNoPermission = true;
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              surfaceTintColor: Colors.white,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.r),
              ),
              title: Text("Lỗi QR-Code", style: text14.bold),
              content: Text(
                "Cho phép ứng dụng truy cập camera để sử dụng tính năng quét mã QR?",
                style: text12,
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: text16.lSpacing(0.3).tColorWhite,
                  ),
                  child: const Text("Từ chối"),
                  onPressed: () {
                    context.navigator.popUntil((route) => route.isFirst);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: text16.lSpacing(0.3).tColorWhite,
                  ),
                  child: const Text("Cho phép"),
                  onPressed: () async {
                    openAppSettings().then((status) {
                      if (status) {
                        context.navigator.pop();
                      } else {}
                    });
                  },
                ),
              ],
            ),
          );
        }
      },
      overlay: QrScannerOverlayShape(
        borderColor: colorPrimaryBlue,
        borderRadius: 10.r,
        borderLength: 56.w,
        borderWidth: 12.w,
        cutOutSize: 300.w,
      ),
    );
  }

  Future _onScannerQRCodeHasResult(Barcode scanData) async {
    await _controller?.pauseCamera();
    if (!mounted) return false;

    final String? inviteLink = scanData.code;

    if (inviteLink != null) {
      try {
        final String username = inviteLink.split("?")[1].split("=")[1];
        _checkCubit.checkin(id: widget.eventId, username: username);
      } catch (e) {
        _checkCubit.checkin(id: widget.eventId, username: "");
      }
    }
  }

  void _snanCodeFailed(BuildContext context, String message) {
    context.showCustomDialog(
      height: 164.h,
      barrierColor: Colors.black38,
      canDismiss: false,
      backgroundColor: Colors.white,
      child: Stack(
        children: [
          // _Background(top: -25.h, left: -25.w, size: 136.w, opacity: 0.1),
          // _Background(top: 4.h, left: 120.w, size: 30.w, opacity: 0.15),
          // _Background(top: 1.h, left: 105.w, size: 16.w, opacity: 0.15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                Text(
                  "Lỗi QR-Code",
                  style: text16.semiBold.tColorPrimary,
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 14.h),
                Text(
                  message,
                  style: text14.tColorPrimary.h13.lSpacing(0.4),
                  textAlign: TextAlign.start,
                ),
                SizedBox(height: 20.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomButtonWidget(
                      onTap: () => context.navigator.pop(),
                      radius: 48.r,
                      color: Colors.white,
                      width: 120.w,
                      height: 40.h,
                      boxShadows: const [],
                      child: Center(
                        child: Text(
                          "Hủy",
                          style: text14.semiBold.tColorPrimary,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    CustomButtonWidget(
                      onTap: () async {
                        await _controller?.resumeCamera().then((value) {
                          if (mounted) {
                            context.navigator.pop();
                          }
                        });
                      },
                      radius: 48.r,
                      width: 120.w,
                      height: 40.h,
                      borderColor: colorPrimary,
                      color: colorPrimary,
                      boxShadows: const [],
                      child: Center(
                        child: Text(
                          "Chấp nhận",
                          style: text14.semiBold.tColorWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () => context.navigator.pop(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: colorPrimary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6.r,
                      color: colorPrimary.withOpacity(0.75),
                      offset: const Offset(2.5, 2.5),
                    )
                  ],
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class _Background extends StatelessWidget {
  final double? left;
  final double? top;
  final double size;
  final double opacity;
  const _Background({
    required this.size,
    required this.opacity,
    this.left,
    this.top,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: colorPrimary.withOpacity(opacity),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
