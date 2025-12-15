import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../../widgets/bottom_navigation_bar.dart';
import '../../providers/navigation_provider.dart';

class PostRequestScreen extends ConsumerStatefulWidget {
  const PostRequestScreen({super.key});

  @override
  ConsumerState<PostRequestScreen> createState() => _PostRequestScreenState();
}

class _PostRequestScreenState extends ConsumerState<PostRequestScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Request'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Service Category
              FormBuilderDropdown<String>(
                name: 'category',
                decoration: const InputDecoration(
                  labelText: 'Service Category',
                  hintText: 'Select a category',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'plumbing', child: Text('Plumbing')),
                  DropdownMenuItem(value: 'electrical', child: Text('Electrical')),
                  DropdownMenuItem(value: 'carpentry', child: Text('Carpentry')),
                  DropdownMenuItem(value: 'painting', child: Text('Painting')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              
              // Title
              FormBuilderTextField(
                name: 'title',
                decoration: const InputDecoration(
                  labelText: 'Request Title',
                  hintText: 'e.g., Fix leaking faucet',
                  prefixIcon: Icon(Icons.title_outlined),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(5),
                ]),
              ),
              const SizedBox(height: 16),
              
              // Description
              FormBuilderTextField(
                name: 'description',
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Describe your request in detail...',
                  prefixIcon: Icon(Icons.description_outlined),
                ),
                maxLines: 5,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(20),
                ]),
              ),
              const SizedBox(height: 16),
              
              // Location
              FormBuilderTextField(
                name: 'location',
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Enter your address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              
              // Budget
              FormBuilderTextField(
                name: 'budget',
                decoration: const InputDecoration(
                  labelText: 'Budget (Optional)',
                  hintText: 'Enter your budget',
                  prefixIcon: Icon(Icons.attach_money_outlined),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              
              // Urgency
              FormBuilderDropdown<String>(
                name: 'urgency',
                decoration: const InputDecoration(
                  labelText: 'Urgency',
                  hintText: 'Select urgency level',
                  prefixIcon: Icon(Icons.schedule_outlined),
                ),
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Low')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'high', child: Text('High')),
                  DropdownMenuItem(value: 'urgent', child: Text('Urgent')),
                ],
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 24),
              
              // Image Upload Placeholder
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 48,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Add Photos (Optional)',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement image picker
                        },
                        icon: const Icon(Icons.upload),
                        label: const Text('Upload Images'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Submit Button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.saveAndValidate() ?? false) {
                    // TODO: Submit request to backend
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Request submitted successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(
        currentIndex: 1,
        userRole: UserRole.client,
      ),
    );
  }
}

