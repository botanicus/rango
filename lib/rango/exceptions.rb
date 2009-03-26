class SettingsNotFound < StandardError
end

class AnyStrategyMatched < StandardError
end

# superclass of all the controller exceptions
class Rango
  class ControllerExceptions
  end

  class Error404 < ControllerExceptions
  end
  
  class Error500 < ControllerExceptions
  end
end