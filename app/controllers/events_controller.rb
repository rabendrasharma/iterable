#frozen_string_literal: true

class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :get_event, only: [:show, :edit, :update]
  def index
    @events = EventsRetrievalService.new.get_events
  end

  def new
    @event = Event.new
    @event_type = params[:event_type]
  end

  def create
    event_name = params["event"]["event_name"]
    event_type = params["event"]["event_type"]

    if event_name.blank?
      flash[:alert] = 'Event name cannot be blank'
      render :new
      return
    end

    case event_type
    when "A"
      @event = CreateEventService.new.call(current_user, event_name)
      if @event.present?
        flash[:notice] = 'Event A created successfully'
        redirect_to event_path(@event)
      else
        flash[:alert] = 'Failed to create Event A. Please try again later.'
        render :new
      end
    when "B"
      @event = CreateEventService.new.call(current_user, event_name)
      if @event.present?
        if SendEmailNotificationService.new.notification_email(current_user, event_name)
          flash[:notice] = 'Event B created and email notification sent successfully'
          redirect_to event_path(@event)
        else
          flash[:alert] = 'Event B created, but failed to send email notification. Please try again later.'
          redirect_to event_path(@event)
        end
      else
        flash[:alert] = 'Failed to create Event B. Please try again later.'
        render :new
      end
    end
  end
  
  def show
    @users = @event.users
  end
  
  def edit
  end

  def update
    users = params[:event][:user_ids].reject(&:blank?).map(&:to_i)
    if @event.present?
      if UpdateEventService.new.call(users, @event.id, @event.event_name)
        flash[:notice] = 'added users to Event successfully'
        redirect_to event_path(@event)
      else
        flash[:alert] = 'cannot able to add users to event'
        redirect_to event_path(@event)
      end
    else
      flash[:alert] = 'event not present'
      redirect_to root_path
    end
  end

  private

  def get_event
    @event = Event.find_by(id: params[:id])
  end
end

