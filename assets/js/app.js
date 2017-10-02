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

// import socket from "./socket"

uikit.use(icons);

// setup editor
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

// $(window).resize(function() {
//   editor.resize();
// })
