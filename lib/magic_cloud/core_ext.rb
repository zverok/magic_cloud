# as per http://stackoverflow.com/questions/3476969/rotate-bits-right-operation-in-ruby
# imitating JS's >>>
class Integer
  def ror(count)
    (self >> count) | (self << (32 - count)) & 0xFFFFFFFF
  end
end
