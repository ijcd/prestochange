window.nodeRequire = require;
delete window.require;
delete window.exports;
delete window.module;

// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import {socket, channel} from "./socket"

//////////////////////////////////
// Extend jQuery with attr()
//////////////////////////////////

(function(old) {
  $.fn.attr = function() {
    if(arguments.length === 0) {
      if(this.length === 0) {
        return null;
      }

      var obj = {};
      $.each(this[0].attributes, function() {
        if(this.specified) {
          obj[this.name] = this.value;
        }
      });
      return obj;
    }

    return old.apply(this, arguments);
  };
})($.fn.attr);

function setCodeHeight() {
  var window_height = $(window).height();
  var header_height = $("#header").height();
  var controls_height = $("#controls").height();
  var helpers_height = $("#helpers").height();

  $("#code").height(window_height - header_height - controls_height - helpers_height - 8);
}

$(document).ready(function() {
  $(window).resize(setCodeHeight);
  setCodeHeight();
});

//////////////////////////////////
// Setup UIKit
//////////////////////////////////

uikit.use(icons);


//////////////////////////////////
// Setup highlight.js
//////////////////////////////////

import hljs from "highlight.js";

up.compiler("pre code", function ($blocks) {
  $blocks.each(function(i, block) {
    hljs.highlightBlock(block);
  });
});


//////////////////////////////////
// Setup clipboard
//////////////////////////////////

import Clipboard from "clipboard";

var clipboard = new Clipboard("button#clipboard");

clipboard.on("success", function(e) {
  setTimeout( () => e.clearSelection(), 200 );
});


//////////////////////////////////
// Setup Editor
//////////////////////////////////

function pushEditor() {
  var code = editor.getValue();

  channel.push("presto", {
    event: "editor_changed",
    content: editor.getValue()
  });
}

var editor = ace.edit("editor");
editor.$blockScrolling = Infinity
editor.setTheme("ace/theme/monokai");
editor.getSession().setMode("ace/mode/html");

editor.on("change", function(e) {
  // https://github.com/ajaxorg/ace/issues/503
  if (editor.curOp && editor.curOp.command.name) {
    // console.log("user change");
    pushEditor();
  } else {
    // console.log("other change");
  }
});

//////////////////////////////////
// Setup Unpoly
//////////////////////////////////

import unpoly from "unpoly/dist/unpoly.js"
// up.log.enable();    // TODO: make specific to the environment?
up.log.disable();    // TODO: make specific to the environment?


//////////////////////////////////
// Setup Presto
//////////////////////////////////

// up.on("up:fragment:keep", function(event) {
//   console.log("keep", event);
// });
//
// up.on("up:fragment:kept", function(event) {
//   console.log("kept", event);
// });

// TODO: Organize event handling better.
// TODO: How do we bind document or page-level events?
// https://stackoverflow.com/questions/9368538/getting-an-array-of-all-dom-events-possible
var allEventNames = Object.getOwnPropertyNames(document).concat(Object.getOwnPropertyNames(Object.getPrototypeOf(Object.getPrototypeOf(document)))).concat(Object.getOwnPropertyNames(Object.getPrototypeOf(window))).filter(function(i){return !i.indexOf("on")&&(document[i]==null||typeof document[i]=="function");}).filter(function(elem, pos, self){return self.indexOf(elem) == pos;});

function prestoPush(eventName, $el) {
  channel.push("presto", {
    element: $el.prop('tagName'),
    event: eventName,
    attrs: $el.attr(),
    id: $el.prop('id')
  });
}

// Attach a delegated event handler
allEventNames.forEach(function(eventName) {
  var eventName = eventName.replace(/^on/, "");
  $("body").on(eventName, ".presto-" + eventName, function(event) {
    var $el = $(this);
    $el = $(event.target);
    prestoPush(eventName, $el);
  });
});

channel.on("presto", payload => {
  var {name: name} = payload;

  switch (name) {
    case "update_component": {
      var {component_id: component_id, content: content} = payload;

      var focused = document.activeElement;
      up.extract("#" + component_id, content);
      $(focused).focus();

      if (typeof prestoPostHook === 'function') {
        prestoPostHook(payload);
      }

      break;
    }
  }
});

function prestoPostHook(payload) {
  var input = $("#editor_shadow_input").text()

  if (editor.getValue() != input) {
    editor.setValue(input, -1); // moves cursor to the start
  }

  setCodeHeight();
}
