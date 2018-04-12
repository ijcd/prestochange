defmodule PrestoChangeWeb.Presto.IndexPresto do
  @moduledoc false

  use Presto.Page
  use Taggart.HTML
  alias PrestoChange.Converter
  alias PrestoChange.Snippets

  require Logger

  @indent_2 Converter.Indent.Spaces.new(2)
  @indent_4 Converter.Indent.Spaces.new(4)
  @indent_t Converter.Indent.Tabs.new()

  @impl Presto.Page
  def initial_model(_model) do
    Converter.new()
  end

  @impl Presto.Page
  def index(assigns) do
    assigns = Map.put(assigns, :presto_content, super(assigns))
    PrestoChangeWeb.LayoutView.render("app.html", assigns)
  end

  @impl Presto.Page
  def update(message, model) do
    case message do
      %{"event" => "click", "element" => "BUTTON", "attrs" => %{"id" => id}} ->
        case id do
          "a" ->
            Converter.update_input(model, Snippets.a())

          "ul" ->
            Converter.update_input(model, Snippets.ul())

          "hello" ->
            Converter.update_input(model, Snippets.hello())

          "bootstrap" ->
            Converter.update_input(model, Snippets.bootstrap_navbar())

          "zurb" ->
            Converter.update_input(model, Snippets.zurb_topbar())

          "spaces_2" ->
            Converter.update_indent(model, @indent_2)

          "spaces_4" ->
            Converter.update_indent(model, @indent_4)

          "tabs" ->
            Converter.update_indent(model, @indent_t)

          _ ->
            Logger.warn("Unknown button in #{__MODULE__}: #{inspect(message)}")
            model
        end

      %{"event" => "editor_changed", "content" => content} ->
        Converter.update_input(model, content)

      _ ->
        Logger.warn("Unknown message in #{__MODULE__}: #{inspect(message)}")
        model
    end
  end

  @impl Presto.Page
  def render(model) do
    div(class: "presto-component", id: "presto-component-12345") do
      div(id: "converter", "uk-height-viewport": "expand: true") do
        render_controls(model)
        render_workspace(model)
        render_helpers(model)
      end
    end
  end

  def render_controls(_model) do
    section(id: "controls") do
      div(class: "uk-grid-collapse uk-grid", "uk-grid": true) do
        div(class: "uk-width-1-2") do
          "Type or paste HTML here"
        end

        div(class: "uk-width-1-2") do
          "Converted output will appear here"
        end
      end
    end
  end

  def render_workspace(model) do
    section(id: "code", class: "uk-height-1-1") do
      div(id: "editor_shadow_input", style: "display: none") do
        model.input
      end

      div(class: "uk-grid-collapse uk-grid uk-height-1-1", "uk-grid": true) do
        # left panel
        div(class: "uk-width-1-2") do
          div(id: "editor", class: "uk-height-1-1", "up-keep": true) do
            model.input
          end
        end

        # right panel
        div(id: "code-panel", class: "uk-width-1-2", style: "overflow: auto") do
          pre do
            code(id: "output", class: "elixir") do
              model.output
            end
          end

          button(id: "clipboard", class: "copy-button", "data-clipboard-target": "#output") do
            "Copy"
          end
        end
      end
    end
  end

  def render_helpers(model) do
    section(id: "helpers", class: "uk-section-primary", "uk-sticky": "bottom: true") do
      div(class: "uk-grid-collapse uk-grid", "uk-grid": true) do
        div(class: "uk-width-1-2") do
          "Snippets:"

          snippet_button("a")
          snippet_button("ul")
          snippet_button("hello world")
          snippet_button("bootstrap navbar")
          snippet_button("zurb topbar")
        end

        div(class: "uk-width-1-2") do
          "Indent spaces:"

          indent_button(model, 2, "spaces_2", @indent_2)
          indent_button(model, 4, "spaces_4", @indent_4)
          indent_button(model, "tabs", "tabs", @indent_t)
        end
      end
    end
  end

  def snippet_button(text) do
    id = text |> String.split(" ") |> Enum.take(1)

    button(
      text,
      id: id,
      class: "presto-click uk-button uk-button-small uk-button-secondary"
    )
  end

  def indent_button(model, text, id, active_if) do
    button(
      text,
      id: id,
      class:
        "presto-click uk-button uk-button-small uk-button-secondary " <>
          activeIf(model, active_if)
    )
  end

  def activeIf(model, indent) do
    case model.indent == indent do
      true -> "active"
      false -> ""
    end
  end
end
