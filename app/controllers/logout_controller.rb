class LogoutController < ApplicationController
    skip_before_action :authorize_request, only: :logout
  # return auth token once user is authenticated
  def logout
    auth_token = request.headers['Authorization']
    if auth_token == nil

      auth_token = params["Authorization"]
      #p auth_token
    end
    if auth_token == nil
      return json_response({message: "Invalid token", status_code: '422'})
    end
    #@current_user = (AuthorizeApiRequest.new(request.headers).call)[:user]
    #p @current_user
    is_token_valid = JsonWebToken.decode(auth_token)

    result =  JsonWebToken.invalidate(auth_token)

    if result != nil
      #json_response(message: "/Invalid credentials/")
      respose =  json_response({message: "You have succesfully logged out...", status_code: result})
    else
      response =  json_response({message: "Something went wrong...", status_code: '422'})
    end

    return response
    #p 
    # puts "finished"
    # p @current_user
    #u#ser  = LogoutUser.new(auth_params[:token])
    # p auth_params[:email]
    # p request.headers
      # dec_token = JsonWebToken.decode(:token)
      # p dec_token
      # json_response(message: "/Succesful Logout/")
    # else
    # json_response(message: "/Invalid credentials/")
    # end
  end


  private

  def auth_params
    params.permit(:Authorization)
  end
end