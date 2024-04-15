addCommandHandler("team",
    function(player, cmd, teamName)
        -- Ha a játékos nem adott meg csapatnevet, vagy rosszul adta meg
        if not teamName or teamName == "" then
            local availableTeams = "" -- Kezdő karakterlánc az elérhető csapatoknak
            -- Végigiterálunk az összes csapaton
            for _, team in ipairs(getElementsByType("team")) do
                -- Hozzáadjuk a csapat nevét az elérhető csapatok listájához
                availableTeams = availableTeams .. getTeamName(team) .. ", "
            end
            -- Az utolsó vessző és a szóköz eltávolítása a karakterlánc végéről
            availableTeams = string.sub(availableTeams, 1, -3)
            -- Kiírjuk az összes elérhető csapat nevét
            outputChatBox("Elérhető csapatok: " .. availableTeams, player, 255, 255, 255)
            return -- Kilépünk a függvényből, nem folytatjuk tovább a végrehajtást
        end

        -- Ellenőrizzük, hogy a megadott csapat létezik-e
        local requestedTeam = getTeamFromName(teamName)
        if requestedTeam then
            -- Csatlakoztatjuk a játékost a kért csapathoz
            setPlayerTeam(player, requestedTeam)
            -- Kiírjuk az üzenetet a sikeres csatlakozásról
            outputChatBox("Sikeresen csatlakoztál a(z) " .. teamName .. " csapathoz!", player, 0, 255, 0)
        else
            -- Ha a csapat nem létezik, kiírjuk a hibaüzenetet
            outputChatBox("A(z) " .. teamName .. " csapat nem található!", player, 255, 0, 0)
        end
    end
)


-- A traitor csapat létrehozása a resource indításakor
addEventHandler("onResourceStart", resourceRoot,
    function (player, res)
        -- Megpróbáljuk megkapni a "Traitor" csapatot
        local traitorTeam = getTeamFromName("Traitor")
        -- Ha a csapat nem létezik, létrehozzuk
        if not traitorTeam then
            traitorTeam = createTeam("traitor", 255, 0, 0) -- A csapat létrehozása piros színnel
            -- Ellenőrizzük, hogy sikerült-e létrehozni a csapatot
            if traitorTeam then
                outputDebugString("A Traitor csapat létrejött!") -- Kiírjuk a konzolba, hogy a csapat létrejött
            else
                outputDebugString("A Traitor csapat létrehozása sikertelen!") -- Kiírjuk a konzolba, hogy a csapat létrehozása sikertelen volt
            end
        end

        local innocentTeam = getTeamFromName("Innocent")
        if not innocentTeam then
            innocentTeam = createTeam("innocent", 54, 198, 227) -- A csapat létrehozása kék színnel
            -- Ellenőrizzük, hogy sikerült-e létrehozni a csapatot
            if innocentTeam then
                outputDebugString("Az Innocent csapat létrejött!") -- Kiírjuk a konzolba, hogy a csapat létrejött
            else
                outputDebugString("Az Innocent csapat létrehozása sikertelen!") -- Kiírjuk a konzolba, hogy a csapat létrehozása sikertelen volt
            end
        end

        local detectiveTeam = getTeamFromName("Detective")
        if not detectiveTeam then
            detectiveTeam = createTeam("detective", 3, 148, 252) -- A csapat létrehozása sárga színnel
            -- Ellenőrizzük, hogy sikerült-e létrehozni a csapatot
            if detectiveTeam then
                outputDebugString("A Detective csapat létrejött!") -- Kiírjuk a konzolba, hogy a csapat létrejött
            else
                outputDebugString("A Detective csapat létrehozása sikertelen!") -- Kiírjuk a konzolba, hogy a csapat létrehozása sikertelen volt
            end
        end
        addPlayerToTeam()
    end
)

function addPlayerToTeam(player, chosenTeam, armorlevel, base_weapon)

    local players = getElementsByType("player") -- Összes játékos lekérése

    -- Ha nincs játékos a szerveren, kilépünk a függvényből
    if #players == 0 then
        return
    end

    for _, player in ipairs(players) do -- Végigmegyünk minden játékoson
        local randomNumber = math.random(1, 3)
        local chosenTeam = nil
        local armorlevel = 0
        local base_weapon = 0

        -- Véletlenszerűen választunk egy csapatot
        if randomNumber == 1 then
            chosenTeam = getTeamFromName("traitor")
            base_weapon = 30
        elseif randomNumber == 2 then
            chosenTeam = getTeamFromName("innocent")
            base_weapon = 22
        else
            chosenTeam = getTeamFromName("detective")
            armorlevel = 100
            base_weapon = 23
        end

        takeAllWeapons(root)
        setPlayerTeam(player, chosenTeam)
        setPedArmor(player, armorlevel)
        setElementHealth(player, 100)
        giveWeapon(player, base_weapon, 200)
        outputDebugString("A játékos hozzá lett adva a(z) " .. getTeamName(chosenTeam) .. " csapathoz!")

        outputChatBox("A(z) #ff0000" .. getTeamName(chosenTeam) .. " #ffffffcsapat tagja lettél.", player, 255,255,255,true)
    end
end

local disabled = {'innocent', 'detective'}

-- Az "onPlayerChat" eseménykezelő hozzáadása
addEventHandler("onPlayerChat", root, 
    function (_, type) 
        if (type == 2) then -- Csapatüzenet
            local playerTeam = getPlayerTeam(source) -- Az adott játékos csapata
            if (playerTeam) then -- Ha a játékos csapatban van
                local teamName = getTeamName(playerTeam) -- A játékos csapatának neve
                for _, disabledTeamName in ipairs(disabled) do -- Végigmegyünk a tiltott csapatokon
                    if (teamName == disabledTeamName) then -- Ha a játékos a tiltott csapatban van
                        -- Visszautasítjuk a chat üzenetet
                        cancelEvent()
                        -- Kiírunk egy hibaüzenetet a játékosnak
                        outputChatBox("Csak a Traitor csapat tagjai tudnak csapatüzenetet küldeni!", source, 255, 0, 0)
                        return
                    end
                end
            end 
        end 
    end 
)

function onPlayerJoin()
    for _, player in ipairs(getElementsByType("player")) do
        attachNameLabel(player)
    end
end
addEventHandler("onPlayerJoin", root, onPlayerJoin)

function attachNameLabel(player)
    local nameLabel = createElement("text")
    setElementData(nameLabel, "attachedTo", player)
    setElementData(nameLabel, "name", getPlayerName(player))
end

function renderNameLabels()
    for _, player in ipairs(getElementsByType("player")) do
        local nameLabel = getElementData(player, "nameLabel")
        if nameLabel then
            local x, y, z = getElementPosition(player)
            y = y + 1.5 -- A fej felett 1.5 méterrel
            setElementPosition(nameLabel, x, y, z)
        end
    end
end
addEventHandler("onClientRender", root, renderNameLabels)