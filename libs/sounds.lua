-- Sounds library
-- Manager for the sound and music files.
-- Automatically loads files and keeps a track of them.
-- Use playSteam() for music files and play() for short SFX files.
local _M = {}

_M.isSoundOn = true
_M.isMusicOn = true

local sounds = {
    menuMusic = 'audio/Escape_Looping.wav',
    gameMusic = 'audio/80s-Space-Game_Looping.wav',
    highScoresMusic = 'audio/Midnight-Crawlers_Looping.wav',
    fire = 'audio/fire.wav',
	explosion = 'audio/explosion.wav',
}

-- Keep all loaded sounds here
local loadedSounds = {}
local function loadSound(sound)
    if not loadedSounds[sound] then
        loadedSounds[sound] = audio.loadSound(sounds[sound])
    end
    return loadedSounds[sound]
end

local function loadStream(sound)
    if not loadedSounds[sound] then
        loadedSounds[sound] = audio.loadStream(sounds[sound])
    end
    return loadedSounds[sound]
end

-- Reserve two channels for streams and switch between them with a nice fade out / fade in transition
audio.reserveChannels(2)
local audioChannel, otherAudioChannel, currentStreamSound = 1, 2
function _M.playStream(sound, force)
    if not _M.isMusicOn then return end
    if not sounds[sound] then
        return
    end
    if currentStreamSound == sound and not force then return end
    audio.fadeOut({channel = audioChannel, time = 1000})
    audioChannel, otherAudioChannel = otherAudioChannel, audioChannel
    audio.setVolume(0.5, {channel = audioChannel})
    audio.play(loadStream(sound), {channel = audioChannel, loops = -1, fadein = 1000})
    currentStreamSound = sound
end

function _M.play(sound, params)
    if not _M.isSoundOn then return end
    if not sounds[sound] then
        return        
    end
    return audio.play(loadSound(sound), params)
end

function _M.dispose(sound)
    if not sounds[sound] then
        return
    end
    
    handle = loadedSounds[sound]
    if not handle then return end
    
    loadedSounds[sound] = nil
    if sound == currentStreamSound then
        currentStreamSound = nil
    end
    
    return audio.dispose(handle)
end

function _M.stop()
    currentStreamSound = nil
    audio.stop()
end

return _M
