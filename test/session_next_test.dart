import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:session_next/session_next.dart';

void main() {
  var sessionOne = SessionNext();
  var sessionTwo = SessionNext();

  test('Is a proper singleton', () {
    sessionOne.set('testKey', 'testValue');

    expect(sessionOne.get('testKey'), sessionTwo.get('testKey'));
  });

  test('Is able to store and retrieve values', () {
    var obj = {
      'prop1': 'val1',
      'prop2': 'val2',
    };

    sessionOne.set('aString', 'aValue');
    sessionOne.set('anObject', obj);

    expect(sessionOne.get<String>('aString'), 'aValue');
    expect(sessionOne.get<Object>('anObject'), obj);

    expect(sessionOne.containsKey('aString'), true);

    // remove one key
    sessionOne.remove('aString');
    expect(sessionOne.containsKey('aString'), false);

    // remove all keys
    sessionOne.removeAll();
    expect(sessionOne.containsKey('anObject'), false);

    // add multiple items at once
    sessionOne.setAll(obj);
    expect(sessionOne.containsKey('prop1'), true);
  });

  test('Can expire', () async {
    var callback = expectAsync0(() {});

    // start the session, with a timeout of 2 sec
    sessionOne.start(sessionTimeOut: 2);

    // set a var
    sessionOne.set('testName', 'testValue');
    expect(sessionOne.containsKey('testName'), true);

    // check if it is not paused (stopped)
    expect(sessionOne.isActive(), true);

    // wait for 3 sec
    Timer(const Duration(seconds: 3), () {
      // after expiry, check if it is paused
      expect(sessionOne.isActive(), false);

      // check if the var is not there anymore
      expect(sessionOne.containsKey('testName'), false);

      callback();
    });
  });

  test('Does not expire when updated in time', () async {
    var callback = expectAsync0(() {});

    sessionOne.destroy();

    // start the session, with a timeout of 3 sec
    sessionOne.start(sessionTimeOut: 3);

    Timer(const Duration(seconds: 2), () {
      sessionOne.update();

      Timer(const Duration(seconds: 2), () {
        expect(sessionOne.isActive(), true);
        callback();
      });
    });
  });

  test('Can be paused and resumed without expiring', () async {
    var callback = expectAsync0(() {});

    sessionOne.destroy();

    // start the session, with a timeout of 2 sec
    sessionOne.start(sessionTimeOut: 2);

    // pause the session
    sessionOne.pause();

    //expect(sessionOne.isPaused(), true);
    expect(sessionOne.isActive(), false);

    // wait for 3 sec
    Timer(const Duration(seconds: 3), () {

      // resume the session
      sessionOne.resume();

      //expect(sessionOne.isPaused(), false);
      expect(sessionOne.isActive(), true);

      callback();
    });
  });

  test('Can have a function called at expiry', () async {
    var callback = expectAsync0(() {});

    sessionOne.destroy();

    testCallback() {
      expect(true, true);
      callback();
    }

    // start the session, with a timeout of 2 sec
    sessionOne.start(sessionTimeOut: 2, onExpire: testCallback());
  });
}
