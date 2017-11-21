defmodule PrestoChange.ConverterTest do
  use ExUnit.Case

  alias PrestoChange.Converter
  # doctest Converter

  test "has a PageState struct with defaults" do
    ps = Converter.new()

    assert ps.input == ""
    assert ps.output == ""
    assert ps.indent.spaces == 2
  end

  test "updates input" do
    ps =
      Converter.new()
      |> Converter.update_input("some string")

    assert ps.input == "some string"
  end

  test "indents with 2 spaces" do
    ps =
      Converter.new()
      |> Converter.update_input("<div>foo</div>")

    assert ps.output == "div do\n  \"foo\"\nend"
  end

  test "indents with 4 spaces" do
    ps =
      Converter.new()
      |> Converter.update_indent(Converter.Indent.Spaces.new(4))
      |> Converter.update_input("<div>foo</div>")

    assert ps.output == "div do\n    \"foo\"\nend"
  end

  test "indents with tabs" do
    ps =
      Converter.new()
      |> Converter.update_indent(Converter.Indent.Tabs.new())
      |> Converter.update_input("<div>foo</div>")

    assert ps.output == "div do\n\t\"foo\"\nend"
  end
end
