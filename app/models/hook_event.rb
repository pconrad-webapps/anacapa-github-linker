require 'json'
class HookEvent < ApplicationRecord
    belongs_to :course, optional: true

    def pretty_json
        JSON.pretty_generate(hash)
    end

    def hash
        @hash ||= JSON.parse(content)
    end

    def sender
        hash['sender']
    end
  
    def sender_name
        sender.nil? ? "" : sender['login']
    end

    def organization
        hash['organization']
    end

    def org_name
        organization.nil? ? "" : organization['login']
    end

    def repository
        hash['repository']
    end

    def repo_name
        repository.nil? ? "" : repository['name']
    end
end
