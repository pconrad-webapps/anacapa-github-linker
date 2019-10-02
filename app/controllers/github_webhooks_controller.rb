require 'json'
class GithubWebhooksController < ActionController::Base
    include GithubWebhook::Processor
    before_action :process_github_event, only: :create

    #  # Handle push event
    #  def github_push(payload)
    #   logger.info "push webhook payload:#{payload}"
    #  end

    #   # Handle create event
    #   def github_create(payload)
    #     logger.info "create webhook payload:#{payload}"
    #   end

    #   def github_ping(payload)
    #     logger.info "ping webhook payload:#{payload}"
    #   end

    def webhook_secret(payload)
      ENV['GITHUB_WEBHOOK_SECRET']
    end
  
    def new_org_permissions_header
      { accept: 'application/vnd.github.ironman-preview+json' }
    end

    def sender
      json_body[:sender]
    end

    def sender_name
      sender.nil? ? "" : sender[:login]
    end

    def organization
      json_body[:organization]
    end

    def org_name
      (organization.nil? ? "" :  organization[:login])
    end

    def repository
      json_body[:repository]
    end

    def repo_name
      (repository.nil? ? "" : repository[:name])
    end

    def event
      request.headers['X-GitHub-Event'].to_sym
    end

    def process_github_event
      log_github_event
      course = Course.where(course_organization: org_name).first
      if course.nil?
        logger.info "Hook for course that can't be found"
        return
      end
      logger.info "Hook is for @course.name: #{course.name} @course.course_organization: #{course.course_organization}"
      hook_event = course.hook_events.new
      hook_event.hooktype = event
      hook_event.content = json_body.to_json
      hook_event = hook_event.save!
    end  

    def log_github_event
      logger.info <<-eos

        ***** Github Hook: *********** 
          organization: #{org_name}
                sender: #{sender_name}       
            repository: #{repo_name}   
          event_method: #{event}
             json_body: #{JSON.pretty_generate(json_body)}
        ***** End GitHub hook ******** 

      eos
    end  

    def create
      if self.respond_to?(event_method, true)
        self.send event_method, json_body
      else
        # raise NoMethodError.new("GithubWebhooksController##{event_method} not implemented")
      end
      head(:ok)
    end

  end
