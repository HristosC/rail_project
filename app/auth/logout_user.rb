class LogoutUser
    def initialize(token)
        @token = token
    end

    def call()
        if @token != nil
        JsonWebToken.invalidate(token: @token)
        return {message: "You have succesfully logged out...", status_code: '200'}.to_json
        else
            return {message: "Error occured", status_code: '422'}.to_json
        end

    end


end