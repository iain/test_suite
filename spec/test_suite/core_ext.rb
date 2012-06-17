# Unfortunately, having pretty tables with ASCCI box art, is a tough thing to
# get working on all the different Ruby implementations. To make it a bit more
# workable, I'll introduce the String#force_encoding method for Ruby versions
# that don't have them yet. Older Ruby versions don't do encoding, so we can
# just use the original string.

unless "".respond_to?(:force_encoding)
  class String
    def force_encoding(*)
      self
    end
  end
end
