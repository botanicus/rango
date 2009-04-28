# coding: utf-8

class Rango::GenericViews < Rango::Controller
  def static(template)
    render(template)
  end
end
