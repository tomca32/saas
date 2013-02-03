class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.ratings
    @sorting = params[:sort]
    if params[:ratings]
        @unfiltered = params[:ratings]
        @filtered_ratings = @unfiltered.keys
    end
    if params[:filtered_ratings]
                @filtered_ratings = params[:filtered_ratings]
    end
    if @sorting == 'title'
        @title_highlight = 'hilite'
    end
    if @sorting == 'release_date'
        @date_highlight = 'hilite'
    end
    @filtered_ratings = @all_ratings unless @unfiltered
    @movies = Movie.find(:all, conditions: ["rating IN (?)", @filtered_ratings],:order => (params[:sort]))
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
