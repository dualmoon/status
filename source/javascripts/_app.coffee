status = angular.module 'status', ['ui.bootstrap']

checkPSNStatus = ($scope, $http, $timeout) ->
  $scope.isCheckingPSN = true
  $scope.psnStatus = 'checking...'
  $scope.psnUpdated = ''
  $http.get('/psn')
    .success (data, status, header, config) ->
      result = angular.element('<div></div>').html(data)
      status = $('[id^=rn_PSNStatusTicker] span',result)[0].childNodes[1].textContent.trim()
      $scope.psnUpdated = $('.rn_AnswerDetailInfo_updated',result).text().split(' ')[1]
      $scope.psnUpdatedI = 'clock-o'
      if status.toLowerCase() is 'offline'
        $scope.psnStatus = 'offline'
      else if status.toLowerCase() is 'online'
        $scope.psnStatus = 'online'
      else if status.toLowerCase() is 'intermittent connectivity'
        $scope.psnStatus = 'intermittent'
      else if status.toLowerCase() is 'heavy network traffic'
        $scope.psnStatus = 'heavy network traffic'
      else
        $scope.psnStatus = 'Unknown'
    .error (data, status, header, config) ->
      $scope.psnStatus = 'unknown'
      $scope.psnUpdatedI = 'question'
      console.log "Error loading PSN status page."
    .then ->
      $scope.psnLastUpdated = "#{new Date().toDateString()} at #{new Date().toLocaleTimeString()}"
      $scope.isCheckingPSN = false
checkWowStatus = ($scope, $http) ->
  $scope.isCheckingWow = true
  $scope.wowStatus = 'checking...'
  $http.get('/wow')
    .success (data, status, header, config) ->
      realmStatus = []
      for realm in data.realms
        realmStatus.push
          realm: realm.name
          status: realm.status
      numTot = realmStatus.length
      numOff = _.where(realmStatus, {'status':false}).length
      if numOff is numTot
        $scope.wowStatus = 'offline'
      else if numOff is 0
        $scope.wowStatus = 'online'
        $scope.wowClear = true
      else if numOff > 0
        offPct = (numOff/numTot)*100
        if offPct > 70
          $scope.wowStatus = 'largely offline'
        else if offPct > 10
          $scope.wowStatus = 'partly offline'
      else
        $scope.wowStatus = 'unknown'
    .error (data, status, header, config) ->
      $scope.wowStatus = 'unknown'
    .then ->
      $scope.isCheckingWow = false
      $scope.wowLastUpdated = "#{new Date().toDateString()} at #{new Date().toLocaleTimeString()}"
checkFacebookStatus = ($scope, $http, $timeout) ->
  $scope.isCheckingFacebook = true
  $scope.facebookStatus = 'checking...'
  $http.get('/fb')
    .success (facebook, s, h, c) ->
      if facebook.current.health is 1
        $scope.facebookStatus = 'online'
      else
        $scope.facebookStatus = 'offline'
    .error (d,s,h,c) ->
      $scope.facebookStatus = 'unknown'
    .then ->
      $scope.isCheckingFacebook = false
      $scope.facebookLastUpdated = "#{new Date().toDateString()} at #{new Date().toLocaleTimeString()}"
checkSteamStatus = ($scope, $http, $timeout) ->
  $scope.isCheckingSteam = true
  $scope.steamStatus = 'checking...'
  $http.get('/steam')
    .success (data, status, header, config) ->
      window.steam = steam = data
      $scope.steamServersTotal = steam.services['cm-US'].title.split(' ')[2]
      $scope.steamServersOn = steam.services['cm-US'].title.split(' ')[0]
      serversOffPct = Math.floor ($scope.steamServersOn/$scope.steamServersTotal)*100
      if serversOffPct > 80
        $scope.steamStatus = 'online'
      else if serversOffPct <= 80
        $scope.steamStatus = 'iffy'
      else if serversOffPct <= 20
        $scope.steamStatus = 'offline'
      else
        $scope.steamStatus = 'unknown'
    .error (data, status, header, config) ->
      $scope.steamStatus = 'unknown'
      $scope.steamServersTotal = '??'
      $scope.steamServersOn = '??'
    .then ->
      $scope.isCheckingSteam = false
      $scope.steamLastUpdated = "#{new Date().toDateString()} at #{new Date().toLocaleTimeString()}"
checkXboxStatus = ($scope, $http, $timeout) ->
  $scope.isCheckingXbox = true
  $scope.xboxStatus = 'checking...'
  $scope.xboxCore = $scope.xboxSG = $scope.xboxPC = $scope.xboxMM = 'circle-o-notch'
  $http.get('/xbox')
    .success (data, status, header, config) ->
      result = angular.element('<div></div>').html(data)
      status = 0
      whatStatus = (tag, stat) ->
        status = $(tag, result).attr('class').split(' ')[1]
        if status is 'unavailable'
          return ['close',++stat]
        else if status is 'active'
          return ['check',stat]
        else return ['question',++stat]
      [$scope.xboxCore, status] = whatStatus('#XboxLiveCoreServices',status)
      [$scope.xboxSG, status] = whatStatus('#SocialandGaming',status)
      [$scope.xboxPC, status] = whatStatus('#PurchaseandContentUsage',status)
      [$scope.xboxMM, status] = whatStatus('#TVMusicandVideo',status)
      window.wowStatus = status
      if status is 4
        $scope.xboxStatus = 'offline'
      else if status > 0
        $scope.xboxStatus = 'iffy'
      else if status is 0
        $scope.xboxStatus = 'online'
      else
        $scope.xboxStatus = 'unknown'
    .error (data, status, header, config) ->
      console.log "Error loading Xbox status page."
      $scope.xboxStatus = 'unknown'
      $scope.xboxCore = $scope.xboxSG = $scope.xboxPC = $scope.xboxMM = 'question'
    .then ->
      $scope.xboxLastUpdated = "#{new Date().toDateString()} at #{new Date().toLocaleTimeString()}"
      $scope.isCheckingXbox = false

status.controller 'StatusCtrl', ($scope, $http, $timeout) ->
  $scope.psnLastUpdated = $scope.xboxLastUpdated = $scope.wowLastUpdated = "never."
  checkPSNStatus($scope, $http, $timeout)
  checkXboxStatus($scope, $http, $timeout)
  checkWowStatus($scope, $http, $timeout)
  checkSteamStatus($scope, $http, $timeout)
  checkFacebookStatus($scope, $http, $timeout)
  $scope.isCheckingXbox = $scope.isCheckingPSN = $scope.isCheckingWow = $scope.isCheckingSteam = $scope.isCheckingFacebook = true
  $scope.checkXboxStatus = ->
    if not $scope.isCheckingXbox
      checkXboxStatus($scope, $http, $timeout)
  $scope.checkPSNStatus = ->
    if not $scope.isCheckingPSN
      checkPSNStatus($scope, $http, $timeout)
  $scope.checkWowStatus = ->
    if not $scope.isCheckingWow
      checkWowStatus($scope, $http, $timeout)
  $scope.checkSteamStatus = ->
    if not $scope.isCheckingSteam
      checkSteamStatus($scope, $http, $timeout)
  $scope.checkFacebookStatus = ->
    if not $scope.isCheckingFacebook
      checkFacebookStatus($scope, $http, $timeout)
