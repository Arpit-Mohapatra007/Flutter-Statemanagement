import 'package:flutter/material.dart';
import 'package:learning_rxdart_2/blocs/views_bloc/current_view.dart';
import 'package:rxdart/rxdart.dart';

@immutable class ViewsBloc {
  final Sink<CurrentView> goToView;
  final Stream<CurrentView> currentView;

  const ViewsBloc._({required this.goToView, required this.currentView});

  void dispose() {
    goToView.close();
  }
  
  factory ViewsBloc() {
    final goToView = BehaviorSubject<CurrentView>();
    final currentView = goToView.startWith(CurrentView.login);
    return ViewsBloc._(goToView: goToView, currentView: currentView);
  }
}