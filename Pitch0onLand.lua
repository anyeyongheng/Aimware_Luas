--code by @Zixtty1887 - https://aimware.net/forum/user/346116
--AIMWARE  
local function isVisible(entity)
    if not entity then
        return false
    end

    if entity:IsDormant() or not entity:IsAlive() then
        return false
    end

    local lp = entities.GetLocalPlayer()
    if not lp then
        return false
    end

    local start = lp:GetBonePosition(8)
    local _end = entity:GetBonePosition(8)

    local trace = engine.TraceLine(start, _end, 0xFFFFFFFF)
    local index = trace.entity and trace.entity:GetIndex() or -1

    return index == entity:GetIndex()
end
local function esp(EspBuilder) 
    local ent = EspBuilder:GetEntity();
 
 end

 
local misc_tab = gui.Tab(gui.Reference("Misc"), "ai_ragebot", "AI_Rage");
local maingroup = gui.Groupbox(misc_tab, "Main", 16, 10, 297, 200)
local pitch_0_onland = gui.Checkbox(maingroup, "pitch_0_onland", "Pitch 0 On Land", false)
local pitch_0_onland_second = gui.Slider(maingroup, "pitch_0_onland_second", "Maintain Time", 0.3, 0.1, 2.0, 0.01);

local cache_pitch = 0;
local pitchTime = common.Time()
local function move(UserCmd)
    if pitch_0_onland:GetValue() then
        pitch_0_onland_second:SetInvisible(false);
    else
        pitch_0_onland_second:SetInvisible(true);
    end
    -------------------------------------------------------------------------
    local pitch_mode = {
        0,--off
        1,--89
        2,--0
        3 --180
    }

    local localplayer = entities.GetLocalPlayer();
    local pitch = localplayer:GetPropVector("localdata","m_vecVelocity[0]").z;
    if cache_pitch ~= 0 and pitch == 0 and pitch_0_onland:GetValue() and localplayer:GetWeaponType() ~= 0  then
        if bit.band(UserCmd.buttons, bit.lshift(1, 0)) ~= 1 then -- not shooting
            local players = entities.FindByClass("CCSPlayer");
            local localPosition = entities.GetLocalPlayer():GetAbsOrigin()
            for i = 1, #players do
                local player = players[i];
                if player:IsDormant() == false and player:GetTeamNumber() ~= entities.GetLocalPlayer():GetTeamNumber() and player:IsAlive() then
                    local playerPosition = player:GetAbsOrigin()
                    local endPos = engine.TraceLine(localPosition, playerPosition).endpos
                    local content =  engine.GetPointContents(endPos, MASK_SOLID)
                    if content == 0 then
                        pitchTime = common.Time()
                        break;
                    end
                    
                end
            end
            
        end
    else
        gui.SetValue("rbot.antiaim.advanced.pitch",pitch_mode[2]);
    end 
    if common.Time() - pitchTime < pitch_0_onland_second:GetValue() and pitch == 0 then
        gui.SetValue("rbot.antiaim.advanced.pitch",pitch_mode[3]);
    end

    cache_pitch = pitch;
    
 end
 callbacks.Register("CreateMove", "Move", move);
 callbacks.Register("DrawESP", "ESP", esp);
