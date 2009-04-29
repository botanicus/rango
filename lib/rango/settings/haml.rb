# coding: utf-8

class Rango
  module Settings
    class Haml < Settings
      # @since 0.0.2
      # Determines the output format. The default is :xhtml. Other options are :html4 and :html5, which are identical to :xhtml except there are no self-closing tags, XML prolog is ignored and correct DOCTYPEs are generated. 
      hattribute :format, :xhtml

      # @since 0.0.2
      # Sets whether or not to escape HTML-sensitive characters in script. If this is true, = behaves like &=; otherwise, it behaves like !=. Note that if this is set, != should be used for yielding to subtemplates and rendering partials. Defaults to false. 
      hattribute :escape_html, lambda { Project.settings.autoescape }

      # @since 0.0.2
      # Whether or not attribute hashes and Ruby scripts designated by =  or ~ should be evaluated. If this is true, said scripts are rendered as empty strings. Defaults to false. 
      hattribute :suppress_eval, false

      # @since 0.0.2
      # The character that should wrap element attributes. This defaults to ' (an apostrophe). Characters of this type within the attributes will be escaped (e.g. by replacing them with &apos;) if the character is an apostrophe or a quotation mark.
      hattribute :attr_wrapper, '"'

      # @since 0.0.2
      # A list of tag names that should be automatically self-closed if they have no content. Defaults to ['meta', 'img', 'link', 'br', 'hr', 'input', 'area', 'param', 'col', 'base']. 
      hattribute :autoclose, %w[meta img link br hr input area param col base]

      # @since 0.0.2
      # A list of tag names that should automatically have their newlines preserved using the Haml::Helpers#preserve  helper. This means that any content given on the same line as the tag will be preserved. For example
      # %textarea= "Foo\nBar"
      # compiles to: 
      # <textarea>Foo&&#x000A;Bar</textarea>
      # Defaults to ['textarea', 'pre']. 
      hattribute :preserve, %w[textarea pre]
    end
  end
end
