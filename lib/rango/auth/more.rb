# Register the strategies so that plugins and apps may utilize them
basic_path = File.expand_path(File.dirname(__FILE__)) / "more" / "strategies" / "basic"

Rango::Authentication.register(:default_basic_auth,    basic_path / "basic_auth.rb")
Rango::Authentication.register(:default_openid,        basic_path / "openid.rb")
Rango::Authentication.register(:default_password_form, basic_path / "password_form.rb")

Rango.import("auth/more/mixins/redirect_back")
