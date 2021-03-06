class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
      @all_ratings = Movie.all_ratings
     if params[:sort]
         sort_by = params[:sort]
         session[:sort] = sort_by
         if sort_by == 'title'
             @title = 'hilite'
         end
         if sort_by == 'release_date'
             @release_date = 'hilite'
         end
     elsif session[:sort]
         sort_by = session[:sort]
     end
      @selected_ratings = params[:ratings] || session[:ratings] || {'G':1, 'PG':1, 'PG-13':1, 'R':1}
      
      session[:ratings] = @selected_ratings
      
      if params[:sort] != sort_by or params[:ratings] != @selected_ratings
          redirect_to sort: sort_by, ratings: @selected_ratings and return
      end
      
      @movies = Movie.where(rating: @selected_ratings.keys).order(sort_by)
  end

  def new
      session.clear
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
end
