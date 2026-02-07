import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/features/clinics/domain/entities/clinic_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CategorySelector extends StatefulWidget {
  final List<CategoryEntity> categories;
  final Function(CategoryEntity?) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.onCategorySelected,
  });

  @override
  State<CategorySelector> createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  final List<String> categoriesAssets = [
    AppAssets.categoryHaircut,
    AppAssets.categorySkincare,
    AppAssets.categoryMakeup,
    AppAssets.categoryNails,
  ];

  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("By Category", style: AppTextStyles.paragraph02SemiBold),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(widget.categories.length, (index) {
              bool isSelected = selectedIndex == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = (selectedIndex == index) ? -1 : index;
                    });
                    widget.onCategorySelected(
                      selectedIndex != -1
                          ? widget.categories[selectedIndex]
                          : null,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF7CAC8E)
                          : const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8.r,
                          color: Colors.black12,
                          offset: Offset(0, 2.h),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          categoriesAssets[index],
                          width: 34,
                          height: 34,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          widget.categories[index].name,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.captionRegular.copyWith(
                            fontSize: 12,
                            color: isSelected
                                ? const Color(0xFFFFFFFF)
                                : const Color(0xFF78808B),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
