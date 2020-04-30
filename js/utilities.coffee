###
  Convenience Functions
###

#Clone @ http://stackoverflow.com/questions/11060631/how-do-i-clone-copy-an-instance-of-an-object-in-coffeescript
clone = (obj) ->
  return obj  if obj is null or typeof (obj) isnt "object"
  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])
  temp

#Suffle @ http://jsfromhell.com/array/shuffle [v1.0]
shuffle = (array) ->
  counter = array.length;
  #While there are elements in the array
  while (counter > 0)
    #Pick a random index
    index = Math.floor(Math.random() * counter)
    #Decrease counter by 1i
    counter--
    #And swap the last element with it
    temp = array[counter]
    array[counter] = array[index]
    array[index] = temp
  return array;

###
  Device setup
###
user_agent = navigator.userAgent;
Device =
  isAndroid: user_agent.toLowerCase().indexOf("android") >= 0
  isIOS: (user_agent.match(/iPhone/i) || user_agent.match(/iPod/i) || user_agent.match(/iPad/i))?
Device.isMobile = Device.isAndroid or Device.isIOS
