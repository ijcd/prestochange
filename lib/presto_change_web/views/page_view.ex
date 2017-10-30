defmodule PrestoChangeWeb.PageView do
  use PrestoChangeWeb, :view
  use Taggart

  def render("index.html", assigns) do
    form("up-target": "body") do
      render_controls
      render_workspace
      render_helpers
    end
  end

  def render_controls do
    section(id: "controls") do
      div(class: "uk-grid-collapse uk-grid", "uk-grid": 1) do
        div(class: "uk-width-1-2") do
          "Type or paste HTML here"
          # <select class="uk-select">
          #   <option>HTML to Taggart</option>
          #   <option>HTML to Elm</option>
          #   <option>HTML to Jade</option>
          #   <option>HTML to Slim</option>
          #   <option>HTML to Haml</option>
          # </select>
        end
        div(class: "uk-width-1-2") do
          "Converted output will appear here"
        end
      end
    end
  end

  def render_workspace do
    section(id: "code", "uk-height-viewport": "expand: true") do
      div(class: "uk-grid-collapse uk-grid uk-height-1-1", "uk-grid": 1) do
        div(class: "uk-width-1-2") do
          div(id: "editor", class: "uk-height-1-1", "up-keep": 1) do
          end
        end

        div(class: "uk-width-1-2 uk-height-1-1") do
          textarea(name: "output", class: "uk-height-1-1")
        end
      end
    end
  end

  def render_helpers do
    section(id: "helpers", class: "uk-section-primary") do
      div(class: "uk-grid-collapse uk-grid", "uk-grid": 1) do
        div(class: "uk-width-1-2") do
          "Snippets:"
          button("a", id: "a", class: "uk-button uk-button-small uk-button-secondary")
          button("ul", id: "ul", class: "uk-button uk-button-small uk-button-secondary")
          button("hello world", id: "hello", class: "uk-button uk-button-small uk-button-secondary")
          button("bootstrap navbar", id: "bootstrap", class: "uk-button uk-button-small uk-button-secondary")
          button("zurb topbar", id: "zurb", class: "uk-button uk-button-small uk-button-secondary")
        end

        div(class: "uk-width-1-2") do
          "Indent spaces:"
          button(2, id: "spaces_2", class: "uk-button uk-button-small uk-button-secondary active")
          button(4, id: "spaces_4", class: "uk-button uk-button-small uk-button-secondary")
          button("tabs", id: "tabs", class: "uk-button uk-button-small uk-button-secondary")          
        end
      end
    end
  end
end
