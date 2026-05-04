import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orbit/shared/widgets/primary_button.dart';
import 'package:orbit/features/auth/presentation/widgets/custom_text_field.dart';

class AdminPublishAnnouncementScreen extends StatefulWidget {
  const AdminPublishAnnouncementScreen({super.key});

  @override
  State<AdminPublishAnnouncementScreen> createState() => _AdminPublishAnnouncementScreenState();
}

class _AdminPublishAnnouncementScreenState extends State<AdminPublishAnnouncementScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _selectedCategory = 'Academic';
  File? _selectedImage;
  bool _isPublishing = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Media Attachment',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOptionItem(
                    icon: Icons.camera_alt_rounded,
                    label: 'Camera',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.camera);
                    },
                  ),
                  _buildOptionItem(
                    icon: Icons.photo_library_rounded,
                    label: 'Gallery',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionItem({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F6FA),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF0D6E53), size: 30),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF424242))),
        ],
      ),
    );
  }

  Future<void> _handlePublish() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both title and content')),
      );
      return;
    }

    setState(() => _isPublishing = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    if (mounted) {
      setState(() => _isPublishing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Announcement Published Successfully!'),
          backgroundColor: Color(0xFF0D6E53),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'ADMIN PANEL',
          style: TextStyle(color: Color(0xFF1A1A1A), fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 1.2),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Publish New Announcement',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0D6E53)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Fill in the details to notify all students.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 32),

            const Text('CATEGORY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF666666))),
            const SizedBox(height: 12),
            Row(
              children: ['Academic', 'Urgent', 'Event'].map((cat) {
                final isSelected = _selectedCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF0D6E53) : const Color(0xFFF3F6FA),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : const Color(0xFF666666),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            CustomTextField(hintText: 'Headline / Title', controller: _titleController),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write the announcement content here...',
                hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                filled: true,
                fillColor: const Color(0xFFF3F6FA),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(20),
              ),
            ),
            const SizedBox(height: 24),

            const Text('ATTACH MEDIA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF666666))),
            const SizedBox(height: 12),
            if (_selectedImage != null)
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(_selectedImage!, height: 180, width: double.infinity, fit: BoxFit.cover),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedImage = null),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 20, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              )
            else
              GestureDetector(
                onTap: _showPickerOptions,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE0E0E0), style: BorderStyle.none), // Mock dash
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate_outlined, color: Colors.grey.shade400, size: 40),
                      const SizedBox(height: 8),
                      Text('TAP TO UPLOAD PHOTO', style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 48),

            PrimaryButton(
              text: _isPublishing ? 'PUBLISHING...' : 'PUBLISH NOW',
              onPressed: _handlePublish,
              isLoading: _isPublishing,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
