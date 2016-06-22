module Ruboty
  module Github
    module Actions
      class LabelIssue < Base
        def call
          if !has_access_token?
            require_access_token
          else
            label
          end
        rescue Octokit::Unauthorized
          message.reply("Failed in authentication (401)")
        rescue Octokit::NotFound
          message.reply("Could not find that issue")
        rescue => exception
          message.reply("Failed by #{exception.class}")
          raise exception
        end

        private

        def label
          client.update_issue(repository, issue_number, labels: labels)
        end

        def issue_number
          message[:number]
        end

        def labels
          message[:labels].split(',').map(&:strip)
        end
      end
    end
  end
end
