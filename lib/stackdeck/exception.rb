
module StackDeck
  module ExceptionSupport
    def higher_stack_deck; @higher_stack_deck ||= []; end
    def stack_deck
      deck = []
      deck.concat(internal_stack_deck || []) if respond_to? :internal_stack_deck
      deck.concat higher_stack_deck
      deck.concat StackDeck::Frame::Ruby.extract(backtrace) if backtrace
      deck.compact!
      StackDeck.apply_boundary!(deck)
      deck
    end
    def copy_ruby_stack_to_deck(ignored_part=caller)
      upper_backtrace, lower_backtrace = StackDeck.split_list(backtrace, ignored_part)
      higher_stack_deck.concat StackDeck::Frame::Ruby.extract(upper_backtrace)
      set_backtrace lower_backtrace
    end
  end
end

class Exception
  include StackDeck::ExceptionSupport
end

