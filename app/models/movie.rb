# create_table "movies", force: :cascade do |t|
#   t.string   "title"
#   t.string   "rating"
#   t.text     "description"
#   t.datetime "release_date"
#   t.datetime "created_at"
#   t.datetime "updated_at"

class Movie < ActiveRecord::Base
  # class method to get all ratings ['G','PG','PG-13','R']
  def self.ALL_RATINGS
    ['G','PG','PG-13','R']
  end

  # @list rating_list ['G','PG','PG-13','R']
  #                   nil for all movies
  def self.with_ratings(ratings_list)
    if ratings_list.length == 0
      Movie.all
    else
      Movie.where("rating IN (?)", ratings_list)
    end
  end
end
