import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppBarWithLogoWidget extends StatelessWidget {
  const AppBarWithLogoWidget({
    super.key,
    required this.text,
  });
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160.h,
      color: const Color(0xff202125),
      child: Padding(
        padding: EdgeInsets.only(left: 13.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10 .h),
            Image.asset("assets/pngs/logo.png"),
            SizedBox(height: 34.h),
            Text(
              text,
              style: TextStyle(
                color: const Color(0xffFFFFFF),
                fontWeight: FontWeight.bold,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
