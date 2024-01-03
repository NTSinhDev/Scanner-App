import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolcg_qr_code/bloc/app/app_cubit.dart';
import 'package:wolcg_qr_code/data/models/user.dart';
import 'package:wolcg_qr_code/res/colors.dart';
import 'package:wolcg_qr_code/res/theme.dart';
import 'package:wolcg_qr_code/utils/extension/build_context.dart';
import 'package:wolcg_qr_code/utils/widgets/system_ui_overlay.dart';

class NormalLoginScreen extends StatefulWidget {
  final AppCubit appCubit;
  const NormalLoginScreen({super.key, required this.appCubit});

  @override
  State<NormalLoginScreen> createState() => _NormalLoginScreenState();
}

class _NormalLoginScreenState extends State<NormalLoginScreen> {
  User? _user;

  @override
  Widget build(BuildContext context) {
    return SystemUIOverlayWidget(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      child: BlocListener<AppCubit, AppState>(
        bloc: widget.appCubit,
        listener: (_, state) {
          if (state is WaitingState) {
            context.showLoading();
          } else if (state is LoggedInState) {
            context.hideLoading();
          } else if (state is LoginFailedState) {
            context.hideLoading();
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                backgroundColor: Colors.white,
                title: Text("Đăng nhập", style: text14.bold),
                content: Text("Đăng nhập Thất bại", style: text12),
                actions: [
                  TextButton(
                    onPressed: () => context.navigator.pop(),
                    child: const Text("Đóng"),
                  ),
                ],
              ),
            );
          }
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: SizedBox(
              height: 1.sh,
              child: _bodyComp(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bodyComp(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(25.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200.w,
            height: 200.w,
            decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: const Offset(0, 4),
                blurRadius: 8.r,
              )
            ]),
            child: Image.asset("assets/images/logo.png", width: 200.w),
          ),
          SizedBox(height: 60.h),
          Text("Đăng nhập".toUpperCase(), style: text22.bold),
          

          InkWell(
            onTap: () async {
              await widget.appCubit.login(
                username: _user?.username ?? "",
                password: _user?.password ?? "",
              );
              // if (_env == null || _user == null) return;
            },
            child: Container(
              height: 48.h,
              width: 1.sw - 40.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.r),
                color: colorPrimary,
                border: Border.all(color: colorPrimary),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colorPrimary.withOpacity(0.2),
                    offset: const Offset(0.0, 4.0),
                    blurRadius: 4.r,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  "Đăng nhập".toUpperCase(),
                  style: text18.bold.lSpacing(0.5).withColor(Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
