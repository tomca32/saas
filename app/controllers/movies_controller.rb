class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    debugger
    @all_ratings = Movie.ratings
    @sesija = false
    
    if params.has_key?(:sort) && params[:sort]!=""
        @sorting = params[:sort]
    elsif (session.has_key?(:sort) && session[:sort] != "" && session[:sort]!= nil)
        @sorting = session[:sort]
        @sesija = true    
    end   
    if params.has_key?(:ratings)
        @unfiltered = params[:ratings]
    elsif session.has_key?(:unfiltered_ratings)
        @unfiltered = session[:unfiltered_ratings]
        @sesija = true
    
    end
    if @sesija
        flash.keep    
        reset_session
        redirect_to movies_path(:sort => @sorting, :ratings => @unfiltered)
    end

    @filtered_ratings = @unfiltered.keys
    @filtered_ratings = @all_ratings unless @unfiltered
    if params[:filtered_ratings]
        @filtered_ratings = params[:filtered_ratings]
    end
    
    if @sorting == 'title'
        @title_highlight = 'hilite'
    end
    if @sorting == 'release_date'
        @date_highlight = 'hilite'
    end
    unless @sesija
        session[:unfiltered_ratings] = @unfiltered
        session[:sort] = @sorting
    end
    debugger
    @movies = Movie.find(:all, conditions: ["rating IN (?)", @filtered_ratings],:order => @sorting)
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
