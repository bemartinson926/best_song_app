Class 3 Instructions
==============

##### Below are the instructions for what we covered during Class 3 as well as what we didn't finish to be prepared for Class 4.

- Clone the repo into your local directory:

via ssh:
```
$ git@github.com:bemartinson926/best_song_app.git
```

via https:  
```
$ https://github.com/bemartinson926/best_song_app.git
```

- cd into the repo `$ cd best_song_app`

- Ensure that you have all of the branches by running `$ git fetch`

- Start from where Class 2 finished by running `$ git checkout class_2`. This will checkout the class_2 branch.

- Create a new branch (my_class_3) off of the class_2 branch to complete the Class 3 instructions below `$ git checkout -b my_class_3`

- Follow the instructions below.
___

#### Create an Artists controller with the following command:  
```
$ rails g controller Artists
```
- This will create a new file in app/controllers/artists_controller.rb

##### In order to return something to the browser, we need to create an action (method) inside the controller. Start with the index action that by convention will display all artists in our database.  
- Modify your app/controllers/artists_controller.rb file to look like the following:  
```ruby
class ArtistsController < ApplicationController
  def index
    @artists = Artist.All
  end
end

```
____

#### Create a route for the new index action
- Modify config/routes.rb to look like the following:
```ruby
Rails.application.routes.draw do
  get 'artists', to: 'artists#index'
end

```
____

#### Create a view file to display our artists
- Create a new file app/views/artists/index.html.erb
- Add the following code to the file:
```ruby
<h2>Current Artists:</h2>
<ul>
  <% @artists.each do |artist| %>
    <li>
      <%= artist.full_name %>
      <%= artist.home_town %>
      <%= artist.current_hairstyle %>
    </li>
  <% end %>
<ul>
```
###### Note:
- The file name of our view file (index.html.erb) matches the name of the action (index) that we defined in the ArtistsController
- The `@artists` instance variable that we defined in the index action of the ArtistsController is available in the view file (app/views/artists/index.html.erb)

You should now be able to go to `http://localhost:3000/artists` to see a list of artists in your database.
____
#### Let's set a defualt route so that if someone that uses our app and doesn't know the structure they will get the best user experience we can provide at this point and they won't experience errors.

- First, visit `http:localhost:3000`. You should see the default Rails view.
- For now, let's defualt to the artists#index action (this is called our root route).
- Modify config/routes.rb to look like the following:
```ruby
Rails.application.routes.draw do
  root 'artists#index'
  get 'artists', to: 'artists#index'
end

```
- Now if you visit `http:localhost:3000`. You should see the same thing you see when you visit `http://localhost:3000/artists`
___
#### Currently, we can only add artists to our application via Rails console `$ rails console` or `$ rails c`. Let's add functionality to add artists in the browser.
- First we will create an action in the ArtistsController called new. We will use this to create a new artist instance and render a form.
- Modify your app/controllers/artists_controller.rb file to look like the following:  
```ruby
class ArtistsController < ApplicationController
  def index
    @artists = Artist.All
  end
  
  def new
    @artist = Artist.new
  end
end

```
- Create a new file app/views/artists/new.html.erb and add the following code:
```ruby
<h2>Add a new artist</h2>
<%= form_for(@artist) do |f| %>
  <%= f.label :full_name %>
  <%= f.text_field :full_name %><br>

  <%= f.label :home_town %>
  <%= f.text_field :home_town %><br>

  <%= f.label :current_hairstyle %>
  <%= f.text_field :current_hairstyle %><br>

  <%= f.submit %>
<% end %>
```
- Modify config/routes.rb to look like the following:
```ruby
Rails.application.routes.draw do
  root 'artists#index'
  get 'artists', to: 'artists#index'
  get 'artists/new', to: 'artists#new'
end

```
Now we can visits `http://localhost:3000/artists/new` and you should see a form to create a new artist. However, it is not very useful if we don't have a way to save that information to our database.
- Fill out the form for a new artists and click "Create Artist" to see for yourself.
- Rails is pretty awesome and tells us what we need to do next. It says we don't have a route that matches Post "/artists". So let's create one.
- Modify config/routes.rb to look like the following:
```ruby
Rails.application.routes.draw do
  root 'artists#index'
  get 'artists', to: 'artists#index'
  get 'artists/new', to: 'artists#new'
  post 'artists', to: 'artists#create'
end

```
- Notice that I mapped it to an action called create (although it doesn't exist yet). Try filling out the form again and see what Rails tells us. It says we need that action called create so let's CREATE it!
- Modify your app/controllers/artists_controller.rb file to look like the following:  
```ruby
class ArtistsController < ApplicationController
  def index
    @artists = Artist.all
  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(artist_params)
    @artist.save

    redirect_to artists_path
  end

  private
  def artist_params
    params.require(:artist).permit(:full_name, :home_town, :current_hairstyle)
  end
end

```
- I added a private method called artist_params and I'm passing the return of the method as the attributes for our new Artist object in the create action. The artist_params method is a way to limit what parameters can be passed and prevent malicious attacks. Learn more about [strong parameters](http://edgeguides.rubyonrails.org/action_controller_overview.html#strong-parameters).

We now have the ability to create a new artist and save it to our database, but we need one more thing to make it more user friendly. Lets add a link to our new form from the artists index page of our app.
- Modify the file app/view/artists/index.html.erb to add the link:
```ruby
<%= link_to 'Add a new artist', artists_new_path %>
<h2>Current Artists:</h2>
<ul>
  <% @artists.each do |artist| %>
    <li>
      <%= artist.full_name %>
      <%= artist.home_town %>
      <%= artist.current_hairstyle %>
    </li>
  <% end %>
<ul>
```
___
#### Let's refactor our create action a little bit.
We have basic functionality to create an artist and redirect the user back to the index page, but what if the user tries to create and invalid artist?
- Modify your app/controllers/artists_controller.rb file to look like the following:
```ruby
class ArtistsController < ApplicationController
  def index
    @artists = Artist.all
  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      redirect_to artists_path
    else
      render :new
    end
  end

  private
  def artist_params
    params.require(:artist).permit(:full_name, :home_town, :current_hairstyle)
  end
end

```
Now if a tries to create an invalid artist, the form will be rendered again.

- We can test this by adding an Active Record Validation to our Artist model. We want our artists to have a name at the very least.
- Modify the file app/models/artist.rb to look like the following:
```ruby
class Artist < ActiveRecord::Base
  has_many :songs

  validates :full_name, presence: true
end

```
- This will return an error if a full_name is not entered. We can display this error to the user by adding them to the view file. More Active Record Validations can be found [here](http://guides.rubyonrails.org/active_record_validations.html).
- Modify your app/views/artists/new.html.erb file:
```ruby
<h2>Add a new artist</h2>
<%= form_for(@artist) do |f| %>
  <div>
    <% @artist.errors.full_messages.each do |message| %>
      <li style="color: Red"><%= message %></li>
    <% end %>
  </div><br >

  <%= f.label :full_name %>
  <%= f.text_field :full_name %><br>

  <%= f.label :home_town %>
  <%= f.text_field :home_town %><br>

  <%= f.label :current_hairstyle %>
  <%= f.text_field :current_hairstyle %><br>

  <%= f.submit %>
<% end %>
```
___
#### Let's add functionality to create new songs.
- First create a SongsController with the following command: `$ rails g controller Songs`
- Add a new, create, and show action to the SongsController (app/controllers/songs_controller.rb):
```ruby
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

```
- The show action is used to present a single song. In our create action inside our if statement, where we have `redirect_to @song` it will redirect to the show action and display the song that was just created.
- We need to add routes for our new actions in the SongsController, but this time we will create a resource route that will provide routes for index, create, new, edit, show, update, and destroy (config/routes.rb):
```ruby
Rails.application.routes.draw do
  root 'artists#index'
  get 'artists', to: 'artists#index'
  get 'artists/new', to: 'artists#new'
  post 'artists', to: 'artists#create'

  resources :songs
end

```
- You can see your routes by running `$ rake routes` or routes specific to songs with `$ rake routes | grep songs`

We need to add 2 new view files for our new and show actions.
- Create the following file (app/views/songs/new.html.erb):
```ruby
<h2>Add a new song</h2>
<%= form_for(@song) do |f| %>

  <%= f.label :title %>
  <%= f.text_field :title %><br>

  <%= f.label :optimal_volume %>
  <%= f.text_field :optimal_volume %><br>
  
  <% artists = @artists.map { |artist| [artist['full_name'], artist['id']] } %>
  <%= f.label :artist %>
  <%= f.select(:artist_id, options_for_select(artists)) %><br >

  <%= f.submit %>
<% end %>
```
- Create the following file (app/views/songs/show.html.erb):
```ruby
<p>
  <strong>Title:</strong>
  <%= @song.title %>
</p>

<p>
  <strong>Optimal Volume:</strong>
  <%= @song.optimal_volume %>
</p>

<p>
  <strong>Song's Artist:</strong>
  <%= @song.artist.full_name %>
</p>
```
___
#### We have basic functionality, but we need to tie it together a bit.

Let's create a show action for artists (app/controllers/artists_controller.rb):
```ruby
class ArtistsController < ApplicationController
  def index
    @artists = Artist.all
  end

  def show
    @artist = Artist.find(params[:id])
  end

  def new
    @artist = Artist.new
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      redirect_to artists_path
    else

      render :new
    end
  end

  private
  def artist_params
    params.require(:artist).permit(:full_name, :home_town, :current_hairstyle)
  end
end

```
- Modify the routes for artists to be a resource (config/routes.rb):
```ruby
Rails.application.routes.draw do
  root 'artists#index'

  resources :artists
  resources :songs
end

```
- Create a show view for artists (app/views/artists/show.html.erb):
```ruby
<p>
  <strong>Name:</strong>
  <%= @artist.full_name %>
</p>

<p>
  <strong>Hometown:</strong>
  <%= @artist.home_town %>
</p>

<p>
  <strong>Current Hairstyle:</strong>
  <%= @artist.current_hairstyle %>
</p>

<p>
  <strong>Songs:</strong>
  <ul>
    <% @artist.songs.each do |song| %>
      <li><%= link_to song.title, song_path(song) %></li>
    <% end %>
  </ul>
</p>

<%= link_to 'Back', artists_path %>
```
- Add a link to each artist on the artists index page (app/views/artists/index.html.erb):
```ruby
<%= link_to 'Add a new artist', new_artist_path %>
<h2>Current Artists:</h2>
<ul>
  <% @artists.each do |artist| %>
    <li>
      <%= link_to artist.full_name, artist_path(artist) %>
      <%= artist.home_town %>
      <%= artist.current_hairstyle %>
    </li>
  <% end %>
<ul>
```
___
#### A few more connections.
- Add a link from artist show page to create new song (app/views/artists/show.html.erb):
```ruby
<p>
  <strong>Name:</strong>
  <%= @artist.full_name %>
</p>

<p>
  <strong>Hometown:</strong>
  <%= @artist.home_town %>
</p>

<p>
  <strong>Current Hairstyle:</strong>
  <%= @artist.current_hairstyle %>
</p>

<p>
  <strong>Songs:</strong>
  <ul>
    <% @artist.songs.each do |song| %>
      <li><%= link_to song.title, song_path(song) %></li>
    <% end %>
  </ul>
</p>

<%= link_to 'Add new song', new_song_path %><br >
<%= link_to 'Back', artists_path %>
```
- Add links from song show page to navigate back to song's artist page or artists index page (app/views/songs/show.html.erb):
```ruby
<p>
  <strong>Title:</strong>
  <%= @song.title %>
</p>

<p>
  <strong>Optimal Volume:</strong>
  <%= @song.optimal_volume %>
</p>

<p>
  <strong>Song's Artist:</strong>
  <%= @song.artist.full_name %>
</p>

<%= link_to 'Artist', artist_path(@song.artist) %><br >
<%= link_to 'All Artists', artists_path %>
```
