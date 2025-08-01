import 'package:flutter/foundation.dart' show immutable;
import 'package:learning_bloc_2/models.dart';
import 'package:collection/collection.dart';
@immutable 
class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState({required this.isLoading, required this.loginError, required this.loginHandle, required this.fetchedNotes});

  const AppState.empty()
  : isLoading = false,
    loginError = null,
    loginHandle = null,
    fetchedNotes = null;

  @override
  String toString() => {
    'isLoading': isLoading,
    'loginError': loginError,
    'loginHandle': loginHandle,
    'fetchedNotes': fetchedNotes,
  }.toString();

  @override
  bool operator ==(covariant AppState other){
    final otherPropertiesAreEqual = isLoading == other.isLoading &&
                                    loginError == other.loginError &&
                                    loginHandle == other.loginHandle ;
    if(fetchedNotes == null && other.fetchedNotes == null){
      return otherPropertiesAreEqual;
    }
    else{
      return otherPropertiesAreEqual
      && (fetchedNotes?.isEqualTo(other.fetchedNotes) ?? false);
    }
  }
  
  @override
  int get hashCode => Object.hash(
      fetchedNotes, 
      isLoading, 
      loginError, 
      loginHandle
    );
}
extension UnorderedEquality on Object{
  bool isEqualTo(other) => const DeepCollectionEquality.unordered().equals(this, other);
}
