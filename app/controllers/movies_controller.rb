class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    #debugger
    @all_ratings = Movie.ratings

    if !session[:ratings].present? #first time page case
      session[:ratings] = Hash[@all_ratings.map {|rating| ["#{rating}", 1]}]
      redirect = true
    end

    session[:ratings] = params[:ratings] unless (params[:ratings] == nil)
    session[:order] = params[:order] unless (params[:order] == nil)

    #@choosen_ratings = (params[:ratings].present? ? params[:ratings] : session[:ratings]) #if else
     #@order = (params[:order].present? ? params[:order] : session[:order]) #if else
    @choosen_ratings = params.fetch(:ratings, session[:ratings])
    @order = params.fetch(:order, session[:order])
    redirect = true if (session[:order] != params[:order])
    redirect = true if (session[:ratings] != params[:ratings])
    #debugger
    @movies = Movie.find(:all, :conditions => {:rating => @choosen_ratings.keys}, :order => @order)# if params[:ratings].present?

    if redirect then
      redirect_to movies_path(:order => @order, :ratings => @choosen_ratings)
    end
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
