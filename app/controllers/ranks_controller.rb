class RanksController < ApplicationController
  def index
    query = "SELECT * FROM ( SELECT row_number() over ( partition by user_id ORDER BY `games`.`score` DESC, `games`.`out` ASC) as rownum, `games`.* FROM games ) with_rownum WHERE rownum = 1 ORDER BY `with_rownum`.`score` DESC, `with_rownum`.`out` ASC;"
    @ranks = Game.find_by_sql(query)
    @ranking = 1
  end
end
