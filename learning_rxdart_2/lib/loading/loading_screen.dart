import 'dart:async';

import 'package:flutter/material.dart';
import 'package:learning_rxdart_2/loading/loading_screen_controller.dart';

class LoadingScreen {
  LoadingScreen._sharedInstance();
  static final _shared = LoadingScreen._sharedInstance();
  factory LoadingScreen.instance() => _shared;

  LoadingScreenController? controller;

  void show({
    required BuildContext context,
    required String text,
  }){
    if(controller?.update(text) ?? false){
      return;
    }else{
      controller = _showOverlay(context: context, text: text);
    }
  }

  void hide(){
    controller?.close();
    controller = null;
  }

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }){
    final _text = StreamController<String>();
    _text.add(text);

    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(160),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: size.width * 0.8,
                maxHeight: size.height * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: const Color.fromARGB(160, 0, 0, 0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 20),
                      StreamBuilder<String>(
                        stream: _text.stream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return Text(
                              snapshot.requireData,
                              textAlign: TextAlign.center,
                            );
                          }else{
                            return Container();
                          }
                        }
                      )
                    ]
                )
              )
            )
          )
        )
        );
      },

    );
    final state = Overlay.of(context);
    state.insert(overlay);
    return LoadingScreenController(close: () {
      _text.close();
      overlay.remove();
      return true;
    },update: (text) {
      _text.add(text);
      return true;
    },);
  }
}