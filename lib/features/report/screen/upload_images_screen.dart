import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../controller/report_submission.dart';

class UploadImagesScreen extends ConsumerStatefulWidget {
  const UploadImagesScreen({super.key});

  @override
  ConsumerState<UploadImagesScreen> createState() => _UploadImagesScreenState();
}

class _UploadImagesScreenState extends ConsumerState<UploadImagesScreen> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final picked = await _picker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() => _images.addAll(picked.map((x) => File(x.path))));
    }
  }

  Future<void> _submit(int reportId) async {
    if (_images.isEmpty) {
      // Allow skipping — or enforce with a snackbar if images are required
      Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false);
      return;
    }

    final success = await ref
        .read(reportSubmitProvider.notifier)
        .uploadImages(reportId: reportId, images: _images);

    if (!mounted) return;

    if (success) {
      ref.read(reportSubmitProvider.notifier).reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Report submitted successfully!")),
      );
      Navigator.pushNamedAndRemoveUntil(context, '/index', (r) => false);
    } else {
      final error = ref.read(reportSubmitProvider).error;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error ?? "Image upload failed.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the reportId passed from CreateReportScreen
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final reportId = args['reportId'] as int;

    final submitState = ref.watch(reportSubmitProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Photos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Add Photos",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              "Attach photos to support your report (optional)",
              style: TextStyle(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            // Image grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: _images.length + 1, // +1 for the "add" tile
                itemBuilder: (context, index) {
                  if (index == _images.length) {
                    return GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceVariant.withOpacity(
                            0.4,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Icon(
                          Icons.add_a_photo_outlined,
                          color: theme.colorScheme.primary,
                          size: 32,
                        ),
                      ),
                    );
                  }
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(_images[index], fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => setState(() => _images.removeAt(index)),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Upload progress bar
            if (submitState.step == SubmitStep.uploadingImages) ...[
              const SizedBox(height: 12),
              LinearProgressIndicator(value: submitState.uploadProgress),
              const SizedBox(height: 6),
              Center(
                child: Text(
                  "${(submitState.uploadProgress * 100).toStringAsFixed(0)}%",
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],

            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: submitState.isLoading
                    ? null
                    : () => _submit(reportId),
                child: submitState.step == SubmitStep.uploadingImages
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _images.isEmpty ? "Skip & Finish" : "Submit Report",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
