/// Copyright (c) 2022, Bob Hageman (https://github.com/bobhageman)
///
/// Use of this source code is governed by a BSD-3 license that can be
/// found in the LICENSE file.

library session_next;

import 'dart:async';

/// In memory session storage with built in expiry mechanism
class SessionNext {
  static final SessionNext _instance = SessionNext._internal();

  int _sessionTimeOut = 0;
  Function? _onExpire;
  Timer? _timer;

  Map<String, dynamic> _vars = {};

  /// Access to the [SessionNext] Singleton object
  factory SessionNext() {
    return _instance;
  }

  SessionNext._internal();

  /// Store [name] in session storage
  void set<T>(String name, T value) {
    _vars[name] = value;
  }

  /// Store all key/value pairs of [items] in session storage
  void setAll<T>(Map<String, T> items){
    _vars.addAll(items);
  }

  /// Get [name] from session storage
  T? get<T>(String name) {
    if (!containsKey(name)) {
      return null;
    }

    return _vars[name];
  }

  /// Remove [name] from session storage
  void remove(String name) {
    if (!containsKey(name)) {
      return;
    }

    _vars.remove(name);
  }

  /// Remove all session vars from session storage
  void removeAll() {
    _vars = {};
  }

  /// Returns whether session storage contains [name]
  bool containsKey(String name) {
    return _vars.containsKey(name);
  }

  /// Returns whether the session is active (ongoing) or not
  bool isActive() {
    if (_timer != null && _timer!.isActive) {
      return true;
    }

    return false;
  }

  /// Starts the session with an [sessionTimeOut] in seconds. If suppplied, [onExpire] is called when the session times out.
  void start({required int sessionTimeOut, Function? onExpire}) {
    if (!isActive()) {
      _onExpire = onExpire;
      _sessionTimeOut = sessionTimeOut;
    }

    _resetTimer();
  }

  /// Pause the session so it will not expire
  void pause() {
    _stopTimer();
  }

  /// Resume a paused session
  void resume() {
    _resetTimer();
  }

  /// Reset the session timeout
  void update() {
    // When paused, just return.
    if (!isActive()) {
      return;
    }

    // Reset the timeout time by stopping and restarting the timer.
    _resetTimer();
  }

  /// Destroys the session.
  void destroy() {
    _stopTimer();
    _vars = {};
    _onExpire = null;
  }

  void _stopTimer() {
    if (isActive()) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void _resetTimer() {
    // When timer is already running, cancel it.
    _stopTimer();

    _timer = Timer.periodic(
      Duration(seconds: _sessionTimeOut),
      (_) {
        handleExpiry();
      },
    );
  }

  void handleExpiry() {
    // Call the expiry handling function.
    if (_onExpire != null) {
      _onExpire!();
    }

    // Kill the session.
    destroy();
  }
}
