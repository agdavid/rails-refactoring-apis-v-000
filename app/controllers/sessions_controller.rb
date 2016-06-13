class SessionsController < ApplicationController
  skip_before_action :authenticate_user, only: :create

  def create
    #user service objects instead of including API logic in controller

    github = GithubService.new({"access_token" => session[:token]})
    session[:token] = github.authenticate!(ENV["GITHUB_CLIENT"], ENV["GITHUB_SECRET"], params[:code])

    # response = Faraday.post "https://github.com/login/oauth/access_token", {client_id: ENV["GITHUB_CLIENT"], client_secret: ENV["GITHUB_SECRET"],code: params[:code]}, {'Accept' => 'application/json'}
    # access_hash = JSON.parse(response.body)
    # session[:token] = access_hash["access_token"]

    session[:username] = github.get_username

    # user_response = Faraday.get "https://api.github.com/user", {}, {'Authorization' => "token #{session[:token]}", 'Accept' => 'application/json'}
    # user_json = JSON.parse(user_response.body)
    # session[:username] = user_json["login"]

    redirect_to '/'
  end
end