/*
  Convenience Functions
*/

export function clone (obj: any) {
  var key, temp;
  if (obj === null || typeof obj !== "object") {
    return obj;
  }
  temp = new obj.constructor();
  for (key in obj) {
    temp[key] = clone(obj[key]);
  }
  return temp;
};

export function shuffle (array: any[]) {
  var counter, index, temp;
  counter = array.length;
  while (counter > 0) {
    index = Math.floor(Math.random() * counter);
    counter--;
    temp = array[counter];
    array[counter] = array[index];
    array[index] = temp;
  }
  return array;
};

/*
  Device setup
*/

const userAgent = navigator.userAgent;

const Device = {
  isAndroid: userAgent.toLowerCase().indexOf("android") >= 0,
  isIOS: (userAgent.match(/iPhone/i) || userAgent.match(/iPod/i) || userAgent.match(/iPad/i)) != null,
  isMobile: false
};

Device.isMobile = Device.isAndroid || Device.isIOS;