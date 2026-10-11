
local SoundService = {}

SoundService.Players = {}

-- Debe ser la URL de tu propio servicio de conversion.
-- El servicio debe aceptar POST con JSON {"url":"https://.../audio.mp3"}
-- y responder con los bytes de un archivo WAV valido.
SoundService.MP3ConverterUrl = ""

local HttpService = game:GetService("HttpService")

local function getFormat(url)
	local path = string.lower(url):match("^([^?#]*)") or url

	if path:match("%.mp3$") then
		return "mp3"
	end

	if path:match("%.wav$") then
		return "wav"
	end

	return "unknown"
end

local function downloadAudio(url)
	local format = getFormat(url)
	local audioData

	if format == "mp3" then
		assert(
			SoundService.MP3ConverterUrl ~= "",
			"Configura SoundService.MP3ConverterUrl para habilitar MP3"
		)

		audioData = HttpService:PostAsync(
			SoundService.MP3ConverterUrl,
			HttpService:JSONEncode({
				url = url
			}),
			Enum.HttpContentType.ApplicationJson
		)
	elseif format == "wav" then
		audioData = HttpService:GetAsync(url)
	else
		error("Formato no reconocido. Usa una URL terminada en .wav o .mp3")
	end

	assert(type(audioData) == "string", "La respuesta no contiene audio")
	assert(#audioData >= 44, "El archivo de audio esta vacio o incompleto")

	if audioData:sub(1, 4) ~= "RIFF"
		or audioData:sub(9, 12) ~= "WAVE" then
		error("El resultado no es un WAV valido")
	end

	return audioData
end

function SoundService:Init(link)
	assert(type(link) == "string", "Link debe ser una cadena")
	assert(
		link:match("^https://") ~= nil,
		"Solo se permiten URL HTTPS"
	)

	local audioData = downloadAudio(link)

	local folder = Instance.new("Folder")
	folder.Name = HttpService:GenerateGUID(false)
	folder.Parent = workspace.Terrain

	local success, result = pcall(function()
		local player = require(script.WavPlayer).new(folder)

		player:LoadAudio(audioData)

		local sound = {
			_Player = player,
			_Folder = folder,
			Volume = 1,
			Destroyed = false
		}

		sound.Ended = player.Ended

		function sound:Play()
			if self.Destroyed then
				return
			end

			self._Player.Volume = self.Volume
			self._Player:Play()
		end

		function sound:Stop()
			if not self.Destroyed then
				self._Player:Stop()
			end
		end

		function sound:Pause()
			if not self.Destroyed then
				self._Player:Stop()
			end
		end

		function sound:Destroy()
			if self.Destroyed then
				return
			end

			self.Destroyed = true
			self._Player:Destroy()
			self._Folder:Destroy()

			for i, item in ipairs(SoundService.Players) do
				if item == self then
					table.remove(SoundService.Players, i)
					break
				end
			end
		end

		function sound:GetTimeLength()
			return self._Player.TimeLength
		end

		function sound:GetTimePosition()
			return self._Player.TimePosition
		end

		function sound:SetTimePosition(position)
			if not self.Destroyed then
				self._Player.TimePosition = position
			end
		end

		function sound:SetVolume(volume)
			self.Volume = math.clamp(volume, 0, 1)

			if not self.Destroyed then
				self._Player.Volume = self.Volume
			end
		end

		table.insert(SoundService.Players, sound)

		return sound
	end)

	if not success then
		folder:Destroy()
		error(result, 2)
	end

	return result
end

return SoundService
