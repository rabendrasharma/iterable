require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe "POST #create" do
    context "when creating event type A" do
      before do
        @user = User.create(email: "test@example.com", password: "password")
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(@user)
        @event = Event.create(event_name: "demo event", user_id: @user.id, email: @user.email)
      end

      it "creates Event A successfully" do
        post :create, params: { event: { event_name: "Event A", event_type: "A" } }
        expect(response).to redirect_to(event_path(Event.last))
        expect(flash[:notice]).to eq('Event A created successfully')
      end
    end

    context "when creating event type B" do
      before do
        @user = User.create(email: "test@example.com", password: "password")
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(@user)
      end

      it "creates Event B and sends email notification successfully" do
        post :create, params: { event: { event_name: "Event B", event_type: "B" } }
        expect(response).to redirect_to(event_path(Event.last))
        expect(flash[:notice]).to eq('Event B created and email notification sent successfully')
      end

      it "creates Event B and sends email notification successfully" do
        allow_any_instance_of(SendEmailNotificationService).to receive(:notification_email).and_return(true)
        post :create, params: { event: { event_name: "Event B", event_type: "B" } }
        expect(response).to redirect_to(event_path(Event.last))
        expect(flash[:notice]).to eq('Event B created and email notification sent successfully')
      end

      it "creates Event B but fails to send email notification" do
        allow_any_instance_of(SendEmailNotificationService).to receive(:notification_email).and_return(false)
        post :create, params: { event: { event_name: "Event B", event_type: "B" } }
        expect(response).to redirect_to(event_path(Event.last))
        expect(flash[:alert]).to eq('Event B created, but failed to send email notification. Please try again later.')
      end
    end
  end

  describe "PATCH #update" do
    context "when updating event with users" do
      before do
        @user = User.create(email: "test@example.com", password: "password")
        @event = Event.create(event_name: "demo event", user_id: @user.id)
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(@user)
      end

      it "updates event successfully" do
        @user1 = User.create(email: "test1@example.com", password: "password")
        @user2 = User.create(email: "test2@example.com", password: "password")
        @user3 = User.create(email: "test3@example.com", password: "password")
        patch :update, params: { id: @event.id, event: { user_ids: [@user1.id, @user2.id, @user3.id] } }
        expect(response).to redirect_to(event_path(Event.last))
        expect(flash[:notice]).to eq('added users to Event successfully')
      end
    end

    context "when event is not present" do
      before do
        allow(controller).to receive(:authenticate_user!).and_return(true)
        allow(controller).to receive(:current_user).and_return(User.new)
      end

      it "redirects to root path with alert message" do
        patch :update, params: { id: 999, event: { user_ids: ["1", "2", "3"] } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq('event not present')
      end
    end
  end
end
