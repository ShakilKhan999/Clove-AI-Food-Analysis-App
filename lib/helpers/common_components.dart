import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../helpers/color_helper.dart';
import '../helpers/space_helper.dart';

class CommonComponents {
  Widget printText({
    required double fontSize,
    required String textData,
    required FontWeight fontWeight,
    Color color = Colors.white,
    int maxLine = 1,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Text(
      textData,
      textAlign: textAlign,
      maxLines: maxLine,
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.inter(
        textStyle: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: color,
        ),
      ),
    );
  }

  Widget commonButton({
    required text,
    required VoidCallback onPressed,
    bool disabled = false,
    Icon? icon,
    String? imagePath,
    double borderRadius = 8,
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.bold,
    double paddingVertical = 12,
    double paddingHorizontal = 24,
    Color color = ColorHelper.primaryColor,
    bool isLoading = false,
    Color borderColor = Colors.transparent,
    Color textColor = Colors.white,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: paddingVertical.h, horizontal: paddingHorizontal.w),
        decoration: BoxDecoration(
          color: disabled ? ColorHelper.greyColor : color,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: ColorHelper.whiteColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon ??
                        (imagePath != null
                            ? Image.asset(
                                imagePath,
                                height: 20.h,
                                width: 20.w,
                                color: const Color(0xffc4c4c4),
                              )
                            : const SizedBox()),
                    SpaceHelper.horizontalSpace5,
                    Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontSize: fontSize.sp,
                        fontWeight: fontWeight,
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget commonAddPhotoButton({
    required text,
    required VoidCallback onPressed,
    bool disabled = false,
    double borderRadius = 24,
    double fontSize = 16,
    Color color = const Color(0xFF004AAD),
    required bool isLoading,
  }) {
    return GestureDetector(
      onTap: disabled ? null : onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : Text(
                  text,
                  style: TextStyle(
                    color: color,
                    fontSize: fontSize.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }

  Widget commonTextField({
    required TextEditingController controller,
    required String labelText,
    Color labelColor = Colors.white,
    Color borderColor = ColorHelper.primaryColor,
    Color textColor = Colors.black,
    VoidCallback? onTap,
    int maxLine = 1,
    TextInputType keyboardType = TextInputType.text,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onPasswordVisibilityChanged,
  }) {
    return TextField(
      cursorColor: ColorHelper.primaryColor,
      maxLines: isPassword ? 1 : maxLine, // Limit max lines for password fields
      style: GoogleFonts.inter(
        color: textColor,
      ),
      keyboardType: keyboardType,
      controller: controller,
      obscureText: isPassword && !isPasswordVisible,
      readOnly: onTap != null,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: labelColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: borderColor),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: labelColor,
          ),
          onPressed: onPasswordVisibilityChanged,
        )
            : null,
      ),
    );
  }


  Widget customTab(String text, IconData icon) {
    return Tab(
      height: 40.h,
      iconMargin: EdgeInsets.all(5.sp),
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon),
          SpaceHelper.verticalSpace3,
          Text(
            text,
            style: TextStyle(fontSize: 12.sp),
          ),
        ],
      ),
    );
  }

  Widget commonCard({
    required BuildContext context,
    required IconData icon,
    required String number,
    required String text,
    Color? iconColor,
    Color textColor = Colors.black,
    Color? cardColor,
    bool isDescription = false,
  }) {
    return SizedBox(
      child: Card(
        color: cardColor ?? ColorHelper.bgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              if (isDescription) ...[
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            icon,
                            color: iconColor ?? ColorHelper.primaryColor,
                            size: 20.w,
                          ),
                          SpaceHelper.horizontalSpace3,
                          CommonComponents().printText(
                            fontSize: 16,
                            textData: text,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                      SpaceHelper.verticalSpace10,
                      CommonComponents().printText(
                        fontSize: 14,
                        textData: number,
                        maxLine: 10,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Icon(
                        icon,
                        color: iconColor ?? ColorHelper.primaryColor,
                        size: 30.w,
                      ),
                    ),
                    SingleChildScrollView(
                      child: CommonComponents().printText(
                        fontSize: 18,
                        maxLine: 3,
                        textData: number.toString(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    CommonComponents().printText(
                      fontSize: 14,
                      textData: text,
                      fontWeight: FontWeight.normal,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceCard({required String name, required IconData icon}) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: ColorHelper.bottomNavigationbgColor,
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24.sp,
              color: ColorHelper.primaryColor,
            ),
            SpaceHelper.verticalSpace10,
            printText(
              fontSize: 12,
              textData: name,
              maxLine: 2,
              color: ColorHelper.whiteColor,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
      ),
    );
  }

  Widget commonDropdownMenu<T>({
    required BuildContext context,
    required List<DropdownMenuItem<T>> items,
    required T? value,
    required ValueChanged<T?> onChanged,
    String? hint,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorHelper.bgColor,
        border: Border.all(color: ColorHelper.searchButtonbgColor, width: 1.w),
      ),
      child: DropdownButton<T>(
        underline: Container(
          height: 1.h,
          color: ColorHelper.whiteColor,
        ),
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 10.w),
        icon: const Icon(
          Icons.arrow_drop_down_circle_outlined,
          color: ColorHelper.primaryColor,
        ),
        style: GoogleFonts.inter(
            color: ColorHelper.whiteColor,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500),
        dropdownColor: ColorHelper.bottomNavigationbgColor,
        isExpanded: true,
        value: value,
        onChanged: onChanged,
        hint: hint != null
            ? Text(
                hint,
                style: GoogleFonts.inter(color: ColorHelper.whiteColor),
              )
            : null,
        items: items,
      ),
    );
  }

  Widget richText({
    required String label,
    required String value,
    double labelFontSize = 16,
    double valueFontSize = 14,
    Color? labelColor,
    Color? valueColor,
    TextAlign textAlign = TextAlign.start,
    FontWeight labelFontWeight = FontWeight.w500,
    FontWeight valueFontWeight = FontWeight.w400,
  }) {
    return RichText(
      textAlign: textAlign,
      text: TextSpan(
        children: [
          TextSpan(
            text: '$label: ',
            style: GoogleFonts.inter(
              textStyle: TextStyle(
                fontWeight: labelFontWeight,
                fontSize: labelFontSize.sp,
                color: labelColor ?? ColorHelper.primaryColor,
              ),
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: valueColor ?? ColorHelper.whiteColor,
              fontSize: valueFontSize.sp,
              fontWeight: valueFontWeight,
            ),
          ),
        ],
      ),
    );
  }
}
