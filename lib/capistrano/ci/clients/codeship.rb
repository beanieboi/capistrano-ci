module Capistrano
  module CI
    module Clients
      class Codeship < Base
        base_uri "https://www.codeship.io/"

        def initialize(settings = {})
          @project_uuid = settings[:ci_access_token]
        end

        def passed?(branch_name)
          state(branch_name) == "success"
        end

        def state(branch_name)
          branch(branch_name)
        end

        private

        def project_url(branch_name)
          "/projects/#{@project_uuid}/status?branch=#{branch_name}"
        end

        def branch(branch_name)
          content_image(branch_name).scan(/status_(.*).png/).flatten.first
        end

        def content_image(branch_name)
          HTTParty.get(self.class.base_uri +
                        project_url(branch_name)).headers['Content-Disposition'].split("\"").last
        end
      end
    end
  end
end

