class Game < ApplicationRecord
  belongs_to :user

  def self.make_ranking
    sql = <<-EOS
      SELECT rank() over (ORDER BY `with_rownum`.`score` DESC, `with_rownum`.`out` ASC) as ranking, `ranking_table`.* FROM (SELECT * FROM (SELECT row_number() over (partition by user_id ORDER BY `games`.`score` DESC, `games`.`out` ASC) as rownum, `games`.* FROM games ) with_rownum WHERE rownum = 1 ) ranking_table;
    EOS
    return Game.find_by_sql(sql)
  end

end
