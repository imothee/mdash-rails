# frozen_string_literal: true

module Mdash
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy Mdash default files"
      source_root File.expand_path("templates", __dir__)

      def copy_config
        template "config/initializers/mdash.rb.tt", "config/initializers/mdash.rb"
      end
    end
  end
end