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
// Setup Unpoly
//////////////////////////////////

import unpoly from "unpoly/dist/unpoly.js"
// up.log.enable();    // TODO: make specific to the environment?
up.log.disable();    // TODO: make specific to the environment?

//////////////////////////////////
// Setup Presto
//////////////////////////////////

import {Presto} from "presto"
let presto = new Presto(channel, up);


//////////////////////////////////
// Adjust code height on change
//////////////////////////////////

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

presto.onPostUpdate(function(payload) {
  var input = $("#editor_shadow_input").text()

  if (editor.getValue() != input) {
    editor.setValue(input); //, -1); // moves cursor to the start
    editor.selection.clearSelection();
  }

  setCodeHeight();
});
