import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/user_provider.dart';
import '../../../../core/config/app_config.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();

  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = context.read<AuthProvider>().currentUser;
      print(user);
      if (user != null) {
        _nameController.text = user.fullName;
        _usernameController.text = user.username ?? '';
        _emailController.text = user.email;
        setState(() {});
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final userProvider = context.read<UserProvider>();
      final authProvider = context.read<AuthProvider>();

      String? profileImageUrl;

      // 1. Upload image if picked
      if (_image != null) {
        profileImageUrl = await userProvider.uploadImage(XFile(_image!.path));
        if (profileImageUrl == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  userProvider.errorMessage ?? 'Failed to upload image',
                ),
              ),
            );
          }
          return;
        }
      }

      final name = _nameController.text.trim();
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();

      // 2. Update profile
      final success = await userProvider.updateProfile(
        name: name.isNotEmpty ? name : null,
        username: username.isNotEmpty ? username : null,
        email: email.isNotEmpty ? email : null,
        profileImage: profileImageUrl,
      );

      if (success && mounted) {
        // Update local auth provider user as well
        if (userProvider.currentUser != null) {
          authProvider.setCurrentUser(userProvider.currentUser!);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile Updated Successfully')),
        );
        Navigator.pop(context);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              userProvider.errorMessage ?? 'Failed to update profile',
            ),
          ),
        );
      }
    }
  }

  void _navigateToChangePassword() {
    Navigator.pushNamed(
      context,
      '/change-password',
    ); // Route will be added in app_routes.dart
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/whiteBackIcon.png',
            width: 24,
            height: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'EDIT PROFILE',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        top: false,
        left: false,
        right: false,
        bottom: true,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Profile Image
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Consumer<AuthProvider>(
                            builder: (context, auth, _) {
                              final user = auth.currentUser;
                              if (_image != null) {
                                return Image.file(_image!, fit: BoxFit.cover);
                              } else if (user?.profileImage != null &&
                                  user!.profileImage!.isNotEmpty) {
                                final baseUrl = AppConfig.apiBaseUrl.replaceAll(
                                  '/api/v1',
                                  '',
                                );
                                return Image.network(
                                  user.profileImage!.startsWith('http')
                                      ? user.profileImage!
                                      : '$baseUrl/${user.profileImage}',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                        'assets/images/userProfilePhoto.png',
                                        fit: BoxFit.cover,
                                      ),
                                );
                              }
                              return Image.asset(
                                'assets/images/userProfilePhoto.png',
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickImage,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                const Text(
                  'Full Name',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter your name' : null,
                  decoration: _inputDecoration('Jack Smiths'),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Username',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _usernameController,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a username' : null,
                  decoration: _inputDecoration('Jack'),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Email ID',
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Please enter your email';
                    if (!value.contains('@'))
                      return 'Please enter a valid email';
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: _inputDecoration('jacksmith123@gmail.com'),
                ),

                const SizedBox(height: 60),

                // Save Button
                Consumer<UserProvider>(
                  builder: (context, userProvider, _) {
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: userProvider.isUpdating
                            ? null
                            : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: userProvider.isUpdating
                                ? LinearGradient(
                                    colors: [Colors.grey, Colors.grey[400]!],
                                  )
                                : AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: userProvider.isUpdating
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Save',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Change Password Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _navigateToChangePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 5,
                    ),
                    child: const Text(
                      'Change Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 0.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.grey, width: 0.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(
          color: AppColors.primaryOrange,
          width: 1.0,
        ),
      ),
    );
  }
}
