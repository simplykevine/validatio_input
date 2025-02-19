import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:email_validator/email_validator.dart';
import '../models/form_data.dart';

class ContactInfoScreen extends StatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  State<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends State<ContactInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load saved data
    final formData = context.read<FormData>();
    _emailController.text = formData.email;
    _phoneController.text = formData.phone;
  }

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'Email is required'),
    EmailValidator(errorText: 'Enter a valid email address')
  ]);

  final phoneValidator = MultiValidator([
    RequiredValidator(errorText: 'Phone number is required'),
    PatternValidator(r'^\+?[\d\s-]{10,}$', 
        errorText: 'Enter a valid phone number (minimum 10 digits)')
  ]);

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final formData = context.read<FormData>();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Registration Complete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${formData.name}'),
              Text('Age: ${formData.age}'),
              Text('Address: ${formData.address}'),
              Text('Email: ${formData.email}'),
              Text('Phone: ${formData.phone}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email address',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: emailValidator,
                onChanged: (value) => context.read<FormData>().updateContactInfo(email: value),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                ),
                keyboardType: TextInputType.phone,
                validator: phoneValidator,
                onChanged: (value) => context.read<FormData>().updateContactInfo(phone: value),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitForm,
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text('Submit'),
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
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
