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

//////////////////////////////////
// Setup Unpoly
//////////////////////////////////

import unpoly from "unpoly/dist/unpoly.js"
up.log.enable();    // TODO: make specific to the environment?


//////////////////////////////////
// Setup UIKit
//////////////////////////////////

uikit.use(icons);


//////////////////////////////////
// Setup Editor
//////////////////////////////////

var editor = ace.edit("editor");
editor.setTheme("ace/theme/monokai");
editor.getSession().setMode("ace/mode/html");

editor.getSession().on('change', function(e) {
  console.log(e);
});

editor.getSession().selection.on('changeSelection', function(e) {
  console.log(e);
});

editor.getSession().selection.on('changeCursor', function(e) {
  console.log(e);
});


//////////////////////////////////
// Setup Proactive callbacks
//////////////////////////////////

up.compiler('button', function($button) {
  $button.on('click', function(event) {
    event.preventDefault();

    $button = $(event.target);

    channel.push("button", {
      event: "click",
      element: "button",
      attrs: $button.attr(),
      text: $button.text()
    });
  });
});

channel.on("snippet", payload => {
  console.log("SNIPPET", payload);
  editor.setValue(payload.snippet, -1) // moves cursor to the start
  // editor.setValue(str, 1) // moves cursor to the end  
});
