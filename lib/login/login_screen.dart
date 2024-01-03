// ignore_for_file: constant_pattern_never_matches_value_type, camel_case_types
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolcg_qr_code/app/app_flavor_config.dart';
import 'package:wolcg_qr_code/bloc/app/app_cubit.dart';
import 'package:wolcg_qr_code/data/models/user.dart';
import 'package:wolcg_qr_code/res/colors.dart';
import 'package:wolcg_qr_code/res/theme.dart';
import 'package:wolcg_qr_code/utils/extension/build_context.dart';
import 'package:wolcg_qr_code/utils/widgets/system_ui_overlay.dart';

enum ENV_TYPE {
  staging,
  qc,
  production;

  static List<ENV_TYPE> get list {
    return [ENV_TYPE.staging, ENV_TYPE.qc, ENV_TYPE.production];
  }
}

class LoginScreen extends StatefulWidget {
  final AppCubit appCubit;
  const LoginScreen({super.key, required this.appCubit});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  User? _user;
  ENV_TYPE? _env;

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
          SizedBox(height: 28.h),
          Row(children: [Text("Môi trường", style: text16.bold)]),
          SizedBox(height: 10.h),
          PopupMenuButton<ENV_TYPE>(
            onSelected: (ENV_TYPE type) {
              _env = type;
              _changeENV(type);
              setState(() {});
            },
            initialValue: _env,
            constraints:
                BoxConstraints(maxWidth: 1.sw - 40.w, maxHeight: 320.h),
            padding: EdgeInsets.all(0.w),
            elevation: 2,
            position: PopupMenuPosition.under,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            tooltip: "Chọn tài khoản",
            color: Colors.white,
            splashRadius: 12.r,
            itemBuilder: (context) {
              List<ENV_TYPE> typeENVs = ENV_TYPE.list;
              return List.generate(
                typeENVs.length,
                (index) => PopupMenuItem<ENV_TYPE>(
                  height: 48.h,
                  value: typeENVs[index],
                  child: SizedBox(
                    width: 1.sw - 40.w,
                    child: Center(
                      child: Text(
                        "Môi trường ${typeENVs[index].name}",
                        style: text16.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    _env == null
                        ? "Chọn môi trường"
                        : "Môi trường ${_env?.name}",
                    style: _env != null
                        ? text16.bold
                        : text16.withColor(Colors.grey),
                  ),
                  const Spacer(),
                  const Icon(CupertinoIcons.chevron_down),
                ],
              ),
            ),
          ),
          SizedBox(height: 25.h),
          Row(children: [Text("Tài khoản", style: text16.bold)]),
          SizedBox(height: 10.h),
          PopupMenuButton<User>(
            onSelected: (User user) {
              _user = user;
              setState(() {});
            },
            initialValue: _user,
            constraints:
                BoxConstraints(maxWidth: 1.sw - 40.w, maxHeight: 320.h),
            padding: EdgeInsets.all(0.w),
            elevation: 2,
            position: PopupMenuPosition.under,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            tooltip: "Chọn tài khoản",
            color: Colors.white,
            splashRadius: 12.r,
            itemBuilder: (context) {
              List<User> users = User.listUser();
              return List.generate(
                users.length,
                (index) => PopupMenuItem<User>(
                  height: 48.h,
                  value: users[index],
                  child: SizedBox(
                    width: 1.sw - 40.w,
                    child: Center(
                      child: Text(
                        users[index].username,
                        style: text16.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    offset: const Offset(0.0, 2.0),
                    blurRadius: 4.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    _user?.username ?? "Chọn tài khoản đăng nhập",
                    style: _user != null
                        ? text16.bold
                        : text16.withColor(Colors.grey),
                  ),
                  const Spacer(),
                  const Icon(CupertinoIcons.chevron_down),
                ],
              ),
            ),
          ),
          SizedBox(height: 56.h),
          InkWell(
            onTap: () async {
              // if (_env == null || _user == null) return;
              await widget.appCubit.login(
                username: _user?.username ?? "adminsystem1",
                password: _user?.password ?? "123456a@",
              );
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

  _changeENV(ENV_TYPE type) {
    switch (type) {
      case ENV_TYPE.production:
        FlavorConfig(env: Flavor.production);
        break;
      case ENV_TYPE.qc:
        FlavorConfig(env: Flavor.qc);
        break;
      default:
        FlavorConfig(env: Flavor.staging);
    }
  }
}
