#= require _notify

topBar=
  show: ->
    $('.topBar').css('top','0')
    $('.container').css('margin-top','50px')
  hide: ->
    $('.topBar').css('top','-50px')
    $('.container').css('margin-top','0')
window.topBar = topBar

generateNotify = (title, tag=false) ->
  options =
    icon: '/images/owl.png'
  if tag
    options.tag = tag
  return new Notify title, options

@notifier = {}
@notifier.xbox = generateNotify 'Xbox Live', 'xbox'
@notifier.psn = generateNotify 'Playstation Network', 'psn'
@notifier.facebook = generateNotify 'Facebook', 'facebook'
@notifier.steam = generateNotify 'Steam', 'steam'
@notifier.wow = generateNotify 'World of Warcraft', 'wow'

setTimeout (->
  if Notify.isSupported and Notify.needsPermission
    topBar.show()
  $('#closeNotificationRequest').click ->
    topBar.hide()
  $('#enableNotifications').click ->
    #TODO: something will go here
    Notify.requestPermission (->
      console.log 'Permission was granted.'
      notify = generateNotify('Notifications enabled!')
      notify.options.body = 'You will receive notifications when server statuses change.'
      notify.show()
      topBar.hide()
    ), ->
      console.log 'Permission was denied.'
      topBar.hide()
), 2000
