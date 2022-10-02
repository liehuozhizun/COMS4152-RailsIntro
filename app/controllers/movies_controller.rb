class MoviesController < ApplicationController
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index_display_as_normal(ratings, sort_select)
    @ratings_to_show = ratings.keys
    @sort_selector = sort_select
    
    session[:ratings] = ratings
    session[:sort_select] = sort_select
    if sort_select == nil
      @movies = Movie.with_ratings(@ratings_to_show)
    else
      @movies = Movie.with_ratings_and_sort_by(@ratings_to_show, sort_select)
    end

    if params[:flag] == nil
      redirect_to movies_path(:utf8 => '✓', :ratings => ratings, :sort_select => sort_select, :flag => :true) and return
    end
  end

  def index
    @all_ratings = Movie.ALL_RATINGS
    if params[:ratings] == nil
      if session[:ratings] == nil
        params[:ratings] = Movie.ALL_RATINGS_MAP
        redirect_to movies_path(:utf8 => '✓', :ratings => Movie.ALL_RATINGS_MAP, :sort_select => nil) and return
      else
        index_display_as_normal(session[:ratings], session[:sort_select])
        return
      end
    end

    if params[:commit] == "Refresh"
      index_display_as_normal(params[:ratings], nil)
    else
      index_display_as_normal(params[:ratings], params[:sort_select])
    end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
