require 'padrino-core'
require 'padrino-gen'
require 'padrino-helpers'

require 'rack-flash'

FileSet.glob_require('padrino-responders/*.rb', __FILE__)
FileSet.glob_require('padrino-responders/{helpers,notifiers}/*.rb', __FILE__)

module Padrino
  ##
  # This component is used to create slim controllers without unnecessery 
  # and repetitive code.
  #
  module Responders
    ##
    # Method used by Padrino::Application when we register the extension
    #
    class << self
      def registered(app)
        app.enable :sessions
        app.enable :flash
        app.helpers Padrino::Responders::Helpers::ControllerHelpers
        app.set :notifier, Padrino::Responders::Notifiers::FlashNotifier
        app.send :include, Padrino::Responders::Default
      end
      alias :included :registered
    end
  end
end

##
# Load our Padrino::Responders locales
#
I18n.load_path += Dir["#{File.dirname(__FILE__)}/padrino-responders/locale/**/*.yml"]

