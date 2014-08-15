class ImportedContactsController < ApplicationController
  require 'net/http'
  require 'net/https'
  require 'uri'

  #THIS METHOD TO SEND USER TO THE GOOGLE AUTHENTICATION PAGE.
  def authenticate
    # Put the code from point 1 in the Atlantic Domain Solutions article here.

    # Note:
    # Set the next_param to the follow on controller action.  For example,
    # next_param = url_for(:action => 'authorise')

    # initiate authentication w/ gmail
    # create url with url-encoded params to initiate connection with contact
    # next - the URL of the page that Google should redirect the user to after authentication.
    # scope - Indicates that the application is requesting a token to access contacts feeds.
    # secure - Indicates whether the client is requesting a secure token.
    # session - Indicates whether the token returned can be exchanged for a multi-use (session) token.

  end

  def authorise
    # Put the code from point 2 in the article here.

    # Note:
    # I changed some of the code as shown below...
    # if resp.code == "200"
    #   token = ''
    #   data.split.each do |str|
    #     if not (str =~ /Token=/).nil?
    #       token = str.gsub(/Token=/, '')
    #     end
    #   end
    #   redirect_to(:action => 'import', :token => token)
    # else
    #   redirect_to('/')
    # end
  end

  def import
    # Put the code point 3 from the article here.

    # Some notes:
    # Put the line 'authsub_token = params[:token]' at around line 4 of this method
    # (just after the two requires).  It was accidentally omitted in the original article.
    # I also changed the local variable 'contacts' to '@contacts' so that it is available to views
  end
end
