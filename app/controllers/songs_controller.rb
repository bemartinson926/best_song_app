class SongsController < ApplicationController
  def new
    @song = Song.new
    @artists = Artist.all
  end

  def show
    @song = Song.find(params[:id])
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  private
  def song_params
    params.require(:song).permit(:title, :optimal_volume, :artist_id)
  end
end
