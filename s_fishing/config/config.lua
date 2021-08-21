Config = {}

Config.fishwebhook = 'WEBHOOK HERE' --Caught fishes -log
Config.sellwebhook = 'WEBHOOK HERE' --Shopselling -log
Config.licenses = true --Set to false if you do not use esx_license, this is used to add fishing licenses(permits) for players.

Config.sellitemprices = { --You can add here other stuff too if you i.e add more variety of fishes
  pike = 12,
  bream = 8,
  pike_berch = 20,
  salmon = 19,
  trout = 17,
  cod = 10,
  herring = 7,
}

Config.fishes = {
 --Here are some examples, you can add unlimited brackets
  [1] = { 
    { itemName = 'pike', howmany = 1, type = 'item'},
  },
  
  [2] = { 
    { itemName = 'bream', howmany = 1, type = 'item'},
  },

  [3] = {
    { itemName = 'pike_berch', howmany = 1, type = 'item'},
  },

  [4] = {
    { itemName = 'salmon', howmany = 1, type = 'item'},
  },

  [5] = {
    { itemName = 'trout', howmany = 1, type = 'item'},
  },

  [6] = {
    { itemName = 'cod', howmany = 1, type = 'item'},
  },

  [7] = {
    { itemName = 'herring', howmany = 1, type = 'item'},
  },

  [8] = {
    { itemName = 'tuna', howmany = 1, type = 'item'},
  },
}