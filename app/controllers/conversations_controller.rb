class ConversationsController < ApplicationController
  before_action :logged_in_user
  helper_method :conversation

  def create
    recipient_emails = conversation_params(:recipients).split(/\s*,\s*/)

    if recipient_emails.empty? || conversation_params(:subject).empty? || conversation_params(:body).empty?
      flash[:danger] = 'Please fill out the form before submitting'
      redirect_to new_conversation_path
    else
      recipients = User.where(email: recipient_emails)
      conversation = current_user.send_message(recipients, *conversation_params(:body, :subject)).conversation
      redirect_to conversation_path(conversation)
    end
  end

  def index
    @conversations ||= current_user.mailbox.inbox.all
  end

  def show
    @receipts = mailbox.receipts_for(conversation).order(created_at: :asc).not_trash
    @receipts.mark_as_read
  end

  def reply
    current_user.reply_to_conversation(conversation, *message_params(:body, :subject))
    @receipt = mailbox.receipts_for(conversation).order(created_at: :asc).last
    # redirect_to conversation_path(conversation)
    respond_to do |format|
      format.js
    end
  end

  def trashbin
    @trash ||= current_user.mailbox.trash.all
  end

  def trash
    conversation.move_to_trash(current_user)
    redirect_to :conversations
  end

  def untrash
    conversation.untrash(current_user)
    redirect_to :back
  end

  def empty_trash
    current_user.mailbox.trash.each do |conversation|
      conversation.receipts_for(current_user).update_all(deleted: true)
    end
    redirect_to :conversations
  end

  private

    def conversation
      @conversation ||= mailbox.conversations.find(params[:id])
    end

    def conversation_params(*keys)
      fetch_params(:conversation, *keys)
    end

    def message_params(*keys)
      fetch_params(:message, *keys)
    end

    def fetch_params(key, *subkeys)
      params[key].instance_eval do
        case subkeys.size
          when 0 then self
          when 1 then self[subkeys.first]
          else subkeys.map{ |k| self[k] }
        end
      end
    end
end
