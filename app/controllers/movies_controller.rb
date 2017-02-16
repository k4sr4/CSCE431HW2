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
    @all_ratings = Movie.ratings
    @first_time = true
    
    if(params[:sort] == "title")
      session[:sort] = "title"
    elsif(params[:sort] == "date")
      session[:sort] = "date"
    end
    
    if (!session[:ratings])
      session[:ratings] = Hash[@all_ratings.map {|x| [x, 1]}]
    end
    if (params[:ratings])
      session[:ratings] = params[:ratings]
    end
    
    if(session[:ratings] && @first_time)
      @first_time = false
      @checkboxes = session[:ratings].keys
      condition = ""
      i = 0
      
      for key in @checkboxes do
        if (i != @checkboxes.size - 1)
          condition += "rating = '" + key + "' OR "
        else
          condition += "rating = '" + key + "'"
        end
        i += 1
      end
      
      @movies = Movie.where(condition)
      
      if(session[:sort] == "title")
        @movies = @movies.order(:title)
      elsif(session[:sort] == "date")
        @movies = @movies.order(:release_date)
      else
        @movies = @movies.all
    end
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

end
