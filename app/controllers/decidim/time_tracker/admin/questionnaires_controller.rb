# frozen_string_literal: true

module Decidim
  module TimeTracker
    module Admin
      class QuestionnairesController < Admin::ApplicationController
        include Decidim::Forms::Admin::Concerns::HasQuestionnaire

        def questionnaire_for
          time_tracker
        end

        def update_url
          EngineRouter.admin_proxy(current_component).questionnaire_path
        end

        def after_update_url
          EngineRouter.admin_proxy(current_component).root_path
        end

        def answer_options_url(params)
          EngineRouter.admin_proxy(current_component).answer_options_questionnaire_path(format: :json, **params)
        end
      end
    end
  end
end