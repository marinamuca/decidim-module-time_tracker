# frozen_string_literal: true

module Decidim
  module TimeTracker
    module Admin
      class TasksController < Admin::ApplicationController
        helper_method :tasks

        def index
          @tasks
        end

        def new
          # enforce_permission_to :create, :task

          @form = form(TaskForm).instance
        end

        def edit
          enforce_permission_to :update, :task, task: current_task
          @form = form(TaskForm).from_model(current_task, endpoint: current_task)
        end

        def create
          # enforce_permission_to :create, :task

          @form = form(TaskForm).from_params(params)

          CreateTask.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("task.create.success", scope: "decidim.time_tracker.admin")
              redirect_to tasks_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("task.create.error", scope: "decidim.time_tracker.admin")
              render :new
            end
          end
        end

        def update
          enforce_permission_to :update, :task, task: current_task

          form = form(TaskForm).from_params(params, task: current_task)

          UpdateTask.call(current_task, form, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("task.update.success", scope: "decidim.time_tracker.admin")
              redirect_to tasks_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("task.update.error", scope: "decidim.time_tracker.admin")
              render :edit
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :task, task: current_task

          DestroyTask.call(current_task, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("taks.destroy.success", scope: "decidim.time_tracker.admin")
              redirect_to tasks_path
            end
          end
        end

        private

        def time_tracker
          @time_tracker = Decidim::TimeTracker::TimeTracker.find_by(component: current_component)
        end

        def tasks
          @tasks = Decidim::TimeTracker::Task.where(time_tracker: time_tracker.id)
        end

        def current_task
          @current_task ||= Task.find(params[:id])
        end
      end
    end
  end
end
