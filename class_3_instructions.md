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
