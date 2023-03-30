
import TypeClass

defclass Functor do
	where do
	  def fmap(enum, fun)
	end

	properties do
	  def for_loop_equivalent(data) do
	    val = generate(data)
	    # TODO : actual test with any function...
	    Functor.fmap(val, &Function.identity/1) == Enum.map(val, &Function.identity/1)
	    # is_nil(val)  # for failure tests
	  end
	end
end

definst Functor, for: List do
	def fmap(enum, fun), do: Enum.map(enum, fun)
end