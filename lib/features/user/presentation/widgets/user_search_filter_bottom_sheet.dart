import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> showFilterBottomSheet({
  required BuildContext context,
  Function(List<String>)? onCategorySelected,
  Function(List<int>)? onRatingSelected,
  VoidCallback? onReset,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: 8.h,
          left: 16.w,
          right: 16.w,
          bottom: 60.h,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBEBEB),
                  borderRadius: BorderRadius.circular(1000),
                ),
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filter",
                    style: AppTextStyles.paragraph01Regular.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (onReset != null) onReset();
                    },
                    child: Text(
                      "Reset Filter",
                      style: AppTextStyles.paragraph02SemiBold.copyWith(
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primary05,
                        color: AppColors.primary05,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Categories(onSelected: onCategorySelected),
              SizedBox(height: 24.h),
              Ratings(onSelected: onRatingSelected),
              SizedBox(height: 44.h),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Confirm"),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class Categories extends StatefulWidget {
  final Function(List<String>)? onSelected;

  const Categories({super.key, this.onSelected});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  final List<Map<String, String>> categories = [
    {"code": "SC", "name": "SkinCare"},
    {"code": "HC", "name": "HairCut"},
    {"code": "MK", "name": "Makeup"},
    {"code": "MS", "name": "Massage"},
    {"code": "NL", "name": "Nails"},
  ];

  final List<int> _selectedItems = [];

  void _updateSelection() {
    final selectedCodes =
        _selectedItems.map((index) => categories[index]["code"]!).toList();
    if (widget.onSelected != null) {
      widget.onSelected!(selectedCodes);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Category",
          style: AppTextStyles.paragraph02Regular.copyWith(
            color: const Color(0xFF0D0F11),
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(categories.length, (index) {
            final isSelected = _selectedItems.contains(index);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedItems.remove(index);
                  } else {
                    _selectedItems.add(index);
                  }
                  _updateSelection();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary05 : AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary05),
                ),
                child: Text(
                  categories[index]["name"]!,
                  style: AppTextStyles.paragraph02Regular.copyWith(
                    color: isSelected ? AppColors.white : AppColors.primary05,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class Ratings extends StatefulWidget {
  final Function(List<int>)? onSelected;

  const Ratings({super.key, this.onSelected});

  @override
  State<Ratings> createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {
  final List<String> ratings = ["1", "2", "3", "4", "5"];
  final List<int> _selectedItems = [];

  void _updateSelection() {
    if (widget.onSelected != null) {
      widget.onSelected!(_selectedItems);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Review",
          style: AppTextStyles.paragraph02Regular.copyWith(
            color: const Color(0xFF0D0F11),
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: List.generate(ratings.length, (index) {
            final isSelected = _selectedItems.contains(index + 1);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    _selectedItems.remove(index + 1);
                  } else {
                    _selectedItems.add(index + 1);
                  }
                  _updateSelection();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary05 : AppColors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.primary05),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star_rounded, size: 20.r, color: Colors.amber),
                    SizedBox(width: 4.w),
                    Text(
                      ratings[index],
                      style: AppTextStyles.captionSemiBold.copyWith(
                        color: isSelected ? AppColors.white : AppColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
