defprotocol TypeClass.Property.Equal do
  @moduledoc ~S"""
  Equality protocol for property checks.
  """

  @fallback_to_any true

  @doc ~S"""
  Check equality of datatype.
  Allows customization for tricky edge cases

  ## Examples
      
      defimpl TypeClass.Property.Equal, for: Float do
        def equal?(a, b), do: Float.round(a, 5) == Float.round(b, 5)
      end

  """
  def equal?(a, b)
end

defimpl TypeClass.Property.Equal, for: Any do
  @moduledoc false

  def equal?(a, b) do
    a == b
  end
end


defimpl TypeClass.Property.Equal, for: Function do
  @moduledoc false

  def equal?(a, b) do
    a.("foo") == b.("foo")
  end
end

defimpl TypeClass.Property.Equal, for: Float do
	@moduledoc false

 @doc ~S"""
  Only check float accuracy to 5 decimal places due to internal rounding
  mismatches from applying functions in differing order. This isn't totally theoretically
  accurate, but is in line with the spirit of Floats.
  """
	def equal?(a, b) do
		Float.round(a, 5) == Float.round(b, 5)
	end
end

