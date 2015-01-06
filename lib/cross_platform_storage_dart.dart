/*
 * Copyright (c) 2014 The Polymer Project Authors. All rights reserved.
 * This code may only be used under the BSD style license found at http://polymer.github.io/LICENSE.txt
 * The complete set of authors may be found at http://polymer.github.io/AUTHORS.txt
 * The complete set of contributors may be found at http://polymer.github.io/CONTRIBUTORS.txt
 * Code distributed by Google as part of the polymer project is also
 * subject to an additional IP rights grant found at http://polymer.github.io/PATENTS.txt
 */
/// Dart API for the polymer element `cross-platform-storage-dart`.
library gep.cross_platform_storage_dart;

import 'dart:html';
import 'dart:convert' show JSON;
import 'dart:js' show context;
import 'package:polymer/polymer.dart';
import 'package:chrome/chrome_app.dart' as chrome;

/// Element access to localStorage / Chrome Storage.  The "name" property
/// is the key to the data ("value" property) stored in storage.
///
/// `cross-platform-storage-dart` automatically saves the value to storage when
/// value is changed.  Note that if value is an object auto-save will be
/// triggered only when value is a different instance.
///
///     <cross-platform-storage-dart name="my-app-storage" value="{{value}}"></cross-platform-storage-dart>
@CustomTag('cross-platform-storage-dart')
class CrossPlatformStorage extends PolymerElement {
  /**
   * Fired when a value is loaded from localStorage.
   * @event cross-platform-storage-load
   */

  /**
   * The key to the data stored in localStorage.
   *
   * @attribute name
   * @type string
   * @default null
   */
  @observable String name = '';

  /**
   * The data associated with the specified name.
   *
   * @attribute value
   * @type object
   * @default null
   */
  @observable var value;

  /**
   * If true, the value is stored and retrieved without JSON processing.
   *
   * @attribute useRaw
   * @type boolean
   * @default false
   */
  @observable bool useRaw = false;

  /**
   * If true, auto save is disabled.
   *
   * @attribute autoSaveDisabled
   * @type boolean
   * @default false
   */
  @observable bool autoSaveDisabled = false;

  /**
   * If true, the value is synced using Chrome Sync.
   *
   * This value is ignored if not running as a Chrome App.
   *
   * @attribute sync
   * @type boolean
   * @default false
   */
  @observable bool sync = false;

  @observable bool loaded = false;

  bool chromeApp = false;

  factory CrossPlatformStorage() => new Element.tag('cross-platform-storage-dart');
  CrossPlatformStorage.created() : super.created() {
    this.chromeApp = context['chrome'] != null &&
        context['chrome']['runtime'] != null;
  }

  @override
  attached() {
    // wait for bindings are all setup
    this.async((_) => load());
  }

  void valueChanged() {
    if (this.loaded && !this.autoSaveDisabled) {
      this.save();
    }
  }

  void load() {
    if(this.chromeApp) {
      if(this.sync) {
        chrome.storage.sync.get(name).then(this.onLoaded);
      } else {
        chrome.storage.local.get(name).then(this.onLoaded);
      }
    } else {
      this.onLoaded({
        name: window.localStorage[name]
      });
    }
    print((this.chromeApp ? '' : 'not ') + 'running as a Chrome App');
  }

  void onLoaded(var keys) {
    var v = keys[name];

    if (useRaw) {
      this.value = v;
    } else {
      // localStorage has a flaw that makes it difficult to determine
      // if a key actually exists or not (getItem returns null if the
      // key doesn't exist, which is not distinguishable from a stored
      // null value)
      // however, if not `useRaw`, an (unparsed) null value unambiguously
      // signals that there is no value in storage (a stored null value would
      // be escaped, i.e. "null")
      // in this case we save any non-null current (default) value
      if (v == null) {
        if (this.value != null) {
          this.save();
        }
      } else {
        try {
          v = JSON.decode(v);
        } catch(x) {
        }
        this.value = v;
      }
    }

    this.loaded = true;
    this.asyncFire('cross-platform-storage-load');
  }

  /**
   * Saves the value to localStorage.
   *
   * @method save
   */
  void save() {
    var v = useRaw ? value : JSON.encode(value);

    if(this.chromeApp) {
      Map map = {
        name: v
      };

      if(this.sync) {
        chrome.storage.sync.set(map);
      } else {
        chrome.storage.local.set(map);
      }
    } else {
      window.localStorage[name] = v;
    }
  }
}
