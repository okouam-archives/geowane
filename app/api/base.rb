class API::Base < Sinatra::Base

  set :sessions, false
  set :show_exceptions, false
  set :dump_errors, true
  set :raise_errors, true

  helpers do

    def request_headers
      env.inject({}){|acc, (k,v)| acc[$1.downcase] = v if k =~ /^http_(.*)/i; acc}
    end

    def ensure_authenticated
      key = request_headers["api.key"]
      #if key
      #  halt 401, "Invalid API key provided" if User.find_by_authentication_token(key).nil?
      #else
      #  halt 401, "No API key provided"
      #end
    end

  end

end