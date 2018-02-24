--[[

   A handy manager for sound and music files.

    Automatically loads audio files and keeps a track of them.
--]]

local Settings = require("libs.Settings")

local Sounds = {}

local soundsTable = {
  menuMusic = 'audio/Escape_Looping.wav', 
  gameMusic = 'audio/80s-Space-Game_Looping.wav', 
  highScoresMusic = 'audio/Midnight-Crawlers_Looping.wav', 
  fire = 'audio/fire.wav', 
  explosion = 'audio/explosion.wav', 
}

audio.reserveChannels(2)

local audioChannel = 1
local otherAudioChannel = 2
local currentStreamSound
local loadedSounds = {}

local function loadSound(soundName)
  if not loadedSounds[soundName] then
    loadedSounds[soundName] = audio.loadSound(soundsTable[soundName])
  end
  return loadedSounds[soundName]
end

local function loadStream(soundName)
  if not loadedSounds[soundName] then
    loadedSounds[soundName] = audio.loadStream(soundsTable[soundName])
  end
  return loadedSounds[soundName]
end

-- Music files (e.g. background music)
function Sounds.playStream(soundName)
  if not Settings.isMusicOn then return end
  if not soundsTable[soundName] then return end
  if currentStreamSound == soundName then return end

  audio.fadeOut({channel = audioChannel, time = 1000})
  audioChannel, otherAudioChannel = otherAudioChannel, audioChannel
  audio.setVolume(0.5, {channel = audioChannel})
  local musicStream = loadStream(soundName)
  audio.play(musicStream, {channel = audioChannel, loops = -1, fadein = 1000})
  currentStreamSound = soundName
end

-- Short SFX (e.g. explosion)
function Sounds.play(soundName, params)
  if not Settings.isSoundOn then return end
  if not soundsTable[soundName] then return end
  return audio.play(loadSound(soundName), params)
end

function Sounds.dispose(soundName)
  if not soundsTable[soundName] then return end

  sound = loadedSounds[soundName]
  if not sound then return end

  loadedSounds[soundName] = nil
  if soundName == currentStreamSound then
    currentStreamSound = nil
  end

  return audio.dispose(sound)
end

function Sounds.stop()
  currentStreamSound = nil
  audio.stop()
end

return Sounds
