import 'package:flutter/material.dart';
import 'package:learning_mobx/dialogs/delete_reminder_dialog.dart';
import 'package:learning_mobx/dialogs/show_textfield_dialog.dart';
import 'package:learning_mobx/state/app_state.dart';
import 'package:learning_mobx/views/main_popup_menu_button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
class RemindersView extends StatelessWidget {
  const RemindersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async{
              final reminderText = await showTextFieldDialog(
                context: context, 
                title: 'Add Reminder', 
                hintText: 'Enter a reminder', 
                optionBuilder: ()=>{
                  TextFieldDialogButtonType.cancle: 'Cancel',
                  TextFieldDialogButtonType.confirm: 'Save'
                }
              );
              if(reminderText == null) return;
              context.read<AppState>().createReminder(reminderText);
            }
          ),
          const MainPopupMenuButton(),
        ],
      ),
      body: const ReminderListView(),
    );
  }
}

class ReminderListView extends StatelessWidget {
  const ReminderListView({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    return Observer(
      builder: (context) {
        return ListView.builder(
          itemCount: appState.sortedReminders.length,
          itemBuilder: (context, index) {
            final reminder = appState.sortedReminders[index];
            return Observer(
              builder: (context) {
                return  CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                value: reminder.isDone, 
                onChanged: (isDone){
                  context.read<AppState>().modifyReminder(reminderId: reminder.id, isDone: isDone??false);
                  reminder.isDone = isDone??false;
                }
                ,
                title: Row(
                  children: [
                    Expanded(
                      child: Text(reminder.text)
                      ),
                    IconButton(
                      onPressed: ()async{
                        final shouldDeleteReminder = 
                        await showDeleteReminderDialog(context);
                        if (shouldDeleteReminder){
                          context.read<AppState>().delete(reminder);
                        }
                      }, 
                      icon: const Icon(Icons.delete),
                      )
                  ],
                ),
              );
              },
            );
          }
        );
      },
    );
  }
}