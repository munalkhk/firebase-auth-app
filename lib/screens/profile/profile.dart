import 'package:blog_app/providers/user_provider.dart';
import 'package:blog_app/screens/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  bool _isEditingName = false;
  bool _isEditingPhone = false;
  bool _isEditingLocation = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _updateField(String field, String value) async {
    if (value.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({field: value.trim()});

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$field updated successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update $field: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Widget _buildEditableField({
    required String label,
    required String value,
    required String fieldName,
    required TextEditingController controller,
    required bool isEditing,
    required VoidCallback onEdit,
    required VoidCallback onSave,
    required VoidCallback onCancel,
    bool isPhone = false,
  }) {
    controller.text = value;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isEditing ? Colors.blue : Colors.grey[300]!,
                  width: isEditing ? 2 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: isEditing
                          ? TextField(
                              controller: controller,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                              autofocus: true,
                            )
                          : Row(
                              children: [
                                if (isPhone) ...[
                                  const Text(
                                    '🇧🇷 ',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  const Text(
                                    '+55 ',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                                Expanded(
                                  child: Text(
                                    isPhone
                                        ? value.replaceAll('+55 ', '')
                                        : value,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF333333),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  if (isEditing)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: onSave,
                          icon: _isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.check, color: Colors.green),
                        ),
                        IconButton(
                          onPressed: onCancel,
                          icon: const Icon(Icons.close, color: Colors.red),
                        ),
                      ],
                    )
                  else
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit, color: Colors.blue),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (userData) {
        if (userData == null) {
          return const Center(child: Text('User not found'));
        }

        final username = (userData['username'] ?? 'User').toString();
        final email = (userData['email'] ?? '').toString();
        final profileImage = (userData['profileImage'] ?? '').toString();
        final phone = (userData['phone'] ?? '+55 (44) 12345-6789').toString();
        final location = (userData['location'] ?? 'Ivatuba - PR').toString();

        return Container(
          color: const Color(0xFFF8F9FA),
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 20),

                // Profile Picture Section
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.grey[300],
                        backgroundImage: profileImage.isNotEmpty
                            ? NetworkImage(profileImage)
                            : null,
                        child: profileImage.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[600],
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // Form Fields
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          const SizedBox(height: 24),

                          _buildEditableField(
                            label: 'Full Name',
                            value: username,
                            fieldName: 'username',
                            controller: _nameController,
                            isEditing: _isEditingName,
                            onEdit: () => setState(() => _isEditingName = true),
                            onSave: () {
                              _updateField('username', _nameController.text);
                              setState(() => _isEditingName = false);
                            },
                            onCancel: () =>
                                setState(() => _isEditingName = false),
                          ),

                          const SizedBox(height: 24),

                          // Email field (read-only)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Email Address',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        email,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF666666),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const Icon(
                                      Icons.lock,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          _buildEditableField(
                            label: 'Phone Number',
                            value: phone,
                            fieldName: 'phone',
                            controller: _phoneController,
                            isEditing: _isEditingPhone,
                            onEdit: () =>
                                setState(() => _isEditingPhone = true),
                            onSave: () {
                              _updateField(
                                'phone',
                                '+55 ${_phoneController.text}',
                              );
                              setState(() => _isEditingPhone = false);
                            },
                            onCancel: () =>
                                setState(() => _isEditingPhone = false),
                            isPhone: true,
                          ),

                          const SizedBox(height: 24),

                          _buildEditableField(
                            label: 'Location',
                            value: location,
                            fieldName: 'location',
                            controller: _locationController,
                            isEditing: _isEditingLocation,
                            onEdit: () =>
                                setState(() => _isEditingLocation = true),
                            onSave: () {
                              _updateField(
                                'location',
                                _locationController.text,
                              );
                              setState(() => _isEditingLocation = false);
                            },
                            onCancel: () =>
                                setState(() => _isEditingLocation = false),
                          ),

                          const SizedBox(height: 40),

                          // Logout Button
                          Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.red[400]!, Colors.red[600]!],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.red.withValues(alpha: 0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () async {
                                await FirebaseAuth.instance.signOut();
                                if (context.mounted) {
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginScreen(),
                                    ),
                                    (route) => false,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text(
                                'Sign Out',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}
