# frozen_string_literal: true

require "spec_helper"

module Decidim::TimeTracker
  describe TimeTrackerController, type: :controller do
    routes { Decidim::TimeTracker::Engine.routes }

    let(:organization) { create :organization }
    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:participatory_space) { create(:participatory_process, organization: organization) }
    let(:component) { create :time_tracker_component, participatory_space: participatory_space }
    let(:time_tracker) { create :time_tracker, component: component }
    let!(:milestone) { create :milestone, activity: activity, user: assignations.first.user }
    let!(:activity) { create :activity, task: task }
    let!(:task) { create :task, time_tracker: time_tracker }
    let!(:assignations) { create_list :assignation, 3, :accepted, activity: activity }

    before do
      request.env["decidim.current_organization"] = organization
      request.env["decidim.current_participatory_space"] = participatory_space
      request.env["decidim.current_component"] = component
      sign_in user
    end

    describe "GET #index" do
      it "renders the index listing" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(controller.helpers.tasks.count).to eq(1)
        all = controller.helpers.assignation_milestones(activity)
        expect(all).to include(milestone)
        expect(subject).to render_template(:index)
      end
    end
  end
end
