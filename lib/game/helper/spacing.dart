import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const double kHorizontalSpaceSmall = 8.0;
const double kHorizontalSpaceMedium = 16.0;
const double kHorizontalSpaceLarge = 24.0;

const double kVerticalSpaceSmall = 8.0;
const double kVerticalSpaceMedium = 16.0;
const double kVerticalSpaceLarge = 24.0;

SizedBox horizontalSpace(double width) => SizedBox(width: width.w);

SizedBox verticalSpace(double height) => SizedBox(height: height.h);

double sizeOfWidth(double width, BuildContext context) {
  return MediaQuery.sizeOf(context).width * width;
}

double sizeOfHeight(double height, BuildContext context) {
  return MediaQuery.sizeOf(context).height * height;
}
