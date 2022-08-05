![SessionNext](session_next.png)

[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

Having a session inside your app made easy. Features in-memory storage and a built in expiry mechanism.

## Features

- In-memory storage which accepts all types of data (key / value), which will be there as long as the app is running and/or session does not expire.
- Can be set to expire in the amount of seconds of inactivity you define
- On expiry, a callback function can be invoked, so you can direct your user back to the login page for example.


## Usage
SessionNext can be used as a key value store where stored data is available as long as the app runs, or as a setup where the session can expire after `x` seconds. 

### Session storage

```dart
var session = SessionNext();

// set some session vars
session.set('key','value');
session.set('key-2', {'prop1': 'val1'});

// to get them
var keyString = session.get<String>('key');   // returns a casted String
var keyDynamic = session.get('key');          // return a dynamic
var keyMap = session.get<Map>('key-2');       // return a casted Map

// to check if a var exists in the session
if (session.containsKey('key')){
    // yes I'm there
}
```

### Adding session expiration
```dart
var session = SessionNext();

session.start(      
    sessionTimeOut: 5,                      // timeout in seconds
    onExpire: () => { _handleExpiry() },      // what to do when it expires
);

// optionally: pause the session
session.pause();
// it does not expire anymore

// resume the session
session.resume();

// check if the session is running (active)
if (session.isActive()){
    // I am active
}

// update the session, so it does not expire
session.update();

// destroy the session manually
session.destroy();
```
### GOOD TO KNOW:
If you `start()` a session, you need to make sure the time doesn't run out when a user is doing things while he is logged in. To make sure of that you need to call `SessionNext().update();` regularly. This can be done by listening for every touch event inside the app like this for example:

```dart
main.dart:
...
  @override
  Widget build(BuildContext context) {
    // wrap your app buildup with a Listener, 
    // to be able to 'catch' the pointer events
    return Listener(
      onPointerDown: (_) => { SessionNext().update() },
      child: ... 
      )
...
```

A fully working example can be found in the `/example` folder.

## Contributing
Contributions are what makes the open source community such an amazing place to be. To contribute:

1. Fork the Project
2. Create your feature Branch (git checkout -b feature/AmazingFeature)
3. Commit your Changes (git commit -m 'Add some AmazingFeature')
4. Push to the Branch (git push origin feature/AmazingFeature)
5. Open a Pull Request

## Maintainer
Hey, I'm Bob Hageman, creator and maintainer of this package. You can visit my [GitHub](https://github.com/bobhageman) and [GitLab](https://gitlab.com/bobhageman) profile here. If you like this, please leave a like or star it on GitHub / GitLab.

## License
This package is licensed by a BSD-3 license that can be found [here](LICENSE). 

