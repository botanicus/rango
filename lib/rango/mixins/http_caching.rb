# encoding: utf-8

module Rango
  module HttpCaching
    def self.included(base)
      base.send(:include, LastModified)
      base.send(:include, ETag)
    end

    module LastModified
      def self.included(base)
        Rango.logger.debug("LastModified-based caching mixin included to #{self.inspect}")
        base.before_render_filters.push(:check_last_modified_for_template)
        base.before_display_filters.push(:check_last_modified_for_object)
        base.after_display_filters.push(:set_last_modified_for_object)
        base.after_render_filters.push(:set_last_modified_for_template)
        # Cache-Control: must-revalidate means that browser must send validation request every time even if there is already cache entry exists for this object.
        base.headers["Cache-Control"] = "must-revalidate" unless base.headers["Cache-Control"]
      end

      # set headers
      # after display
      def set_last_modified_for_object(object, result)
        if self["Last-Modified"].nil? || self["Last-Modified"] < object.updated_at
          self["Last-Modified"] = object.updated_at
        end
      end

      # after render
      def set_last_modified_for_template(template)
        if self["Last-Modified"].nil? || self["Last-Modified"] < template.mtime
          self["Last-Modified"] = template.mtime
        end
      end

      # check headers
      # before render
      def check_last_modified_for_template(template)
        template.last_modified
      end

      # TODO: last modified for static files as JS, CSS ... (middleware)
      # before display
      def check_last_modified_for_object(object)
        last_modified = [object.updated_at, template.mtime].max
        raise NotModified if request.if_modified_since < last_modified
      end
    end

    module ETag
      def self.included(base)
        Rango.logger.debug("ETag-based caching mixin included to #{self.inspect}")
        base.after_render_filters.push(:check_etag)
        base.after_render_filters.push(:set_etag)
        # Cache-Control: must-revalidate means that browser must send validation request every time even if there is already cache entry exists for this object.
        base.headers["Cache-Control"] = "must-revalidate" unless base.headers["Cache-Control"]
      end

      # set headers
      # after render
      def set_etag(template)
        self["Http-Etag"] = template.render.hash.to_s
      end

      # check headers
      # Rango::Controller#display use it
      # server sends HTTP ETAG
      # client sends HTTP_IF_NONE_MATCH
      # This method suits for cases when it’s difficult to maintain Last-Modified value: when you have complicated application with many page fragments especially if there are third-party libraries. Or for the case with authentication, when page content depends on authentication info.
      # Etag is useful for dynamic content, when modify time is not known. In this case Etage can be
      # generated from hash (md5/sha) of content.
      # after render
      def check_etag(result)
        raise NotModified if request.etag.eql?(result.hash)
      end
    end
  end
end
