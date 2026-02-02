import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../settings/presentation/cubit/settings_cubit.dart';
// import 'country_selection_screen.dart';
// import 'language_selection_screen.dart';
// import 'personal_info_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 30),
              
              // Profile Image
              Stack(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryRed,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  if (state is SettingsLoaded) {
                    return Text(
                      state.userInfo['name']?.isEmpty ?? true
                          ? 'User Name'
                          : state.userInfo['name']!,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                  return const Text('User Name');
                },
              ),
              
              const SizedBox(height: 40),
              const Text(
                'Profile Info',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 16),

              // Personal Info
              _buildMenuItem(
                context,
                icon: Icons.person_outline,
                title: 'Personal Info',
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const PersonalInfoScreen(),
                  //   ),
                  // );
                },
              ),

              // Language
              _buildMenuItem(
                context,
                icon: Icons.language,
                title: 'Language',
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const LanguageSelectionScreen(),
                  //   ),
                  // );
                },
              ),

              // Country
              _buildMenuItem(
                context,
                icon: Icons.flag,
                title: 'Country',
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => const CountrySelectionScreen(),
                  //   ),
                  // );
                },
              ),

              // Terms & Conditions
              _buildMenuItem(
                context,
                icon: Icons.description_outlined,
                title: 'Terms & Conditions',
                onTap: () {
                  // Navigate to terms screen
                },
              ),

              const Spacer(),

              // Logout
              _buildMenuItem(
                context,
                icon: Icons.logout,
                title: 'Logout',
                iconColor: AppColors.primaryRed,
                titleColor: AppColors.primaryRed,
                onTap: () {
                  // Handle logout
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
    Color? titleColor,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: iconColor),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: titleColor,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}