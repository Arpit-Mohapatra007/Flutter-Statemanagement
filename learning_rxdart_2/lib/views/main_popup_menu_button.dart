import 'package:flutter/material.dart';
import 'package:learning_rxdart_2/dialogs/delete_account_dialog.dart';
import 'package:learning_rxdart_2/dialogs/logout_dialog.dart';
import 'package:learning_rxdart_2/type_definitions.dart';

enum MenuAction{logout, deleteAccount}

class MainPopupMenuButton extends StatelessWidget {

  final LogoutCallback logout;
  final DeleteAccountCallback deleteAccount;


  const MainPopupMenuButton({super.key, required this.logout, required this.deleteAccount});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: (value) async {
        switch(value){
          case MenuAction.logout:
            final shouldLogout = await showLogoutDialog(context);
            if(shouldLogout){
              logout();
            }
            break;
          case MenuAction.deleteAccount:
            final shouldDeleteAccount = await showDeleteAccountDialog(context: context);
            if(shouldDeleteAccount){
              deleteAccount();
            }
            break;
        }
      },
      itemBuilder: (context){
        return [
          const PopupMenuItem(
            value: MenuAction.logout,
            child: Text('Logout'),
          ),
          const PopupMenuItem(
            value: MenuAction.deleteAccount,
            child: Text('Delete Account'),
          ),
        ];
      });
  }
}