import 'package:flutter/material.dart';
import 'package:learning_rxdart_2/dialogs/delete_contact_dialog.dart';
import 'package:learning_rxdart_2/models/contact.dart';
import 'package:learning_rxdart_2/type_definitions.dart';
import 'package:learning_rxdart_2/views/main_popup_menu_button.dart';

class ContactsListView extends StatelessWidget {
  final Stream<Iterable<Contact>> contacts;
  final DeleteAccountCallback deleteAccount;
  final DeleteContactCallback deleteContact;
  final LogoutCallback logout;
  final VoidCallback createNewContact;

  const ContactsListView({super.key, required this.contacts, required this.deleteContact, required this.logout, required this.createNewContact, required this.deleteAccount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts List'),
        actions: [
          MainPopupMenuButton(
            logout: logout, 
            deleteAccount: deleteAccount,
          ),
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewContact,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<Iterable<Contact>>(
        stream: contacts,
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
            case ConnectionState.done:
             final contacts = snapshot.data!;
              return ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index){
                  final contact = contacts.elementAt(index);
                  return ContactsListTile(
                    contact: contact,
                    deleteContact: deleteContact,
                  );
                },
              );
          }
        }
      )
    );
  }
}


class ContactsListTile extends StatelessWidget {
  final Contact contact;
  final DeleteContactCallback deleteContact;

  const ContactsListTile({super.key, required this.contact, required this.deleteContact});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(contact.fullName[0]),
      ),
      title: Text(contact.fullName)
      ,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () async{
          final shouldDelete = await showDeleteContactDialog(context);
          if(shouldDelete){
            deleteContact(contact);
          }
        },
      )
    );
  }
}