module Courses 
  class HookEventsController < ApplicationController
    before_action :load_course
    before_action :set_hook_event, only: [:show, :destroy]
    load_and_authorize_resource :course
    #load_and_authorize_resource :hook_event, through: :course

    # GET /hook_events
    # GET /hook_events.json
    def index
      @hook_events =  @course.hook_events.all
    end

    # GET /hook_events/1
    # GET /hook_events/1.json
    def show
      @hook_event = @course.hook_events.find(params[:id])
    end

    # DELETE /hook_events/1
    # DELETE /hook_events/1.json
    def destroy
      @hook_event = @course.hook_events.find(params[:id])
      @hook_event.destroy
      respond_to do |format|
        format.html { redirect_to course_hook_events_path(@course), notice: 'Hook event was successfully destroyed.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_hook_event
        @hook_event = HookEvent.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def hook_event_params
        params.require(:hook_event).permit(:hooktype, :content)
      end

      def load_course
        @course = Course.find(params[:course_id])
      end
  end
end