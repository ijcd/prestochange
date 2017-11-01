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
// Setup Unpoly
//////////////////////////////////

import unpoly from "unpoly/dist/unpoly.js"
up.log.enable();    // TODO: make specific to the environment?


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

var clipboard = new Clipboard('button#clipboard');

clipboard.on('success', function(e) {
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
editor.setTheme("ace/theme/monokai");
editor.getSession().setMode("ace/mode/html");

editor.on("change", function(e) {
  // https://github.com/ajaxorg/ace/issues/503
  if (editor.curOp && editor.curOp.command.name) {
    console.log("user change");
    pushEditor();
  } else {
    console.log("other change");
  }
});


//////////////////////////////////
// Setup Presto
//////////////////////////////////

up.on('up:fragment:keep', function(event) {
  console.log("keep", event);
});

up.on('up:fragment:keet', function(event) {
  console.log("kept", event);
});

up.compiler('button[presto]', function($button) {
  $button.on('click', function(event) {
    event.preventDefault();

    $button = $(event.target);

    channel.push("presto", {
      event: "click",
      element: "button",
      attrs: $button.attr(),
      text: $button.text()
    });
  });
});

function applyPresto(message) {
  var {action, data} = message;

  switch (action) {
    case "extract": {
      var {selector, html} = data;

      var focused = document.activeElement;
      up.extract(selector, html);
      $(focused).focus();

      break;
    }
    default: {
      console.log("Unknown message", message);
    }
  }

  setCodeHeight();
}

function applyEditor(message) {
  var {action, data} = message;

  switch (action) {
    case "update_editor": {
      if (editor.getValue() != data) {
        editor.setValue(data); //, -1); // moves cursor to the start
      }
      break;
    }
    default: {
      console.log("Unknown message", message);
    }
  }
}

channel.on("presto", payload => {
  var {presto: presto_actions = []} = payload;
  presto_actions.map(p => applyPresto(p));

  var {editor: editor_actions = []} = payload;  
  editor_actions.map(p => applyEditor(p));  
});
