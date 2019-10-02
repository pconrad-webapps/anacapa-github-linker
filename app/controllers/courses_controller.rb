require 'Octokit_Wrapper'
require 'json'
class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.all
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
  end

  # # GET /courses/new
  # def new
  #   @course = Course.new
  # end

  # GET /courses/1/edit
  def edit
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(course_params)
    respond_to do |format|
      if @course.save
        add_instructor(@course.id)
        @course.accept_invite_to_course_org
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render :show, status: :created, location: @course }
      else
        format.html { render :new }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
    update_webhooks
  end

  # PATCH/PUT /courses/1
  # PATCH/PUT /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
    update_webhooks
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course.destroy
    respond_to do |format|
      format.html { redirect_to courses_url, notice: 'Course was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def view_ta
    @course = Course.find(params[:course_id])
    authorize! :view_ta, @course
  end

  def update_ta
    course = Course.find(params[:course_id])
    authorize! :update_ta, course

    user = User.find(params[:user_id])
    user.change_ta_status(course)
    redirect_to course_view_ta_path(course), notice: %Q[Successfully modified #{user.name}'s TA status]

  end

  def join
    course = Course.find(params[:course_id])
    # roster_student = course.roster_students.find_by(email: current_user.email)
    roster_student = cross_check_user_emails_with_class(course)
    if roster_student.nil?
      message = 'Your email did not match the email of any student on the course roster. Please check that your github email is correctly configured to match your school email and that you have verified your email address. '
      return redirect_to courses_path, alert: message
    end
    
    begin
       course.invite_user_to_course_org(current_user)
       roster_student.update_attribute(:enrolled, true)
       current_user.roster_students.push(roster_student)
       redirect_to courses_path, notice: %Q[You were successfully invited to #{course.name}! View and accept your invitation <a href="https://github.com/orgs/#{course.course_organization}/invitation">here</a>.]
    rescue Exception => e
      message = "Unable to invite #{current_user.username} to #{course.course_organization}; check whether #{ENV['MACHINE_USER_NAME']} has admin permission on that org.   Error: #{e.message}"
      redirect_to courses_path, alert: message
    end
  end

    # Format of return from org_hooks is this:
    # [{:type=>"Organization",
    #   :id=>145482900,
    #   :name=>"web",
    #   :active=>true,
    #   :events=>["push"],
    #   :config=>
    #     {:content_type=>"json",
    #     :secret=>"********",
    #     :url=>"http://localhost:3000/github_webhooks",
    #     :insecure_ssl=>"0"},
    #   :updated_at=>2019-10-02 20:10:54 UTC,
    #   :created_at=>2019-10-02 20:10:54 UTC,
    #   :url=>"https://api.github.com/orgs/test-course-org/hooks/145482900",
    #   :ping_url=>
    #     "https://api.github.com/orgs/test-course-org/hooks/145482900/pings"}
    # ]

  def update_webhooks
    return if ENV['GITHUB_WEBHOOK_SECRET'].nil?
    begin
      all_existing_hooks = machine_user.org_hooks(@course.course_organization)
    rescue Exception => e
      logger.error "Failed to get existing webhooks for org: #{@course.course_organization}"
      logger.error "Check whether machine_user has admin:org_hooks"
      logger.error "Exception info: "
      logger.error e.message
      logger.error e.backtrace.inspect
      return
    end  
    logger.info "Existing Hooks for #{@course.name}, org: #{@course.course_organization}, result: #{sawyer_to_s(all_existing_hooks)}"

    webhook_url = "#{request.base_url}/github_webhooks"
    if @course.enable_web_hooks and all_existing_hooks.empty?
      result = machine_user.create_org_hook(
        @course.course_organization,
        {
          :url => webhook_url,
          :content_type => 'json',
          :secret => ENV['GITHUB_WEBHOOK_SECRET']
        },
        {
          :events => ['*'],
          :active => true
        }
      )
      logger.info "Attempted adding webhook for course: #{@course.name}, org: #{@course.course_organization}, result: #{sawyer_to_s(result)}"
    elsif not @course.enable_web_hooks and  not all_existing_hooks.empty?
      all_existing_hooks.each do |hook|
        result = machine_user.remove_org_hook(@course.course_organization, hook[:id])
        logger.info "Attempted removing webhook for course: #{@course.name}, org: #{@course.course_organization}, hook: #{sawyer_to_s(hook)}, result: #{result}"
      end
    end
  end
  private

    # Convert Sawyer::Resource returned by Octokit to printable string for logging
    def sawyer_to_s(s)
      s.kind_of?(Array) ? s.map(&:to_h).to_json : s.to_json
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def course_params
      params.require(:course).permit(:name,:course_organization,:hidden,:enable_web_hooks)
    end

    def add_instructor(id)
      current_user.add_role :instructor, Course.find(id)
    end

    def session_user
      client = Octokit_Wrapper::Octokit_Wrapper.session_user(session[:token])
    end

    def machine_user
      client = Octokit_Wrapper::Octokit_Wrapper.machine_user
    end


    def cross_check_user_emails_with_class(course)
      email_to_student = Hash.new
      course.roster_students.each do |student|
        email_to_student[student.email] = student
        if student.email.end_with? '@umail.ucsb.edu'
          new_email = student.email.gsub('@umail.ucsb.edu','@ucsb.edu')
          email_to_student[new_email] = student
        elsif student.email.end_with? '@ucsb.edu'
          old_email = student.email.gsub('@ucsb.edu','@umail.ucsb.edu')
          email_to_student[old_email] = student
        end
      end

      session_user.emails.each do |email|
        roster_student = email_to_student[email[:email]]
        if roster_student
          return roster_student
        end
      end
      return nil
    end

end
