request = require 'request'
express = require 'express'
http = require 'http'
app = express()

app.use '/', express.static("#{__dirname}/build")

app.get '/ping', (req, res) ->
  res.send 'pong'

app.get '/psn', (req, res) ->
  request('https://support.us.playstation.com/app/answers/detail/a_id/237/').pipe(res)
app.get '/xbox', (req, res) ->
  request('http://support.xbox.com/en-US/xbox-live-status').pipe(res)
app.get '/steam', (req, res) ->
  request({
    uri: 'https://steamdb.info/api/SteamRailgun/'
    json: true
    headers:
      'User-Agent': 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'
    }).pipe(res)
app.get '/wow', (req, res) ->
  request('https://us.api.battle.net/wow/realm/status?locale=en_US&apikey=ukm5wf6j68hwj35k57gr7tesgz8pe9k4').pipe(res)
app.get '/fb', (req, res) ->
  request({
    uri: 'https://www.facebook.com/feeds/api_status.php'
    json: true
    headers:
      'User-Agent': 'Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.36'
    }).pipe(res)

app.listen process.env.PORT||3000
