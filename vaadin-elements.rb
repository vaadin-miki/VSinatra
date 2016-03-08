# Vaadin Elements Ruby Wrapper

module HashExtension
  def method_missing(name, *params, &block)
    name = name.to_s
    params = params.first if params.size == 1

    # call block or use params if provided, and is assigning
    return self[name[0..-2]] = ((block && block.call(binding)) || params) if name.to_s.end_with?("=")
    # boolean check if ends with ?
    return !self[name[0..-2]].nil? if name.to_s.end_with?("?")
    # return value otherwise
    self[name]
  end
end

module Vaadin
  class Elements < Hash
    AVAILABLE = %w{vaadin-grid vaadin-combo-box vaadin-date-picker}

    include HashExtension

    def initialize
      super {|h, k| h[k] = Elements.new}
    end

  end
end