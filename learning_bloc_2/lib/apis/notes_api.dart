
import 'package:flutter/foundation.dart' show immutable;
import 'package:learning_bloc_2/models.dart';

@immutable
abstract class NotesApiProtocol{
  const NotesApiProtocol();
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle});
}

@immutable
class NotesApi implements NotesApiProtocol{
  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle})=>
    Future.delayed(
      const Duration(seconds: 2),
      ()=>loginHandle == const LoginHandle.foobar()?mockNotes:null
    );
}