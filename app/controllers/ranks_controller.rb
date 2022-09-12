class RanksController < ApplicationController
  def index
    @ranks = Game.make_ranking
    
    if logged_in?
      if Game.exists?(user_id: current_user.id)
        @myrank = @ranks.find{|i| i.user_id == current_user.id}
      end
    end
  end

end
