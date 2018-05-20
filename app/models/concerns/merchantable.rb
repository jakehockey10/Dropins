module Merchantable
  extend ActiveSupport::Concern

  # get the authorization url for this user.  This url will let the user
  # register or login to WePay to approve our app.

  # returns a url
  def wepay_authorization_url(redirect_uri)
    DropinsApp::Application::WEPAY.oauth2_authorize_url(redirect_uri, email, name)
  end

  # takes a code returned by wepay oauth2 authorization and makes an api call to
  # generate oauth2 token for this user.
  def request_wepay_access_token(code, redirect_uri)
    response = WEPAY.oauth2_token(code, redirect_uri)
    if response['error']
      raise "Error - #{response['error_description']}"
    elsif !response['access_token']
      raise 'Error requesting access from WePay'
    else
      self.wepay_access_token = response['access_token']
      save

      # self.create_wepay_account
      create_wepay_account
    end
  end

  def has_wepay_access_token?
    !wepay_access_token.nil?
  end

  # makes an api call to WePay to check if current access token for user is still valid
  def has_valid_wepay_access_token?
    return false if wepay_access_token.nil?
    response = WEPAY.call('/user', wepay_access_token)
    response && response['user_id'] ? true : false
  end

  def has_wepay_account?
    wepay_account_id != 0 && !wepay_account_id.nil?
  end

  # creates a checkout object using WePay API for this user
  def create_checkout(redirect_uri, dropin_amount)
    app_fee = 0
    params  = {
      account_id:        wepay_account_id,
      short_description: 'Dropin paid for',
      type:              'event',
      currency:          'USD',
      amount:            dropin_amount,
      fee:               {
        app_fee:   app_fee,
        fee_payer: 'payee'
      },
      hosted_checkout:   {
        mode:         'iframe',
        redirect_uri: redirect_uri
      }
    }
    wepay_call('/checkout/create', params)
  end

  def make_withdrawal(redirect_uri, description = nil)
    params = {
      account_id:   wepay_account_id,
      redirect_uri: redirect_uri,
      fallback_uri: redirect_uri,
      note:         description ||= "User: #{email}",
      mode:         'iframe'
    }
    wepay_call('/withdrawal/create', params)
  end

  def withdrawal(withdrawal_id)
    params = {
      withdrawal_id: withdrawal_id
    }
    wepay_call('/withdrawal', params)
  end

  def withdrawals(state)
    params = {
      account_id: wepay_account_id,
      state:      state
    }
    wepay_call('/withdrawal/find', params)
  end

  def withdrawal_counts
    account_id = wepay_account_id
    # TODO: use wepay batch call for this
    {
      new:      wepay_call('/withdrawal/find', account_id: account_id, state: 'new').count,
      started:  wepay_call('/withdrawal/find', account_id: account_id, state: 'started').count,
      captured: wepay_call('/withdrawal/find', account_id: account_id, state: 'captured').count,
      expired:  wepay_call('/withdrawal/find', account_id: account_id, state: 'expired').count,
      failed:   wepay_call('/withdrawal/find', account_id: account_id, state: 'failed').count
    }
  end

  def wepay_account
    params = {
      account_id: wepay_account_id
    }
    wepay_call('/account', params)
  end

  private

  def wepay_call(api_call, params)
    response = WEPAY.call(api_call, wepay_access_token, params)
    unless response.is_a?(Array)
      if !response
        raise 'Error - no response from WePay'
      elsif response['error']
        respond_to_wepay_response(response)
      end
    end
    response
  end

  # creates a WePay account for this user with the user's name
  def create_wepay_account
    if has_wepay_access_token? && !has_wepay_account?
      params   = { name: name, description: 'dropin payment' }
      response = WEPAY.call('/account/create', wepay_access_token, params)

      if response['account_id']
        self.wepay_account_id = response['account_id']
        return save
      else
        raise "Error - #{response['error_description']}"
      end
    end
    raise 'Error - cannot create WePay account'
  end

  def respond_to_wepay_response(response)
    if response['error_code'] === 1006

    else
      raise "Error - #{response['error_description']}"
    end
  end

  def update_uri(redirect_uri)
    params = {
      account_id:   wepay_account_id,
      mode:         :iframe,
      redirect_uri: redirect_uri
    }
    wepay_call('/account/update_uri', params)
  end
end
