local _, fu = ...
if fu.classId ~= 11 then return end

local creat = fu.updateOrCreatTextureByIndex

fu.HelpfulSpellId = 774
fu.HarmfulSpellId = 5176
fu.HarmfulRemoteSpellId = 5176
fu.HarmfulMeleeSpellId = 1822

-- 创建德鲁伊宏
function fu.CreateClassMacro()
    local dynamicSpells = { "回春术", "愈合", "生命绽放", "迅捷治愈", "自然之愈" }
    local specialSpells = { [17] = "/cancelaura [spec:4]猎豹形态\n/cast 万灵之召", }
    local staticSpells = {
        [1] = "[nostance:2]猎豹形态(变形)",
        [2] = "[nostance:1]熊形态(变形)",
        [3] = "[nostance:4]枭兽形态",
        [4] = "月火术",
        [5] = "树皮术",
        [6] = "横扫",
        [7] = "潜行",
        [8] = "凶猛撕咬",
        [9] = "愤怒",
        [10] = "割裂",
        [11] = "撕碎",
        [12] = "斜掠",
        [13] = "痛击",
        [14] = "野性印记",
        [15] = "裂伤",
        [16] = "野性成长",
        [18] = "自然迅捷",
        [19] = "[@player]激活",
        [20] = "野性之心",
        [21] = "野性冲锋",
        [22] = "铁鬃",
        [23] = "摧折",
        [24] = "明月普照",
        [25] = "狂暴回复",
    }
    fu.CreateMacro(dynamicSpells, staticSpells, specialSpells)
end

-- 更新法术成功效果
function fu.updateSpellSuccess(spellID)
    if not fu.blocks or not fu.blocks.auras then return end
    local currentTime = GetTime()
    if spellID == 18562 then -- 获得 丛林之魂
        fu.blocks.auras.forestSoul.expirationTime = currentTime + fu.blocks.auras.forestSoul.duration
        C_Timer.After(15, function()
            fu.blocks.auras.forestSoul.expirationTime = nil
        end)
    elseif spellID == 8936 then -- 消耗 丛林之魂 和 节能施法
        fu.blocks.auras.forestSoul.expirationTime = nil
        local isSpellOverlayed = C_SpellActivationOverlay.IsSpellOverlayed(spellID)
        if not isSpellOverlayed then
            fu.blocks.auras.clearcasting.expirationTime = nil
        end
    elseif spellID == 774 then    -- 消耗 丛林之魂
        fu.blocks.auras.forestSoul.expirationTime = nil
    elseif spellID == 192081 then -- 铁鬃
        fu.blocks.auras.ironfur.expirationTime = currentTime + fu.blocks.auras.ironfur.duration
    elseif spellID == 22842 then  -- 狂暴回复, 消耗节能施法
        fu.blocks.auras.frenzied.expirationTime = currentTime + fu.blocks.auras.frenzied.duration
        local isSpellOverlayed = C_SpellActivationOverlay.IsSpellOverlayed(spellID)
        if not isSpellOverlayed then fu.blocks.auras.clearcasting.expirationTime = nil end
    end
end

-- 更新法术发光效果
function fu.updateSpellOverlay(spellId)
    if spellId == 8936 then
        local isSpellOverlayed = C_SpellActivationOverlay.IsSpellOverlayed(spellId)
        if isSpellOverlayed then
            fu.blocks.auras.clearcasting.expirationTime = GetTime() + fu.blocks.auras.clearcasting.duration
        else
            fu.blocks.auras.clearcasting.expirationTime = nil
        end
    end
end

function fu.updateOnUpdate()
    if not fu.blocks or not fu.blocks.auras then return end
    for _, aura in pairs(fu.blocks.auras) do
        if aura.expirationTime then
            aura.remaining = math.floor(aura.expirationTime - GetTime() + 0.5)
            if aura.remaining > 0 then
                creat(aura.index, aura.remaining / 255)
            else
                aura.expirationTime = nil
                creat(aura.index, 0)
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
    if not fu.group_blocks.rejuv then return end
    for unit, data in pairs(fu.group) do
        local has_rejuv_count = 0
        local index = fu.group_blocks.unit_start + data.index * fu.group_blocks.block_num + fu.group_blocks.rejuv
        local rejuv_aura = C_UnitAuras.GetUnitAuraBySpellID(unit, 774)
        local rejuv2_aura = C_UnitAuras.GetUnitAuraBySpellID(unit, 155777)
        if rejuv_aura and rejuv_aura.sourceUnit == "player" then
            has_rejuv_count = has_rejuv_count + 1
        end
        if rejuv2_aura and rejuv2_aura.sourceUnit == "player" then
            has_rejuv_count = has_rejuv_count + 1
        end
        creat(index, has_rejuv_count / 255)
    end
end

function fu.updateSpecInfo()
    local specIndex = C_SpecializationInfo.GetSpecialization()
    fu.powerType = nil
    fu.blocks = nil
    fu.group_blocks = nil
    fu.assistant_spells = nil
    if specIndex == 3 then
        fu.powerType = "RAGE"
        fu.blocks = {
            assistant = 11,
            target_valid = 12,
            target_health = 13,
            enemy_count = 14,
            stance = 15,
            failedSpell = 16,
            auras = {
                clearcasting = {
                    name = "节能施法",
                    index = 17,
                    remaining = 0,
                    duration = 30,
                    expirationTime = nil,
                },
                ironfur = {
                    name = "铁鬃",
                    index = 18,
                    remaining = 0,
                    duration = 7,
                    expirationTime = nil,
                },
                frenzied = {
                    name = "狂暴回复",
                    index = 19,
                    remaining = 0,
                    duration = 4,
                    expirationTime = nil,
                },
            },
            spell_cd = {
                [22812] = { index = 31, spellId = 22812, name = "树皮术" },
                [61336] = { index = 32, spellId = 61336, name = "生存本能" },
                [22842] = { index = 33, spellId = 22842, name = "狂暴回复" },
                [132469] = { index = 34, spellId = 132469, name = "台风", failed = true },
                [99] = { index = 35, spellId = 99, name = "夺魂咆哮", failed = true },
                [102558] = { index = 36, spellId = 102558, name = "化身：乌索克的守护者" },
                [132158] = { index = 37, spellId = 132158, name = "自然迅捷" },
                [29166] = { index = 38, spellId = 29166, name = "激活" },
                [1261867] = { index = 39, spellId = 1261867, name = "野性之心" },
                [102793] = { index = 40, spellId = 102793, name = "乌索克旋风", failed = true },
            },
            spell_charge = {
                [22842] = { index = 41, spellId = 22842, name = "狂暴回复" },
            },
        }
        fu.group_show = false
        fu.assistant_spells = {
            [400254] = 1, -- 摧折
            [204066] = 2, -- 明月普照
            [8921] = 3,   -- 月火术
            [213771] = 4, -- 横扫
            [5487] = 5,   -- 熊形态
            [77758] = 6,  -- 痛击
            [33917] = 7,  -- 裂伤
            [1126] = 8,   -- 野性印记
        }
    elseif specIndex == 4 then
        print("载入治疗专精")
        fu.powerType = "MANA"
        fu.blocks = {
            assistant = 11,
            target_valid = 12,
            group_type = 13,
            stance = 14,
            target_maxRange = 15,
            members_count = 16,
            comboPoints = 17,
            auras = {
                clearcasting = {
                    name = "节能施法",
                    index = 18,
                    remaining = 0,
                    duration = 15,
                    expirationTime = nil,
                },
                forestSoul = {
                    name = "丛林之魂",
                    index = 19,
                    remaining = 0,
                    duration = 15,
                    expirationTime = nil,
                },
            },
            spell_cd = {
                [22812] = { index = 21, spellId = 22812, name = "树皮术" },
                [48438] = { index = 22, spellId = 48438, name = "野性成长" },
                [391528] = { index = 23, spellId = 391528, name = "万灵之召" },
                [18562] = { index = 24, spellId = 18562, name = "迅捷治愈" },
                [88423] = { index = 25, spellId = 88423, name = "自然之愈" },
                [102342] = { index = 26, spellId = 102342, name = "铁木树皮" },
                [132158] = { index = 27, spellId = 132158, name = "自然迅捷" },
                [29166] = { index = 28, spellId = 29166, name = "激活" },
                [1261867] = { index = 29, spellId = 1261867, name = "野性之心" },
                [132469] = { index = 30, spellId = 132469, name = "台风", failed = true },
                [99] = { index = 31, spellId = 99, name = "夺魂咆哮", failed = true },
                [102793] = { index = 32, spellId = 102793, name = "乌索克旋风", failed = true },
            },
            spell_charge = {
                [18562] = { index = 33, spellId = 18562, name = "迅捷治愈" },
            },
        }
        fu.group_blocks = {
            unit_start = 40,
            block_num = 7,
            healthPercent = 1,
            role = 2,
            dispel = 3,
            aura = {
                [4] = { 33763 },                    -- 生命绽放
                [5] = { 48438, 8936, 774, 155777 }, -- 迅捷治愈(回春术, 萌芽, 愈合, 野性生长)
                [6] = { 8936 },                     -- 愈合
            },
            rejuv = 7,                              -- 回春术数量
        }
        fu.assistant_spells = {
            [22568] = 1, -- 凶猛撕咬
            [1079] = 2,  -- 割裂
            [5221] = 3,  -- 撕碎
            [1822] = 4,  -- 斜掠
            [8921] = 5,  -- 月火术
            [5176] = 6,  -- 愤怒
            [1126] = 7,  -- 野性印记
        }
    end
end

fu.updateSpecInfo()
