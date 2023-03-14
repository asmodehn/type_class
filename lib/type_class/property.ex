defmodule TypeClass.Property do
  @moduledoc "A *very* simple prop checker"

  @doc "Ensure that the type class has defined properties"
  @spec ensure!() :: no_return()
  defmacro ensure! do
    quote do
      case Code.ensure_loaded(__MODULE__.Property) do
        {:module, _prop_submodule} ->
          nil

        {:error, :nofile} ->
          raise TypeClass.Property.UndefinedError.new(__MODULE__)
      end
    end
  end

  @doc "Run all properties for the type class"
  @spec run!(module(), module(), atom(), non_neg_integer()) :: no_return()
  def run!(datatype, class, prop_name, times \\ 100) do
    property_module = Module.concat(class, Property)
    custom_generator = Module.concat([class, "Proto", datatype]).__custom_generator__()

    data_generator =
      if custom_generator do
        custom_generator
      else
        Module.concat(TypeClass.Property.Generator, datatype).generate(nil)
      end

    fn ->
      unless apply(property_module, prop_name, [data_generator]) do
        raise TypeClass.Property.FailedCheckError.new(datatype, class, prop_name)
      end
    end
    |> Stream.repeatedly()
    |> Enum.take(times)
  end

  @doc ~S"""
  Check for equality while handling special cases that normally don't equate in Elixir.
  """
  @spec equal?(any(), any()) :: boolean()
  def equal?(left, right) do
    TypeClass.Property.Equal.equal?(left, right)
  end
end
