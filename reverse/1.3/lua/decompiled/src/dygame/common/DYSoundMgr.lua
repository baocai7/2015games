local M = {}
local S_MUSIC_ON = true
local S_SOUND_ON = true
local kMusicSwitch = DY_KEY.kMusicSwitch
local kSoundSwitch = DY_KEY.kSoundSwitch

local function init()
  S_MUSIC_ON = DYStat.getValueBool(kMusicSwitch, true)
  S_SOUND_ON = DYStat.getValueBool(kSoundSwitch, true)
end

init()

function M.playMusic(music)
  if not music then
    return
  end
  if S_MUSIC_ON == true then
    audio.playMusic(music, true)
  end
end

function M.stopMusic(isReleaseData)
  audio.stopMusic(isReleaseData)
end

function M.pauseMusic()
  audio.pauseMusic()
end

function M.resumeMusic()
  if S_MUSIC_ON == true then
    audio.resumeMusic()
  end
end

function M.preloadMusic(snd)
  if not snd then
    return
  end
  if S_MUSIC_ON == true then
    audio.preloadMusic(snd)
  end
end

function M.preloadEffect(snd)
  if not snd then
    return
  end
  if S_SOUND_ON == true then
    audio.preloadSound(snd)
  end
end

function M.playBuddhaEffect(buddhaId, loop)
  local soundPath = "sounds/buddha/sound_buddha" .. buddhaId .. ".mp3"
  M.playEffect(soundPath, loop)
end

function M.playEffect(snd, loop)
  if not snd then
    return
  end
  if S_SOUND_ON == true then
    local bLoop = loop or false
    return audio.playSound(snd, bLoop)
  end
end

function M.stopEffect(id)
  if id then
    audio.stopSound(id)
  end
end

function M.setMusicOn(flag)
  S_MUSIC_ON = flag
  DYStat.setValueBool(kMusicSwitch, S_MUSIC_ON)
end

function M.getMusicOn()
  return S_MUSIC_ON
end

function M.setSoundOn(flag)
  S_SOUND_ON = flag
  DYStat.setValueBool(kSoundSwitch, S_SOUND_ON)
end

function M.getSoundOn()
  return S_SOUND_ON
end

return M
