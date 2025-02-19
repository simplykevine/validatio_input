import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'contact_info_screen.dart';
import '../models/form_data.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load saved data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FormData>().loadData().then((_) {
        final formData = context.read<FormData>();
        _nameController.text = formData.name;
        _ageController.text = formData.age;
        _addressController.text = formData.address;
      });
    });
  }

  final nameValidator = MultiValidator([
    RequiredValidator(errorText: 'Name is required'),
    MinLengthValidator(2, errorText: 'Name must be at least 2 characters long'),
    PatternValidator(r'^[a-zA-Z\s]+$', errorText: 'Name can only contain letters and spaces')
  ]);

  final ageValidator = MultiValidator([
    RequiredValidator(errorText: 'Age is required'),
    PatternValidator(r'^\d+$', errorText: 'Age must be a number'),
    RangeValidator(min: 18, max: 120, errorText: 'Age must be between 18 and 120')
  ]);

  final addressValidator = MultiValidator([
    RequiredValidator(errorText: 'Address is required'),
    MinLengthValidator(10, errorText: 'Address must be at least 10 characters long'),
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'Enter your full name',
                ),
                validator: nameValidator,
                onChanged: (value) => context.read<FormData>().updatePersonalInfo(name: value),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(
                  labelText: 'Age',
                  hintText: 'Enter your age',
                ),
                keyboardType: TextInputType.number,
                validator: ageValidator,
                onChanged: (value) => context.read<FormData>().updatePersonalInfo(age: value),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter your full address',
                ),
                maxLines: 3,
                validator: addressValidator,
                onChanged: (value) => context.read<FormData>().updatePersonalInfo(address: value),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContactInfoScreen(),
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
