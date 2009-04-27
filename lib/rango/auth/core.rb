# make sure we're running inside Rango::

Rango.dependency 'extlib'

Rango.import 'auth/core/authentication'
Rango.import 'auth/core/strategy'
Rango.import 'auth/core/session_mixin'
Rango.import 'auth/core/errors'
Rango.import 'auth/core/responses'
Rango.import 'auth/core/authenticated_helper'
Rango.import 'auth/core/callbacks'

Rango::Controller.send(:include, Rango::AuthenticatedHelper)
