local M = {
  waves = {
    {after = 1, generate = {
      {"Player", "default"}, 
    }}, 
    {after = 5, generate = {
      {"Enemy", "grunt"}, 
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock1"}, 
    }}, 
    {after = 5, generate = {
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock3"}, 
      {"Asteroid", "rock1"}, 
    }}, 
    {after = 5, generate = {
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock3"}, 
      {"Asteroid", "rock1"}, 
    }}, 
    {after = 5, generate = {
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock3"}, 
      {"Asteroid", "rock1"}, 
    }}, 
    {after = 5, generate = {
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock3"}, 
      {"Asteroid", "rock1"}, 
    }}, 
    {after = 5, generate = {
      {"Enemy", "boss"}, 
    }}, 
  }}

  return M


 