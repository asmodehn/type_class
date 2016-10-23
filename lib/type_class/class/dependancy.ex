defmodule TypeClass.Class.Dependancy do

  use TypeClass.Utility.Attribute
  use Quark

  defmacro __using__(_) do
    quote do
      alias   unquote(__MODULE__)
      require unquote(__MODULE__)

      unquote(__MODULE__).set_up
    end
  end

  @keyword :extend

  defmacro set_up do
    quote do
      Attribute.register(unquote(@ketword), accumulate: true)
    end
  end

  defmacro run do
    quote do
      create_dependancies_meta
      create_use_dependancies
    end
  end

  defmacro create_dependancies_meta do
    quote do
      def __DEPENDANCIES__ do
        __MODULE__
        |> Attribute.get(unquote(@keyword))
        |> Enum.map(Utility.Module.to_protocol <~> Protocol.assert_impl!)
      end
    end
  end

  defmacro create_use_dependancies do
    quote do
      __DEPENDANCIES__
      |> Enum.map(&(Kernel.use(&1, :class)))
      |> unquote_splicing
    end
  end
end
