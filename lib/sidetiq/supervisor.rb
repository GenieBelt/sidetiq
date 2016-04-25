module Sidetiq
  class Supervisor

    class << self
      include Logging

      def clock
        run! unless @clock
        @clock
      end

      def handler
        run! if @handler.nil?
        @handler
      end

      def run!
        motd
        info "Sidetiq::Supervisor start"
        @clock = Sidetiq::Actor::Clock.new
        @handler = Sidetiq::Actor::Handler.new
        #super
      end

      def run
        raise "Sidetiq::Supervisor should not be run in foreground."
      end

      private

      def motd
        info "Sidetiq v#{VERSION::STRING} - Copyright (c) 2012-2013, Tobias Svensson <tob@tobiassvensson.co.uk>"
        info "Sidetiq is covered by the 3-clause BSD license."
        info "See LICENSE and http://opensource.org/licenses/BSD-3-Clause for licensing details."
      end
    end
  end
end
