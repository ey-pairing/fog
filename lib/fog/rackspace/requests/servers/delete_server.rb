unless Fog.mocking?

  module Fog
    module Rackspace
      class Servers

        # Delete an existing server
        #
        # ==== Parameters
        # * id<~Integer> - Id of server to delete
        #
        def delete_server(server_id)
          request(
            :expects => 202,
            :method => 'DELETE',
            :path   => "servers/#{server_id}"
          )
        end

      end
    end
  end

else

  module Fog
    module Rackspace
      class Servers

        def delete_server(server_id)
          response = Fog::Response.new
          if server = Fog::Rackspace::Servers.data[:servers][server_id]
            if server['STATUS'] == 'BUILD'
              response.status = 409
              raise(Excon::Errors.status_error(202, 400, response))
            else
              Fog::Rackspace::Servers.data.delete(server_id)
              response.status = 202
            end
          else
            response.status = 404
            raise(Excon::Errors.status_error(202, 404, response))
          end
          response
        end

      end
    end
  end

end
