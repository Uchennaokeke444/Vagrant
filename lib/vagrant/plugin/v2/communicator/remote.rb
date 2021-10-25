module Vagrant
  module Plugin
    module V2
      class Communicator
        # This module enables Communicator for server mode
        module Remote

          # Add an attribute accesor for the client
          # when applied to the Communicator class
          def self.prepended(klass)
            klass.class_eval do
              attr_accessor :client
            end
          end

          def initialize(machine)
            @logger = Log4r::Logger.new("vagrant::communicator")
            @logger.debug("initializing communicator with remote baackend")
            @machine = machine
            @client = machine.client.communicate
          end

          def ready?
            @logger.debug("remote communicator, checking if it's ready")
            @client.ready(@machine)
          end

          def wait_for_ready(time)
            @logger.debug("remote communicator, waiting for ready")
            @client.wait_for_ready(@machine, time)
          end

          def download(from, to)
            @logger.debug("remote communicator, downloading #{from} -> #{to}")
            @client.download(@machine, from, to)
          end

          def upload(from, to)
            @logger.debug("remote communicator, uploading #{from} -> #{to}")
            @client.upload(@machine, from, to)
          end

          def execute(cmd, opts=nil)
            @logger.debug("remote communicator, executing command")
            @client.execute(@machine, cmd, opts)
          end
  
          def sudo(cmd, opts=nil)
            @logger.debug("remote communicator, executing (privileged) command")
            @client.privileged_execute(@machine, cmd, opts)
          end

          def test(cmd, opts=nil)
            @logger.debug("remote communicator, testing command")
            @client.test(@machine, cmd, opts)
          end

          def reset!
            @logger.debug("remote communicator, reseting")
            @client.reset(@machine)
          end
          
          def to_proto
            client.proto
          end
        end
      end
    end
  end
end
