local M = {
  waves = {
    {after = 1, generate = {
      {"Player", "default"}, 
    }}, 
    {after = 1, generate = {
      {"Enemy", "grunt"}, 
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock1"}, 
    }}, 
    {after = 5, generate = {
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock1"}, 
      {"Asteroid", "rock2"}, 
    }}, 
    {after = 3, generate = {
      {"Enemy", "grunt"}, 
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock3"}, 
      {"Asteroid", "rock2"}, 
    }}, 
    {after = 5, generate = {
      {"Enemy", "grunt"}, 
      {"Enemy", "grunt"}, 
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock1"}, 
      {"Asteroid", "rock2"}, 
      {"Asteroid", "rock3"}, 
    }}, 
    {after = 3, generate = {
      {"Enemy", "grunt"}, 
      {"Enemy", "grunt"}, 
      {"Mine", "static"}, 
      {"Mine", "static"}, 
      {"Asteroid", "rock1"}, 
      {"Asteroid", "rock2"}, 
    }}, 
    {after = 3, generate = {
      {"Enemy", "grunt"}, 
      {"Enemy", "grunt"}, 
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock1"}, 
      {"Asteroid", "rock2"}, 
      {"Asteroid", "rock3"}, 
    }}, 
    {after = 5, generate = {
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock1"}, 
      {"Asteroid", "rock3"}, 
    }}, 
    {after = 10, generate = {
      {"Enemy", "boss"}, 
      {"Enemy", "grunt"}, 
      {"Asteroid", "rock1"}, 
    }}}}

    return M


   