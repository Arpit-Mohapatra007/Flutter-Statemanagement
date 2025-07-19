import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:learning_rxdart_2/type_definitions.dart';

class NewContactView extends HookWidget {
  final CreateContactCallback createContact;
  final GoBackCallback goBack;

  const NewContactView({required this.createContact, required this.goBack, super.key});

  @override
  Widget build(BuildContext context) {
    final firstNameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final phoneNumberController = useTextEditingController();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: goBack,
        icon: Icon(Icons.close)),
        title: const Text('New Contact'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstNameController,
                decoration: const InputDecoration(
                  hintText: 'First Name',
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  hintText: 'Last Name',
                ),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  hintText: 'Phone Number',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              TextButton(onPressed: (){
                final firstName = firstNameController.text;
                final lastName = lastNameController.text;
                final phoneNumber = phoneNumberController.text;
                createContact(firstName, lastName, phoneNumber);
                goBack();
              },
               child: const Text('Save Contacts'))
            ],
          ),
        ),
      )

    );
  }
}