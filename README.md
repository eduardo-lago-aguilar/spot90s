# spot90s

Use the Spotify API url to search for artists.

https://api.spotify.com/v1/search?type=artist&limit=50&q={query}

You should assume that your solution is meant for production use by real users and will be maintained by your colleagues.

## Business Requirements
* Return the artists and re-format the results, provide a default artist value for the root url.
* Fetch an artist and save as a favourite

## Technical Requirements
* Create a Rails 5 project, store code on Github or BitBucket. The application needs to be deployed on Heroku.
* Format the result set with just the spotify id, external_urls, genres, href and name.
* Create an action to a mark an artist as a favourite, store the formatted result set.
* API only, no views. Responses should return JSON.

## Usage

### Searching for artists

`curl http://spot90s.herokuapp.com/artists/search/sting`

### Lookup specific artist by id

`curl http://spot90s.herokuapp.com/artists/0Ty63ceoRnnJKVEYP0VQpk`

### Get a default artist

`curl http://spot90s.herokuapp.com/`

### Marking an artist as favorite

`curl -X PUT http://spot90s.herokuapp.com/artists/0Ty63ceoRnnJKVEYP0VQpk`
