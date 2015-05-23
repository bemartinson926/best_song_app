Class 3 Instructions
==============

##### If you would like to start from where we left off after class 2 you can clone the repo into your local directory  
via ssh (preferred):
```
$ git@github.com:bemartinson926/best_song_app.git
```

via https:  
```
$ https://github.com/bemartinson926/best_song_app.git
```
___

#### Create an Artists controller with the following command:  
```
$ rails g controller Artists
```
- This will create a new file in app/controllers/artists.rb

##### In order to return something to the browser, we need to create an action (method) inside the controller. Start with the index action that by convention will display all artists in our database.  
- Modify your app/controllers/artists.rb file to look like the following:  
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
- Modify your app/controllers/artists.rb file to look like the following:  
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
- Modify your app/controllers/artists.rb file to look like the following:  
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
- Modify your app/controllers/artists.rb file to look like the following:
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
