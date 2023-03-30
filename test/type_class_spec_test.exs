defmodule TypeClassTest do
  use ExUnit.Case

  import TypeClass


  classtest Functor, for: List


end
