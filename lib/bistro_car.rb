require 'jsmin'
require 'bistro_car/bundle'
require 'bistro_car/helpers'

module BistroCar
  VERSION = "0.2.2"
  COMMAND = "coffee -s -p --no-wrap"

  if defined?(Rails::Engine)
    class Engine < Rails::Engine
      engine_name :bistro_car
    end
  end
  
  class << self
    def compile(source)
      if File.exist? source
        %x(#{COMMAND} < #{source})
      else
        %x(echo "#{source.gsub(/"/, '\"')}" | #{COMMAND})
      end
    end
  
    attr_accessor :mode, :minify
  end
end

BistroCar.mode = :bundled
BistroCar.minify = true if defined?(Rails) and Rails.env.production?
