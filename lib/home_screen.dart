import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wolcg_qr_code/bloc/app/app_cubit.dart';
import 'package:wolcg_qr_code/bloc/checkin/checkin_cubit.dart';
import 'package:wolcg_qr_code/data/models/event.dart';
import 'package:wolcg_qr_code/di/dependency_injection.dart';
import 'package:wolcg_qr_code/qr_code_scanner/qr_code_scanner_screen.dart';
import 'package:wolcg_qr_code/res/colors.dart';
import 'package:wolcg_qr_code/res/theme.dart';
import 'package:wolcg_qr_code/utils/extension/build_context.dart';
import 'package:wolcg_qr_code/utils/widgets/loading_dialog.dart';

class AttendanceHomePage extends StatefulWidget {
  const AttendanceHomePage({super.key});

  @override
  State<AttendanceHomePage> createState() => _AttendanceHomePageState();
}

class _AttendanceHomePageState extends State<AttendanceHomePage> {
  final CheckInCubit _checkInCubit = di<CheckInCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 20.w,
        leading: Container(),
        title: Text(
          "Sự kiện",
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: Colors.white),
        ),
      ),
      body: SizedBox(
        width: 1.sw,
        child: FutureBuilder<List<Event>>(
          future: _checkInCubit.getEvents(),
          builder: (_, snaps) {
            if (snaps.connectionState == ConnectionState.waiting) {
              return SizedBox(
                width: 1.sw,
                child: const Center(
                  child: LoadingDialog(
                    message: "Đang tải...",
                  ),
                ),
              );
            }
            if (snaps.hasData && snaps.data!.isNotEmpty) {
              final List<Event> events = snaps.data!;
              return SingleChildScrollView(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    events.length,
                    (index) => Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.black12,
                          ),
                        ),
                      ),
                      child: ListTile(
                        onTap: () {
                          context.navigator.push(
                            MaterialPageRoute(
                              builder: (context) => QRCodeScannerScreen(
                                eventId: events[index].id,
                              ),
                            ),
                          );
                        },
                        visualDensity:
                            const VisualDensity(horizontal: 4, vertical: 4),
                        leading: Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorPrimary.withOpacity(0.1),
                          ),
                          child: Text(
                            "${index + 1}",
                            style: text12.bold.tColorPrimary,
                          ),
                        ),
                        title: Text(events[index].name, style: text16),
                      ),
                    ),
                  ),
                ),
              );
            }
            return SizedBox(
              width: 1.sw,
              child: const Center(
                child: LoadingDialog(
                  message: "Đang tải...",
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 150.w,
        height: 48.h,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {});
          },
          tooltip: 'Increment',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.replay_outlined),
              SizedBox(width: 4.w),
              Text("Làm mới sự kiện", style: text12.tColorWhite.bold)
            ],
          ),
        ),
      ),
    );
  }
}
