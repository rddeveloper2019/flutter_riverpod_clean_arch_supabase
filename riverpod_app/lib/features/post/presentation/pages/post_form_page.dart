import 'dart:io';

import 'package:core/utils.dart';
import 'package:domain/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/errors/presentation_failure_exception.dart';
import '../mutations/post_form_mutations.dart';

class PostFormPage extends ConsumerStatefulWidget {
  const PostFormPage({super.key, this.postId});

  final String? postId;

  @override
  ConsumerState<PostFormPage> createState() => _PostFormPageState();
}

class _PostFormPageState extends ConsumerState<PostFormPage> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  File? _selectedImage;

  String? _existingImageUrl;
  bool _imageWasRemoved = false;
  PostDisplay? _originalPost;

  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    try {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _imageWasRemoved = false;
        });
      }
    } on PlatformException catch (e) {
      if (!mounted) return;
      print('Failed to pick image: $e');
      showErrorSnackBar(context, message: e.toString());
    } catch (e) {
      print('Unexpected error occurred: $e');
      if (!mounted) return;
      showErrorSnackBar(context, message: e.toString());
    }
  }

  Widget _buildImagePreview() {
    Widget? imageWidget;

    if (_selectedImage != null) {
      imageWidget = Image.file(
        _selectedImage!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }
    // else if (_existingImageUrl != null && !_imageWasRemoved) {
    //   imageWidget = CachedNetworkImage(
    //     imageUrl: _existingImageUrl!,
    //     fit: BoxFit.cover,
    //     width: double.infinity,
    //     height: double.infinity,
    //     placeholder: (context, url) =>
    //         const Center(child: CircularProgressIndicator()),
    //     errorWidget: (context, url, error) =>
    //         const Center(child: Icon(Icons.error)),
    //   );
    // }

    if (imageWidget != null) {
      return Stack(
        fit: StackFit.expand,
        children: [
          imageWidget,
          Positioned(
            top: 4,
            right: 4,
            child: IconButton(
              onPressed: () {
                setState(() {
                  _selectedImage = null;
                  _imageWasRemoved = true;
                });
              },
              icon: const Icon(Icons.cancel, color: Colors.white, size: 28),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black.withValues(alpha: 0.5),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 8),
            Text('Tap to add an image'),
          ],
        ),
      );
    }
  }

  void _submitForm() {
    setState(() {
      _autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    runCreatePost(
      ref: ref,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      image: _selectedImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createPostMutation);
    final isSubmitting = createState is MutationPending;

    ref.listen<MutationState<PostDisplay>>(createPostMutation, (prev, next) {
      if (next case MutationError<PostDisplay>(:final error)) {
        if (!mounted) return;
        showErrorSnackBar(context, message: presentationFailureMessage(error));
      }
      if (next is MutationSuccess<PostDisplay>) {
        if (!mounted) return;
        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Form(
          key: _formKey,
          autovalidateMode: _autovalidateMode,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade100,
                ),
                child: InkWell(
                  onTap: isSubmitting ? null : _pickImage,
                  child: _buildImagePreview(),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
                enabled: !isSubmitting,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 10,
                minLines: 5,
                enabled: !isSubmitting,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter content.';
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
              ),

              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
