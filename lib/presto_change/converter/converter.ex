defmodule PrestoChange.Converter do
  alias Taggart.Convert.HTMLToTaggart
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
