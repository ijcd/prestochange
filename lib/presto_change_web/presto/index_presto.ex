defmodule PrestoChangeWeb.Presto.IndexPresto do
  use Taggart
  alias PrestoChange.Converter
  alias PrestoChange.Snippets
  
  require Logger

  @indent_2 Converter.Indent.Spaces.new(2)
  @indent_4 Converter.Indent.Spaces.new(4)
  @indent_t Converter.Indent.Tabs.new()

  def initial_state() do
    Converter.new()
  end

  def initial_page(state) do
    render_page(state)
  end

  def handle_event(event, state) do
    state =
      case event do
        %{"element" => "button", "event" => "click", "attrs" => %{"id" => id}} = e ->
          case id do
            "a" -> Converter.update_input(state, Snippets.a)
            "ul" -> Converter.update_input(state, Snippets.ul)
            "hello" -> Converter.update_input(state, Snippets.hello)
            "bootstrap" -> Converter.update_input(state, Snippets.bootstrap_navbar)
            "zurb" -> Converter.update_input(state, Snippets.zurb_topbar)

            "spaces_2" -> Converter.update_indent(state, @indent_2)
            "spaces_4" -> Converter.update_indent(state, @indent_4)
            "tabs" -> Converter.update_indent(state, @indent_t)

            _ -> Converter.update_input(state, inspect(id))
          end

        _ ->
          Logger.warn("Unknown event in #{__MODULE__}: #{inspect(event)}")
          state
      end

    # unpoly up.extract(selector, html)
    reply = %{
      presto: [
        %{
          action: "extract",
          data: %{
            selector: "div#converter",
            html: Phoenix.HTML.safe_to_string(render_page(state))
          }
        }
      ],
      editor: [
        %{
          action: "update_editor",
          data: state.input
        }
      ]
    }

    {reply, state}
  end

  def render_page(state) do
    div(id: "converter") do
      render_controls(state)
      render_workspace(state)
      render_helpers(state)
    end
  end

  def render_controls(state) do
    section(id: "controls") do
      div(class: "uk-grid-collapse uk-grid", "uk-grid": true) do
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

  def render_workspace(state) do
    section(id: "code", "uk-height-viewport": "expand: true") do
      div(class: "uk-grid-collapse uk-grid uk-height-1-1", "uk-grid": true) do
        div(class: "uk-width-1-2") do
          div(id: "editor", class: "uk-height-1-1", "up-keep": true) do
            state.input
          end
        end

        div(class: "uk-width-1-2 uk-height-1-1") do
          div(id: "output", class: "uk-height-1-1") do
            pre(class: "uk-scrollable-text") do
              code(class: "elixir") do
                state.output
              end
            end
          end
        end
      end
    end
  end

  def render_helpers(state) do
    section(id: "helpers", class: "uk-section-primary") do
      div(class: "uk-grid-collapse uk-grid", "uk-grid": true) do
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
          button(2, id: "spaces_2", class: "uk-button uk-button-small uk-button-secondary " <> activeIf(state, @indent_2))
          button(4, id: "spaces_4", class: "uk-button uk-button-small uk-button-secondary " <> activeIf(state, @indent_4))
          button("tabs", id: "tabs", class: "uk-button uk-button-small uk-button-secondary " <> activeIf(state, @indent_t))
        end
      end
    end
  end

  def activeIf(state, indent) do
    case state.indent == indent do
      true -> "active"
      false -> ""
    end
  end
end
