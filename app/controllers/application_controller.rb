class ApplicationController < ActionController::Base

  def hello
    render html: "hello, hayakuchi-champion!"
  end
end
