seconds = (seconds) ->
  1000*seconds
minutes = (minutes) ->
  seconds(60)*minutes

status = angular.module 'status', ['ui.bootstrap']
  .controller 'StatusCtrl', ['$scope', '$http', '$interval', ($scope, $http, $interval) ->
    $scope.psnLastUpdated = $scope.xboxLastUpdated = $scope.wowLastUpdated = "never."
    checkStatus={}
    lastStatus={}

    $scope[obj] = {} for obj in ['intervals', 'checkStatus', 'isChecking', 'lastUpdated', 'status']

    checkStatus.facebook = ->
      httpGet '/fb', 'facebook', (facebook) ->
        if facebook.current.health is 1
          $scope.status.facebook = 'online'
        else
          $scope.status.facebook = 'offline'
    checkStatus.wow = ->
      httpGet '/wow', 'wow', (wow) ->
        realmStatus = []
        for realm in wow.realms
          realmStatus.push
            realm: realm.name
            status: realm.status
        numTot = realmStatus.length
        numOff = _.where(realmStatus, {'status':false}).length
        if numOff is numTot
          $scope.status.wow = 'offline'
        else if numOff is 0
          $scope.status.wow = 'online'
          $scope.wowClear = true
        else if numOff > 0
          offPct = (numOff/numTot)*100
          if offPct > 70
            $scope.status.wow = 'largely offline'
          else if offPct > 10
            $scope.status.wow = 'partly offline'
        else
          $scope.status.wow = 'unknown'
    checkStatus.xbox = ->
      $scope.xboxCore = $scope.xboxSG = $scope.xboxPC = $scope.xboxMM = 'circle-o-notch'
      httpGet '/xbox', 'xbox', (xbox) ->
        result = angular.element('<div></div>').html(xbox)
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
        if status is 4
          $scope.status.xbox = 'offline'
        else if status > 0
          $scope.status.xbox = 'iffy'
        else if status is 0
          $scope.status.xbox = 'online'
        else
          $scope.status.xbox = 'unknown'
    checkStatus.psn = ->
      httpGet '/psn', 'psn', (psn) ->
        result = angular.element('<div></div>').html(psn)
        status = $('[id^=rn_PSNStatusTicker] span',result)[0].childNodes[1].textContent.trim()
        $scope.psnUpdated = $('.rn_AnswerDetailInfo_updated',result).text().split(' ')[1]
        $scope.psnUpdatedI = 'clock-o'
        if status.toLowerCase() is 'offline'
          $scope.status.psn = 'offline'
        else if status.toLowerCase() is 'online'
          $scope.status.psn = 'online'
        else if status.toLowerCase() is 'intermittent connectivity'
          $scope.status.psn = 'intermittent'
        else if status.toLowerCase() is 'heavy network traffic'
          $scope.status.psn = 'heavy network traffic'
        else
          $scope.status.psn = 'Unknown'
    checkStatus.steam = ->
      httpGet '/steam', 'steam', (steam) ->
        $scope.steamServersTotal = steam.services['cm-US'].title.split(' ')[2]
        $scope.steamServersOn = steam.services['cm-US'].title.split(' ')[0]
        serversOffPct = Math.floor ($scope.steamServersOn/$scope.steamServersTotal)*100
        if serversOffPct > 80
          $scope.status.steam = 'online'
        else if serversOffPct <= 80
          $scope.status.steam = 'iffy'
        else if serversOffPct <= 20
          $scope.status.steam = 'offline'
        else
          $scope.steamStatus = 'unknown'
    httpGet = (endPoint, service, successFn) ->
      $scope.isChecking[service] = true
      $scope.status[service] = 'checking...'
      $http.get(endPoint)
        .success (data) ->
          successFn data
        .error ->
          $scope.status[service] = 'unknown'
          console.log "Failed to get status information for service `#{service}`"
        .then ->
          if Notify.permissionLevel is 'granted' and lastStatus[service] isnt null
            if $scope.status[service] isnt lastStatus[service]
              notifier[service].options.body = "Service status changed.\nfrom: #{lastStatus[service]}\nto: #{$scope.status[service]}"
              notifier[service].show()
          lastStatus[service] = $scope.status[service]
          $scope.isChecking[service] = false
          $scope.lastUpdated[service] = "#{new Date().toDateString()} at #{new Date().toLocaleTimeString()}"
    check = (service, time) ->
      if not $scope.isChecking[service]
        $interval.cancel $scope.intervals[service]
        checkStatus[service] $scope, $http
        $scope.intervals[service] = $interval (->
          checkStatus[service] $scope, $http
        ), time
    
    (lastStatus[svc] = null
    $scope.checkStatus[svc] = ->
      check svc, minutes(15)
    $scope.checkStatus[svc]()) for svc in ['xbox', 'wow', 'psn', 'steam', 'facebook']
  ]
