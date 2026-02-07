import 'package:glowguide/core/constants/app_assets.dart';
import 'package:glowguide/core/constants/app_colors.dart';
import 'package:glowguide/core/constants/app_text_styles.dart';
import 'package:glowguide/core/services/send_email_helper.dart';
import 'package:glowguide/core/utils/validators.dart';
import 'package:glowguide/core/widgets/custom_input_field.dart';
import 'package:glowguide/features/auth/presentation/widgets/phone_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  State<ContactUsPage> createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    if (!Validators.isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid email")),
      );
      return;
    }

    try {
      await sendEmail(
        toEmail: 'GlowGuideSup@gmail.com',
        subject: "Message from $name",
        body: "Email: $email\nPhone: $phone\n\nMessage:\n$message",
      );
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message sent successfully!")),
      );

      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _messageController.clear();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to send message.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Contact Us", style: AppTextStyles.paragraph01SemiBold),
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                AppAssets.contactUsBackground,
                width: double.infinity,
                height: 175.h,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 24.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Contact Us",
                      style: AppTextStyles.paragraph01SemiBold.copyWith(
                        color: AppColors.primary05,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 32.w,
                      height: 2.h,
                      color: const Color(0xFFF8CF2C),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  children: [
                    CustomInputField(
                      label: "Owner's Name",
                      hint: "Mustafa Emad",
                      controller: _nameController,
                    ),
                    SizedBox(height: 16.h),
                    CustomInputField(
                      label: "Email",
                      hint: "mustafa@gmail.com",
                      controller: _emailController,
                    ),
                    SizedBox(height: 16.h),
                    PhoneInputField(
                      controller: _phoneController,
                      label: "Phone Number",
                    ),
                    SizedBox(height: 16.h),
                    CustomInputField(
                      label: "Your Message",
                      hint: "Enter your message here...",
                      controller: _messageController,
                      maxLines: 5,
                    ),
                    SizedBox(height: 24.h),
                    const Center(child: Text("GlowGuideSup@gmail.com")),
                    SizedBox(height: 16.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sendMessage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary05,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          "Send A Message",
                          style: AppTextStyles.paragraph02Regular.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24.h),
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
