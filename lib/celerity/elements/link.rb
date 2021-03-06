module Celerity
  class Link < Element
    include ClickableElement

    TAGS = [ Identifier.new('a') ]
    ATTRIBUTES = BASE_ATTRIBUTES | [:charset, :type, :name, :href, :hreflang,
                                    :target, :rel, :rev, :accesskey, :shape,
                                    :coords, :tabindex, :onfocus, :onblur]
    DEFAULT_HOW = :href
  end

end