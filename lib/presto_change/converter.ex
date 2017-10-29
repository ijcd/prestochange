defmodule PrestoChange.Converter do
  alias PrestoChange.HTMLToTaggart
  alias PrestoChange.Snippets

  import Algae

  defmodule Indent do
    defsum do
      defdata Spaces :: integer() \\ 2
      defdata Tabs   :: none()
    end
  end

  defdata do
    input   :: String.t()
    output  :: String.t()
    indent  :: PrestoChange.Converter.Indent.t()
  end

  @spec update_input(t(), String.t) :: t()
  def update_input(ps, input) do
    update_output(%{ps | input: input})
  end

  def update_indent(ps, indent) do
    update_output(%{ps | indent: indent})
  end

  @spec update_output(t()) :: t()
  defp update_output(ps) do
    output = case ps.indent do
               %Indent.Spaces{spaces: n} ->
                 HTMLToTaggart.html_to_taggart(ps.input, String.duplicate(" ", n))
               %Indent.Tabs{} ->
                 HTMLToTaggart.html_to_taggart(ps.input, "\t")
             end

    %{ps | output: output}
  end  
end

# ps = ps |> Converter.set_snippet(:a)
# assert ps.input == Snippets.a

# ps = ps |> Converter.set_snippet(:ul)
# assert ps.input == Snippets.ul

# ps = ps |> Converter.set_snippet(:hello)
# assert ps.input == Snippets.hello

# ps = ps |> Converter.set_snippet(:bootstrap)
# assert ps.input == Snippets.bootstrap_navbar

# ps = ps |> Converter.set_snippet(:zurb)
# assert ps.input == Snippets.zurb_topbar

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
