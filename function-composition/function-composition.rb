=begin
 Ruby actually has spectacular support for some of the crucial building blocks of functional 
 programming; most importantly, support for a concept called function composition.

 The only named concept in Ruby that isn’t implemented as an object is a function.
 Consider following example

 [1, 2, 3].map { |num| num * 2 }
 When we pass a block to a method, like here in Array#map, we’re using that block as a 
 function that is applied to each element in that array.  

 
 def apply_map(array, &block)
  array.map(&block)
 end

  apply_map([1,2,3]) { |num| num * 2 }
  
  This ‘apply_map’ method does the exact same thing as before, but with a bit more indirection. 
  Here we are “capturing” the block passed to the method and then applying it to Array#map.

  But in reality what we’re doing here is taking that block and turning it into an instance of the Proc class.
  If you check it class of the block passed it shows #Proc.

  def apply_map(array, &block)
    block.class # => Proc
    array.map(&block)
  end

  Procs are objects that behave like functions, but because they’re objects, they have some really interesting methods that we can call that give us a lot of powerful tools to use.

  We can also create an instance of the Proc class in several other ways.
  We can explicitly create a new proc using Proc.new().
  There’s also a shorthand global method called proc.
  When we want to actually execute the function that the Proc represents, we send it the call message.

  times_two = proc { |num| num * 2 }
  times_two.call(3)


  Example: 
  total = 10.20
  add_tax = Proc.new() { |total| total * 1.06 }
  subtract_discount = Proc.new() { |total| total * 0.9 }
  subtotal = subtract_discount.call(add_tax.call(total))

  What we have here works, but it’s not really nice to work with. For a few reasons:
  - In order to understand the order of operations, we effectively have to read it right-to-left
  - There’s a sort of false hierarchy here: adding tax is visually buried within substracting the 
    discount

  Instead of doing these calculations inline, we could extract a new concept 
  called calculate_subtotal by making a proc that combines the two.  

  total = 10.20
  add_tax = Proc.new() { |total| total * 1.06 }
  subtract_discount = proc {|total| total * 0.9 }
  calculate_subtotal = proc {|total|  subtract_discount.call(add_tax.call(total)) }
  calculate_subtotal.call(total)

  Combining two functions in this fashion is known as function composition.

  From Ruby 2.6 there is support for Function composition.

  Instead of explicitly creating a third proc, we can directly compose these two functions 
  into a third using the compose-to-right operator.

  total = 10.20
  add_tax = proc { |total| total * 1.06 }
  subtract_discount = proc { |total| total * 0.9 }
  calculate_subtotal = add_tax >> subtract_discount
  calculate_subtotal.call(total)

  If in future order of calculation changes we can sign of the operator instead of variables name
  See below coding example
=end

total = 10.20
add_tax = proc { |total| total * 1.06 }
subtract_discount = proc { |total| total * 0.9 }
calculate_subtotal = add_tax << subtract_discount 
calculate_subtotal.call(total)
