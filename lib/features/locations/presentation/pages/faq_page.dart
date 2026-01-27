import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> glowGuideFaq = [
      {
        "q": "What is GlowGuide?",
        "a":
            "GlowGuide is a platform that helps people find trusted beauty clinics, doctors, and treatments based on real experiences from verified users.",
      },
      {
        "q": "Who can use GlowGuide?",
        "a":
            "Anyone interested in beauty treatments, facials, skincare, laser, injectables or aesthetic procedures can use the app. It is not gender-specific.",
      },
      {
        "q": "How do I create an account?",
        "a":
            "Sign up with your email or phone number, complete a quick verification, and your profile will be active.",
      },
      {
        "q": "Why do I need verification?",
        "a":
            "Verification prevents fake accounts, reduces misleading reviews, and keeps the platform transparent and credible.",
      },
      {
        "q": "How do reviews work on GlowGuide?",
        "a":
            "Users share honest experiences after receiving a treatment. Reviews include service quality, results, cost impressions and overall satisfaction.",
      },
      {
        "q": "Are clinics verified?",
        "a":
            "Yes. Clinic profiles undergo a verification check to ensure they are legitimate and aligned with GlowGuide quality standards.",
      },
      {
        "q": "Can I leave a review without visiting a clinic?",
        "a":
            "No. Reviews must reflect real visits or treatments to maintain authenticity.",
      },
      {
        "q": "Why might a review be declined?",
        "a":
            "If it lacks clarity, contains promotional intent, or does not align with our review standards.",
      },
      {
        "q": "Can clinics reply to reviews?",
        "a":
            "Yes. Clinics may respond to reviews to clarify details or address feedback.",
      },
      {
        "q": "Is my information private?",
        "a":
            "Yes. Personal data is encrypted and never displayed publicly unless you choose to include it.",
      },
      {
        "q": "How do I report a review or profile?",
        "a":
            "You can report any review or clinic profile directly from the app. Reports are reviewed carefully.",
      },
      {
        "q": "Do I need to pay to use GlowGuide?",
        "a":
            "GlowGuide is free to use. Additional professional tools may be added later.",
      },
      {
        "q": "How can a clinic claim its profile?",
        "a":
            "Clinics can request ownership through the Claim Profile option or by contacting support for verification.",
      },
      {
        "q": "How do I reach support?",
        "a":
            "You can contact support anytime through the Support section inside the app.",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("FAQs", style: AppTextStyles.paragraph01SemiBold),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                SizedBox(height: 24.h),
                _faqSection(),
                SizedBox(height: 16.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: glowGuideFaq.map((faq) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 6),
                            ],
                          ),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              tilePadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                              childrenPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                              ),
                              title: Text(
                                faq["q"]!,
                                style: AppTextStyles.paragraph02SemiBold,
                              ),
                              iconColor: AppColors.primary05,
                              collapsedIconColor: AppColors.primary05.withAlpha(
                                200,
                              ),
                              children: [
                                Text(
                                  faq["a"]!,
                                  style: AppTextStyles.paragraph02Regular,
                                ),
                                SizedBox(height: 16.h),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding _faqSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "FAQ",
            style: AppTextStyles.paragraph01SemiBold.copyWith(
              color: AppColors.primary05,
            ),
          ),
          SizedBox(height: 8.h),
          Container(width: 32.w, height: 2.h, color: const Color(0xFFF8CF2C)),
        ],
      ),
    );
  }

  Container _header() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
      color: AppColors.primary05,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            "Help Center",
            style: AppTextStyles.heading01SemiBold.copyWith(
              color: Colors.white,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "We are glad having you here looking for the answer. As our team hardly working on the product, feel free to ask any questions. ",
            textAlign: TextAlign.center,
            style: AppTextStyles.paragraph02Regular.copyWith(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
