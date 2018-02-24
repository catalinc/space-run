local Level = {
  waves = {
    {after = 1, generate = {
      {"Ship", "Player"}, 
    }}, 
    {after = 1, generate = {
      {"Ship", "Grunt"}, 
      {"Ship", "Grunt"}, 
      {"Asteroid", "Small"}, 
    }}, 
    {after = 5, generate = {
      {"Ship", "Grunt"}, 
      {"Asteroid", "Small"}, 
      {"Asteroid", "Medium"}, 
    }}, 
    {after = 3, generate = {
      {"Ship", "Grunt"}, 
      {"Ship", "Grunt"}, 
      {"Asteroid", "Big"}, 
      {"Asteroid", "Medium"}, 
    }}, 
    {after = 5, generate = {
      {"Ship", "Grunt"}, 
      {"Ship", "Grunt"}, 
      {"Ship", "Grunt"}, 
      {"Asteroid", "Small"}, 
      {"Asteroid", "Medium"}, 
      {"Asteroid", "Big"}, 
    }}, 
    {after = 3, generate = {
      {"Ship", "Grunt"}, 
      {"Ship", "Grunt"}, 
      {"Mine", "Slow"}, 
      {"Asteroid", "Small"}, 
      {"Asteroid", "Medium"}, 
    }}, 
    {after = 3, generate = {
      {"Ship", "Grunt"}, 
      {"Ship", "Grunt"}, 
      {"Ship", "Grunt"}, 
      {"Asteroid", "Small"}, 
      {"Asteroid", "Medium"}, 
      {"Asteroid", "Big"}, 
    }}, 
    {after = 5, generate = {
      {"Ship", "Grunt"}, 
      {"Asteroid", "Small"}, 
      {"Asteroid", "Big"}, 
    }}, 
    {after = 10, generate = {
      {"Mine", "Slow"}, 
      {"Ship", "Boss"}, 
      {"Ship", "Grunt"}, 
      {"Asteroid", "Small"}, 
    }}, 
  }, 
}

return Level
