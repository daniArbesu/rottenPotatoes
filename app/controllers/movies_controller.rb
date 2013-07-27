class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    debugger
    @all_ratings = Movie.ratings

    if !session[:ratings].present?
      @temp = Hash.new
      @all_ratings.each {|rating| @temp["#{rating}"] = 1}
      params[:ratings] = @temp
    end

    session[:ratings] = params[:ratings] if params[:ratings].present? 
    @choosen_ratings = (params[:ratings].present? ? params[:ratings] : session[:ratings]) #if else
    @order = (params[:order].present? ? params[:order] : []) #if else
    @movies = Movie.find(:all, :conditions => {:rating => @choosen_ratings.keys}, :order => @order)# if params[:ratings].present?
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
