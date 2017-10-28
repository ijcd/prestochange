defmodule PrestoChange.Converter do
  alias PrestoChange.HTMLToTaggart
  alias PrestoChange.Snippets  

  defmodule PageState do
    defstruct [
      input: "",
      output: "",
      indent_spaces: 2,
    ]
  end

  def set_snippet(ps, sym) do
    snippet = case sym do
                :a -> Snippets.a
                :ul -> Snippets.ul
                :hello -> Snippets.hello
                :bootstrap -> Snippets.bootstrap_navbar
                :zurb -> Snippets.zurb_topbar
              end

    update_input(ps, snippet)
  end

  def update_input(ps, input) do
    output = HTMLToTaggart.html_to_taggart(input)

    %{ps | input: input, output: output}
  end

  # def button(id: "a") do
  #   %{"snippet" => Snippets.a}
  # end

  # def button(id: "ul") do
  #   %{"snippet" => Snippets.ul}
  # end

  # def button(id: "hello") do
  #   %{"snippet" => Snippets.hello}
  # end

  # def button(id: "bootstrap") do
  #   %{"snippet" => Snippets.bootstrap_navbar}
  # end

  # def button(id: "zurb") do
  #   %{"snippet" => Snippets.zurb_topbar}
  # end
end

