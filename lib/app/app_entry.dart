import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:wolcg_qr_code/bloc/app/app_cubit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolcg_qr_code/home_screen.dart';
import 'package:wolcg_qr_code/login/login_screen.dart';
import 'package:wolcg_qr_code/res/colors.dart';

class WOLCGAttendanceApp extends StatefulWidget {
  const WOLCGAttendanceApp({super.key});

  @override
  State<WOLCGAttendanceApp> createState() => _WOLCGAttendanceAppState();
}

class _WOLCGAttendanceAppState extends State<WOLCGAttendanceApp> {
  AppCubit get _appCubit => GetIt.I<AppCubit>();
  @override
  void dispose() {
    _appCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocProvider<AppCubit>(
          create: (_) => _appCubit,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'WOLCG Event',
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: colorPrimary,
              ),
              useMaterial3: true,
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: colorPrimary,
                foregroundColor: Colors.white,
              ),
            ),
            home: BlocBuilder<AppCubit, AppState>(
              bloc: _appCubit,
              builder: (_, state) {
                if (state is LoggedInState) {
                  return const AttendanceHomePage();
                }
                return LoginScreen(appCubit: _appCubit);
              },
            ),
          ),
        );
      },
    );
  }
}
