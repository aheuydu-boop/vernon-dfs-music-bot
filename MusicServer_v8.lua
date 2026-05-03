-- MusicServer (Script) - FIXED VERSION v8
-- Taruh di: ServerScriptService

local DataStoreService   = game:GetService("DataStoreService")
local ReplicatedStorage  = game:GetService("ReplicatedStorage")
local SoundService       = game:GetService("SoundService")
local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local FavoritesStore = DataStoreService:GetDataStore("MusicFavorites_v1")

local MusicFolder = Instance.new("Folder")
MusicFolder.Name   = "MusicSystem"
MusicFolder.Parent = ReplicatedStorage

local RE_PlayMusic      = Instance.new("RemoteEvent");    RE_PlayMusic.Name      = "PlayMusic";      RE_PlayMusic.Parent      = MusicFolder
local RE_PauseMusic     = Instance.new("RemoteEvent");    RE_PauseMusic.Name     = "PauseMusic";     RE_PauseMusic.Parent     = MusicFolder
local RE_SkipMusic      = Instance.new("RemoteEvent");    RE_SkipMusic.Name      = "SkipMusic";      RE_SkipMusic.Parent      = MusicFolder
local RE_VoteSkip       = Instance.new("RemoteEvent");    RE_VoteSkip.Name       = "VoteSkip";       RE_VoteSkip.Parent       = MusicFolder
local RE_VoteReject     = Instance.new("RemoteEvent");    RE_VoteReject.Name     = "VoteReject";     RE_VoteReject.Parent     = MusicFolder
local RE_VoteSkipNotify = Instance.new("RemoteEvent");    RE_VoteSkipNotify.Name = "VoteSkipNotify"; RE_VoteSkipNotify.Parent = MusicFolder
local RE_SyncClient     = Instance.new("RemoteEvent");    RE_SyncClient.Name     = "SyncClient";     RE_SyncClient.Parent     = MusicFolder
local RE_UpdateVolume   = Instance.new("RemoteEvent");    RE_UpdateVolume.Name   = "UpdateVolume";   RE_UpdateVolume.Parent   = MusicFolder
local RE_UpdateTheme    = Instance.new("RemoteEvent");    RE_UpdateTheme.Name    = "UpdateTheme";    RE_UpdateTheme.Parent    = MusicFolder
local RE_AddFavorite    = Instance.new("RemoteEvent");    RE_AddFavorite.Name    = "AddFavorite";    RE_AddFavorite.Parent    = MusicFolder
local RF_GetState       = Instance.new("RemoteFunction"); RF_GetState.Name       = "GetState";       RF_GetState.Parent       = MusicFolder

-- ============================================================
-- PLAYLIST
-- ============================================================
local Playlist = {
{ id = 1,  title = "Loading...", artist = "...", assetId = "rbxassetid://123067914344459", duration = 212 },
{ id = 2,  title = "Loading...", artist = "...", assetId = "rbxassetid://100853313037522", duration = 212 },
{ id = 3,  title = "Loading...", artist = "...", assetId = "rbxassetid://139959955565320", duration = 212 },
{ id = 4,  title = "Loading...", artist = "...", assetId = "rbxassetid://136131606497443", duration = 212 },
{ id = 5,  title = "Loading...", artist = "...", assetId = "rbxassetid://75469144573618",  duration = 212 },
{ id = 6,  title = "Loading...", artist = "...", assetId = "rbxassetid://127174585980758", duration = 212 },
{ id = 7,  title = "Loading...", artist = "...", assetId = "rbxassetid://82901199162525",  duration = 212 },
{ id = 8,  title = "Loading...", artist = "...", assetId = "rbxassetid://104972728935567", duration = 212 },
{ id = 9,  title = "Loading...", artist = "...", assetId = "rbxassetid://112354143013557", duration = 212 },
{ id = 10, title = "Loading...", artist = "...", assetId = "rbxassetid://124694482014489", duration = 212 },
{ id = 11, title = "Loading...", artist = "...", assetId = "rbxassetid://114922938516306", duration = 212 },
{ id = 12, title = "Loading...", artist = "...", assetId = "rbxassetid://105458911834326", duration = 212 },
{ id = 13, title = "Loading...", artist = "...", assetId = "rbxassetid://132053163943333", duration = 212 },
{ id = 14, title = "Loading...", artist = "...", assetId = "rbxassetid://110437915482937", duration = 212 },
{ id = 15, title = "Loading...", artist = "...", assetId = "rbxassetid://118531507596301", duration = 212 },
{ id = 16, title = "Loading...", artist = "...", assetId = "rbxassetid://115079296279783", duration = 212 },
{ id = 17, title = "Loading...", artist = "...", assetId = "rbxassetid://131013059779572", duration = 212 },
{ id = 18, title = "Loading...", artist = "...", assetId = "rbxassetid://132386474807781", duration = 212 },
{ id = 19, title = "Loading...", artist = "...", assetId = "rbxassetid://131013059779572", duration = 212 },
{ id = 20, title = "Loading...", artist = "...", assetId = "rbxassetid://78179764508430",  duration = 212 },
{ id = 21, title = "Loading...", artist = "...", assetId = "rbxassetid://109307504562295", duration = 212 },
{ id = 22, title = "Loading...", artist = "...", assetId = "rbxassetid://87490227672691",  duration = 212 },
{ id = 23, title = "Loading...", artist = "...", assetId = "rbxassetid://121085856771469", duration = 212 },
{ id = 24, title = "Loading...", artist = "...", assetId = "rbxassetid://84616396843117",  duration = 212 },
{ id = 25, title = "Loading...", artist = "...", assetId = "rbxassetid://83850998101314",  duration = 212 },
{ id = 26, title = "Loading...", artist = "...", assetId = "rbxassetid://97236887885874",  duration = 212 },
{ id = 27, title = "Loading...", artist = "...", assetId = "rbxassetid://114286758610517", duration = 212 },
{ id = 28, title = "Loading...", artist = "...", assetId = "rbxassetid://72182145724881",  duration = 212 },
{ id = 29, title = "Loading...", artist = "...", assetId = "rbxassetid://111468218997965", duration = 212 },
{ id = 30, title = "Loading...", artist = "...", assetId = "rbxassetid://105307621103712", duration = 212 },
{ id = 31, title = "Loading...", artist = "...", assetId = "rbxassetid://75963011337253",  duration = 212 },
}

-- ============================================================
-- AUTO-BACA NAMA & DURASI LAGU
-- ============================================================
local function getAssetIdNumber(assetId)
    return tonumber(assetId:match("%d+"))
end

local function fetchSongInfo(song)
    task.spawn(function()
        local numId = getAssetIdNumber(song.assetId)
        if not numId then return end
        local ok, info = pcall(function()
            return MarketplaceService:GetProductInfo(numId, Enum.InfoType.Asset)
        end)
        if ok and info then
            if info.Name and info.Name ~= "" then
                song.title = info.Name
                print(string.format("[MusicServer] 🎵 %s", song.title))
            end
            if info.Creator and info.Creator.Name and info.Creator.Name ~= "" then
                song.artist = info.Creator.Name
            end
        end
        local sound = Instance.new("Sound")
        sound.SoundId = song.assetId
        sound.Parent  = SoundService
        if not sound.IsLoaded then
            local loadOk = pcall(function() sound.Loaded:Wait() end)
                if not loadOk then sound:Destroy(); return end
            end
            if sound.TimeLength and sound.TimeLength > 0 then
                song.duration = sound.TimeLength
                print(string.format("[MusicServer] ⏱ %s → %.1f dtk", song.title, song.duration))
            end
            sound:Destroy()
        end)
    end
    
    for _, song in ipairs(Playlist) do
        fetchSongInfo(song)
    end
    
    -- ============================================================
    -- STATE
    -- ============================================================
    local MusicState = {
    currentIndex = 1,
    isPlaying    = false,
    isPaused     = false,
    volume       = 0.5,
    timePosition = 0,
    startTick    = 0,
    themeColor   = Color3.fromHex("AA44FF"),
    }
    
    -- ============================================================
    -- FAVORIT PER PLAYER
    -- ============================================================
    local playerFavorites = {}
    
    local function loadFavorites(player)
        local ok, data = pcall(function()
            return FavoritesStore:GetAsync("fav_" .. player.UserId)
        end)
        if ok and type(data) == "table" then
            playerFavorites[player.UserId] = data
        else
            playerFavorites[player.UserId] = {}
        end
    end
    
    local function saveFavorites(player)
        local favs = playerFavorites[player.UserId] or {}
        pcall(function()
            FavoritesStore:SetAsync("fav_" .. player.UserId, favs)
        end)
    end
    
    local function getFavs(player)
        return playerFavorites[player.UserId] or {}
    end
    
    -- ============================================================
    -- VOTE SKIP STATE
    -- ============================================================
    local VoteActive = false
    local VoteData   = { initiator = "", songTitle = "", voters = {}, targetSongId = nil }
    local voteTimeout = nil
    
    local function getPlayerCount()
        return math.max(1, #Players:GetPlayers())
    end
    
    local function getVoteRequired()
        local total = getPlayerCount()
        if total <= 1 then return 1 end
        return math.max(2, math.ceil(total / 2))
    end
    
    -- ============================================================
    -- BROADCAST
    -- ============================================================
    local function buildBaseSync()
        return {
        song         = Playlist[MusicState.currentIndex],
        isPlaying    = MusicState.isPlaying,
        isPaused     = MusicState.isPaused,
        volume       = MusicState.volume,
        timePosition = MusicState.isPlaying and (tick() - MusicState.startTick) or MusicState.timePosition,
        themeColor   = MusicState.themeColor,
        playlist     = Playlist,
        voteActive   = VoteActive,
        voteCount    = #VoteData.voters,
        voteRequired = getVoteRequired(),
        }
    end
    
    local function broadcastSync()
        local base = buildBaseSync()
        for _, player in ipairs(Players:GetPlayers()) do
            local data = {}
            for k, v in pairs(base) do data[k] = v end
            data.favorites = getFavs(player)
            RE_SyncClient:FireClient(player, data)
        end
    end
    
    local function broadcastVoteUpdate()
        RE_SyncClient:FireAllClients({
        voteOnly     = true,
        voteCount    = #VoteData.voters,
        voteRequired = getVoteRequired(),
        })
    end
    
    -- ============================================================
    -- PLAY / SKIP
    -- ============================================================
    local function resetVote()
        VoteActive = false
        VoteData   = { initiator = "", songTitle = "", voters = {}, targetSongId = nil }
        if voteTimeout then
            task.cancel(voteTimeout)
            voteTimeout = nil
        end
    end
    
    local function playSong(index)
        if index < 1 then index = #Playlist end
        if index > #Playlist then index = 1 end
        MusicState.currentIndex = index
        MusicState.isPlaying    = true
        MusicState.isPaused     = false
        MusicState.timePosition = 0
        MusicState.startTick    = tick()
        resetVote()
        broadcastSync()
        print("[MusicServer] ▶ Playing:", Playlist[index].title)
    end
    
    local function skipSong()
        local next = MusicState.currentIndex + 1
        if next > #Playlist then next = 1 end
        playSong(next)
    end
    
    -- ============================================================
    -- AUTO-SKIP SAAT LAGU HABIS
    -- ============================================================
    task.spawn(function()
        while true do
            task.wait(1)
            if MusicState.isPlaying then
                local elapsed = tick() - MusicState.startTick
                local song    = Playlist[MusicState.currentIndex]
                if song and elapsed >= song.duration + 1 then
                    print("[MusicServer] ⏭ Auto-skip")
                    skipSong()
                end
            end
        end
    end)
    
    -- ============================================================
    -- REMOTE HANDLERS
    -- ============================================================
    
    RF_GetState.OnServerInvoke = function(player)
        local base = buildBaseSync()
        base.favorites = getFavs(player)
        return base
    end
    
    RE_PlayMusic.OnServerEvent:Connect(function(player)
        if MusicState.isPaused then
            MusicState.isPaused  = false
            MusicState.isPlaying = true
            MusicState.startTick = tick() - MusicState.timePosition
        else
            playSong(MusicState.currentIndex)
        end
        broadcastSync()
    end)
    
    RE_PauseMusic.OnServerEvent:Connect(function(player)
        if MusicState.isPlaying then
            MusicState.timePosition = tick() - MusicState.startTick
            MusicState.isPlaying    = false
            MusicState.isPaused     = true
            broadcastSync()
        end
    end)
    
    -- ============================================================
    -- VOTE SKIP
    -- ============================================================
    local function handleSkipRequest(player, targetSongId)
        local totalPlayers = #Players:GetPlayers()
        
        if totalPlayers <= 1 then
            if targetSongId then
                for i, song in ipairs(Playlist) do
                    if song.id == targetSongId then playSong(i); return end
                end
            end
            skipSong()
            return
        end
        
        local voteRequired = getVoteRequired()
        
        if not VoteActive then
            local notifTitle
            if targetSongId then
                for _, song in ipairs(Playlist) do
                    if song.id == targetSongId then notifTitle = song.title; break end
                end
            end
            notifTitle = notifTitle or Playlist[MusicState.currentIndex].title
            
            VoteActive = true
            VoteData = {
            initiator    = player.Name,
            songTitle    = notifTitle,
            voters       = { player.UserId },
            targetSongId = targetSongId,
            }
            
            print(string.format("[MusicServer] 🗳️ %s request skip '%s' (%d/%d)",
            player.Name, notifTitle, 1, voteRequired))
            
            RE_VoteSkipNotify:FireAllClients(player.Name, notifTitle, 1, voteRequired)
            
            voteTimeout = task.delay(30, function()
                if VoteActive then
                    print("[MusicServer] ⏰ Vote timeout, dibatalkan")
                    resetVote()
                    broadcastVoteUpdate()
                end
            end)
            
        else
            for _, uid in ipairs(VoteData.voters) do
                if uid == player.UserId then return end
                end
                    
                    table.insert(VoteData.voters, player.UserId)
                    local voteCount = #VoteData.voters
                    
                    print(string.format("[MusicServer] 🗳️ %s setuju | %d/%d",
                    player.Name, voteCount, voteRequired))
                    
                    broadcastVoteUpdate()
                    
                    if voteCount >= voteRequired then
                        print("[MusicServer] ✅ Vote berhasil! Skip lagu...")
                        local savedTarget = VoteData.targetSongId
                        resetVote()
                        task.wait(0.3)
                        if savedTarget then
                            for i, song in ipairs(Playlist) do
                                if song.id == savedTarget then playSong(i); return end
                            end
                        end
                        skipSong()
                    end
                end
            end
            
            -- ============================================================
            -- TOLAK VOTE
            -- ============================================================
            RE_VoteReject.OnServerEvent:Connect(function(player)
                if not VoteActive then return end
                
                print(string.format("[MusicServer] ❌ %s menolak vote skip → vote dibatalkan", player.Name))
                resetVote()
                
                RE_SyncClient:FireAllClients({ voteCancelled = true })
            end)
            
            RE_SkipMusic.OnServerEvent:Connect(function(player, songId)
                handleSkipRequest(player, songId)
            end)
            
            RE_VoteSkip.OnServerEvent:Connect(function(player)
                handleSkipRequest(player, nil)
            end)
            
            RE_UpdateVolume.OnServerEvent:Connect(function(player, vol)
                MusicState.volume = math.clamp(vol, 0, 1)
            end)
            
            RE_UpdateTheme.OnServerEvent:Connect(function(player, color)
                MusicState.themeColor = color
                broadcastSync()
            end)
            
            RE_AddFavorite.OnServerEvent:Connect(function(player, songId)
                local favs = getFavs(player)
                local alreadyFav = false
                for i, fid in ipairs(favs) do
                    if fid == songId then
                        table.remove(favs, i)
                        alreadyFav = true
                        break
                    end
                end
                if not alreadyFav then
                    table.insert(favs, songId)
                end
                playerFavorites[player.UserId] = favs
                saveFavorites(player)
                local data = buildBaseSync()
                data.favorites = favs
                RE_SyncClient:FireClient(player, data)
            end)
            
            -- ============================================================
            -- PLAYER JOIN / LEAVE
            -- ============================================================
            Players.PlayerAdded:Connect(function(player)
                loadFavorites(player)
                task.wait(1)
                local data = buildBaseSync()
                data.favorites = getFavs(player)
                RE_SyncClient:FireClient(player, data)
                print(string.format("[MusicServer] 👤 %s join, sync lagu '%s' di %.1f dtk",
                player.Name,
                Playlist[MusicState.currentIndex].title,
                data.timePosition))
            end)
            
            Players.PlayerRemoving:Connect(function(player)
                saveFavorites(player)
                playerFavorites[player.UserId] = nil
                
                if VoteActive then
                    local remaining = #Players:GetPlayers() - 1
                    if remaining <= 0 then
                        resetVote()
                    elseif VoteData.initiator == player.Name then
                        print("[MusicServer] 🚪 Initiator keluar, vote dibatalkan")
                        resetVote()
                        RE_SyncClient:FireAllClients({ voteCancelled = true })
                    end
                end
            end)
            
            -- ============================================================
            -- START
            -- ============================================================
            task.wait(0.5)
            playSong(1)
            print("[MusicServer] ✅ Music System v8 siap!")
            print("[MusicServer] ℹ️ Vote skip butuh", getVoteRequired(), "suara setuju")
            print("[MusicServer] ℹ️ Tolak dari 1 player sudah cukup batalkan vote")
