
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MenuButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isPrimary;

  const MenuButton({super.key, 
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280.w,
        height: isPrimary ? 70.h : 60.h,
        decoration: BoxDecoration(
          color: isPrimary
              ? color.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: isPrimary ? 0.8 : 0.3),
            width: isPrimary ? 2 : 1.5,
          ),
          boxShadow: [
            if (isPrimary)
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 15,
                spreadRadius: 2,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              Positioned(
                right: -10,
                top: -10,
                child: Icon(
                  icon,
                  size: 60,
                  color: color.withValues(alpha: 0.1),
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: color, size: isPrimary ? 28 : 22),
                    const SizedBox(width: 12),
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isPrimary ? 20.sp : 16.sp,
                        fontWeight: isPrimary
                            ? FontWeight.bold
                            : FontWeight.w500,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}