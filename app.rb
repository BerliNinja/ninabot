require 'sinatra'
require 'httparty'
require 'json'

post '/gateway' do
  message = params[:text].gsub(params[:trigger_word], '').strip

  action, repo = message.split('_').map {|c| c.strip.downcase }
  repo_url = "https://api.github.com/repos/#{repo}"

  case action
    when 'issues'
      # return if params[:token] != ENV['SLACK_TOKEN']
      resp = HTTParty.get(repo_url)
      resp = JSON.parse resp.body
      respond_message "There are #{resp['open_issues_count']} open issues on #{repo}"
    when 'friends'
      respond_message "Hey my friend"
    when 'cat'
      catArray = ["http://giphy.com/gifs/cat-maru-kIkwipWRoqeUE", "http://www.netanimations.net/catside-story-2.GIF", "http://www.lolbing.com/wp-content/uploads/2012/02/70dfflip-that-cat.jpg" ]
      test = catArray.sample
      respond_message = test.to_s
  end
end

get '/' do
  "hi"
end

def respond_message message
  content_type :json
  {:text => message}.to_json
end