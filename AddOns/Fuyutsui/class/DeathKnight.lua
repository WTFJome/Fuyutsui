local _, fu = ...
if fu.classId ~= 6 then return end
local creat = fu.updateOrCreatTextureByIndex
fu.HarmfulSpellId = 47528

function fu.CreateClassMacro()
    local dynamicSpells = {}
    local staticSpells = {
        [1] = "亡者复生",
        [2] = "亡者大军",
        [3] = "凋零缠绕",
        [4] = "天灾打击",
        [5] = "扩散",
        [6] = "爆发",
        [7] = "脓疮打击",
        [8] = "腐化",
        [9] = "黑暗突变",
        [10] = "灵魂收割",
        [11] = "灵界打击",
        [12] = "心脏打击",
        [13] = "[@player]枯萎凋零",
        [14] = "死神的抚摸",
        [15] = "符文刃舞",
        [16] = "精髓分裂",
        [17] = "血液沸腾",
        [18] = "吸血鬼之血",
        [19] = "冰封之韧",
        [20] = "巫妖之躯",
    }
    fu.CreateMacro(dynamicSpells, staticSpells, _)
end

-- 更新法术发光效果
function fu.updateSpellOverlay(spellId)
    if not fu.blocks or not fu.blocks.auras then return end
    local isSpellOverlayed = C_SpellActivationOverlay.IsSpellOverlayed(spellId)
    if spellId == 49998 then
        if isSpellOverlayed then
            fu.blocks.auras.darkSuccor.expirationTime = GetTime() + fu.blocks.auras.darkSuccor.duration
        else
            fu.blocks.auras.darkSuccor.expirationTime = nil
        end
    end
end

function fu.updateSpellSuccess(spellID)
    if not fu.blocks or not fu.blocks.auras then return end
    if spellID == 85948 or spellID == 458128 then -- 脓疮打击, 脓疮毒镰, 腐化
        fu.blocks.auras.lesserGhoul.count = math.min(8, fu.blocks.auras.lesserGhoul.count + 1.5)
    elseif spellID == 55090 then                  -- 天灾打击
        fu.blocks.auras.lesserGhoul.count = math.max(0, fu.blocks.auras.lesserGhoul.count - 1)
        C_Timer.After(0.1, function()
            if fu.updateUsesSpell == nil then
                fu.blocks.auras.lesserGhoul.count = 0
                fu.blocks.auras.lesserGhoul.expirationTime = nil
            end
        end)
    elseif spellID == 42650 then                      -- 亡者大军
        fu.blocks.auras.forbiddenKnowledge.expirationTime = GetTime() + fu.blocks.auras.forbiddenKnowledge.duration
    elseif spellID == 47541 or spellID == 207317 then -- 凋零缠绕, 扩散
        fu.blocks.auras.suddenDoom.applications = math.max(0, fu.blocks.auras.suddenDoom.applications - 1)
    end
end

function fu.updateSpellIcon(spellId)
    if not fu.blocks or not fu.blocks.auras then return end
    local overrideSpellID = C_Spell.GetOverrideSpell(spellId)
    if spellId == 85948 then -- 脓疮打击
        if overrideSpellID == 458128 then
            fu.blocks.auras.festering.expirationTime = GetTime() + fu.blocks.auras.festering.duration
        elseif overrideSpellID == 85948 then
            fu.blocks.auras.festering.expirationTime = nil
        end
    end
end

function fu.updateSpellCooldownByEvent(spellId)
    if not fu.blocks or not fu.blocks.auras then return end
    if spellId == 1254252 then -- 次级食尸鬼
        fu.blocks.auras.lesserGhoul.count = math.min(8, fu.blocks.auras.lesserGhoul.count + 1)
        fu.blocks.auras.lesserGhoul.expirationTime = GetTime() + fu.blocks.auras.lesserGhoul.duration
    elseif spellId == 81340 then
        fu.blocks.auras.suddenDoom.applications = math.min(2, fu.blocks.auras.suddenDoom.applications + 1)
        fu.blocks.auras.suddenDoom.expirationTime = GetTime() + fu.blocks.auras.suddenDoom.duration
    end
end

function fu.updateOnUpdate()
    if not fu.blocks or not fu.blocks.auras then return end
    for _, aura in pairs(fu.blocks.auras) do
        if aura.expirationTime then
            aura.remaining = math.floor(aura.expirationTime - GetTime() + 0.5)
            if aura.count then
                creat(aura.index, aura.count / 255)
            else
                if aura.remaining > 0 then
                    creat(aura.index, aura.remaining / 255)
                else
                    aura.expirationTime = nil
                    creat(aura.index, 0)
                end
            end
        else
            aura.remaining = 0
            creat(aura.index, 0)
        end
        if aura.applications and aura.applications <= 0 then
            aura.expirationTime = nil
            creat(aura.index, 0)
        end
    end
end

function fu.updateSpecInfo()
    local specIndex = C_SpecializationInfo.GetSpecialization()
    fu.powerType = nil
    fu.blocks = nil
    fu.group_blocks = nil
    fu.assistant_spells = nil
    if specIndex == 1 then
        fu.blocks = {
            runes = 11,
            assistant = 12,
            target_valid = 13,
            target_health = 14,
            enemy_count = 15,
            spell_cd = {
                { index = 16, spellId = 46584, name = "亡者复生" },
                { index = 17, spellId = 55233, name = "吸血鬼之血" },
                { index = 18, spellId = 48792, name = "冰封之韧" },
                { index = 19, spellId = 49039, name = "巫妖之躯" },
            }
        }
        fu.assistant_spells = {
            [206930] = 1, -- 心脏打击
            [43265] = 2,  -- 枯萎凋零
            [195292] = 3, -- 死神的抚摸
            [49998] = 4,  -- 灵界打击
            [49028] = 5,  -- 符文刃舞
            [195182] = 6, -- 精髓分裂
            [50842] = 7,  -- 血液沸腾
            [433895] = 8, -- 吸血鬼打击
        }
    elseif specIndex == 3 then
        fu.blocks = {
            runes = 11,
            assistant = 12,
            target_valid = 13,
            target_health = 14,
            enemy_count = 15,
            spell_cd = {
                [46584] = { index = 16, spellId = 46584, name = "亡者复生" },
                [42650] = { index = 17, spellId = 42650, name = "亡者大军" },
                [1247378] = { index = 18, spellId = 1247378, name = "腐化" },
                [1233448] = { index = 19, spellId = 1233448, name = "黑暗突变" },
                [343294] = { index = 20, spellId = 343294, name = "灵魂收割" },
            },
            spell_charge = {
                [1247378] = { index = 21, spellId = 1247378, name = "腐化" },
            },
            auras = {
                festering = {
                    name = "脓疮毒镰",
                    spellId = 85948,
                    index = 22,
                    remaining = 0,
                    duration = 15,
                    expirationTime = nil,
                },
                lesserGhoul = {
                    name = "次级食尸鬼",
                    index = 23,
                    count = 0,
                    remaining = 0,
                    duration = 30,
                    expirationTime = nil,
                },
                suddenDoom = {
                    name = "末日突降",
                    spellId = 81340,
                    applications = 0,
                    index = 24,
                    remaining = 0,
                    duration = 10,
                    expirationTime = nil,
                },
                darkSuccor = {
                    name = "黑暗援助",
                    index = 25,
                    remaining = 0,
                    duration = 10,
                    expirationTime = nil,
                },
                forbiddenKnowledge = {
                    name = "禁断知识",
                    index = 26,
                    remaining = 0,
                    duration = 30,
                    expirationTime = nil,
                },
            }
        }
        fu.assistant_spells = {
            [46584] = 1,    -- 亡者复生
            [42650] = 2,    -- 亡者大军
            [47541] = 3,    -- 凋零缠绕
            [55090] = 4,    -- 天灾打击
            [207317] = 5,   -- 扩散
            [77575] = 6,    -- 爆发
            [85948] = 7,    -- 脓疮打击
            [1247378] = 8,  -- 腐化
            [1233448] = 10, -- 黑暗突变
            [343294] = 11,  -- 灵魂收割
        }
    end
end

fu.updateSpecInfo()
