import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/widgets/custom_scaffold_messenger.dart';
import 'package:glowguide/features/notifications/domain/entities/notification_entity.dart';
import 'package:glowguide/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:glowguide/features/notifications/presentation/cubit/notifications_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationsCubit()..getCurrentUserNotifications(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notifications", style: AppTextStyles.heading01SemiBold),
          backgroundColor: Colors.white,
        ),
        body: BlocConsumer<NotificationsCubit, NotificationsStates>(
          listener: (context, state) {
            if (state is GetNotificationsFailed) {
              CustomScaffoldMessenger().showFail(state.errMessage);
            }
          },
          builder: (context, state) {
            if (state is GetNotificationsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is GetNotificationsFailed) {
              return const Center(
                child: Text("Something went wrong. Please try again."),
              );
            }

            if (state is GetNotificationsSuccessfully) {
              if (state.notifications.isEmpty) {
                return const Center(child: Text("No notifications available"));
              }

              return SafeArea(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await context
                        .read<NotificationsCubit>()
                        .getCurrentUserNotifications();
                  },
                  child: ListView.separated(
                    padding: EdgeInsets.all(16.w),
                    itemCount: state.notifications.length,
                    itemBuilder: (context, index) {
                      return _notification(state.notifications[index]);
                    },
                    separatorBuilder: (context, index) =>
                        SizedBox(height: 16.h),
                  ),
                ),
              );
            }

            return const Center(child: Text("Loading..."));
          },
        ),
      ),
    );
  }

  Widget _notification(NotificationEntity notification) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 25.r,
          backgroundColor: Colors.white,
          backgroundImage: const AssetImage(AppAssets.userPlaceHolder),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.notificationContent,
                style: AppTextStyles.paragraph02SemiBold,
              ),
              SizedBox(height: 6.h),
              Text(
                _formatDate(notification.createdAt),
                style: AppTextStyles.footerRegular,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: const Divider(thickness: 1, color: Color(0xFFD0D5DD)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat("hh:mm a").format(date);
  }
}
