# chrome_storage_dart

Element access to the [chrome.storage](https://developer.chrome.com/extensions/storage) API
and [localStorage](https://developer.mozilla.org/en-US/docs/Web/API/Web_Storage_API/Using_the_Web_Storage_API) APIs.
Selects which one to use based on whether or not you're running as a Chrome App.
Based on Polymer.dart's core-localstorage-dart, and provides
[the same API](https://www.polymer-project.org/docs/elements/core-elements.html#core-localstorage)
(except I've added the 'sync' attribute to enable Chrome Sync).

## Usage

Local storage:

    <link rel="import" href="../../packages/chrome_storage_dart/chrome_storage_dart.html">

    <cross-platform-storage-dart name="key" value="{{ value }}"></cross-platform-storage-dart>

[Synchronized storage](https://developer.chrome.com/extensions/storage#property-sync):

    <link rel="import" href="../../packages/chrome_storage_dart/chrome_storage_dart.html">

    <cross-platform-storage-dart name="key" value="{{ value }}" sync></cross-platform-storage-dart>

Raw value storage (not stored as JSON):

    <link rel="import" href="../../packages/chrome_storage_dart/chrome_storage_dart.html">

    <cross-platform-storage-dart name="key" value="{{ value }}" useRaw></cross-platform-storage-dart>

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: http://www.github.com/BrianGeppert/chrome_storage_dart/issues/
