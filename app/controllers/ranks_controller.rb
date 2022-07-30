class RanksController < ApplicationController
  def index
    ranks_query = "SELECT rank() over (ORDER BY `with_rownum`.`score` DESC, `with_rownum`.`out` ASC) as ranking, `ranking_table`.* FROM (SELECT * FROM (SELECT row_number() over (partition by user_id ORDER BY `games`.`score` DESC, `games`.`out` ASC) as rownum, `games`.* FROM games ) with_rownum WHERE rownum = 1 ) ranking_table;"
    @ranks = Game.find_by_sql(ranks_query)
    
    if logged_in?
      if Game.exists?(user_id: current_user.id)
        @myrank = @ranks.find{|i| i.user_id == current_user.id}
      end
    end
  end

end
