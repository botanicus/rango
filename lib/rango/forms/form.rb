# coding=utf-8

# class ContactForm < Rango::Form
#   property :subject, String
#   property :message, Text
#   property :cc_self, Boolean
# end

# @future 0.0.3 It's just a prototype now
class Rango
  class Form
    attribute :media

    def valid?
    end
    
    def to_html
      output = Array.new
      output << %{<form action="#{@action}" method="post">}
      output << *@fields.map { |field| field.to_html }
      output << %{</form>}
      return output.join("\n")
    end
  end
  
  class ModelForm
    
  end
end
