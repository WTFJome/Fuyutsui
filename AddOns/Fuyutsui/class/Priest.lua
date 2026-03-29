local _, fu = ...
if fu.classId ~= 5 then return end
local creat = fu.updateOrCreatTextureByIndex

fu.HarmfulSpellId, fu.HelpfulSpellId = 585, 2061

fu.heroSpell = {
    [1248423] = 1, -- 神谕者
    [263165] = 2,  -- 虚空编织者
    [447444] = 2,  -- 虚空编织者
    [120517] = 3,  -- 执政官
    [102644] = 3,  -- 执政官
}

function fu.updateSpecInfo()
    local specIndex = C_SpecializationInfo.GetSpecialization()
    fu.powerType = nil
    fu.blocks = nil
    fu.group_blocks = nil
    fu.assistant_spells = nil
    if specIndex == 1 then
        fu.powerType = "MANA"
        fu.auras = {
            bySpellCooldown = {
                [1253591] = {
                    name = "虚空之盾",
                    remaining = 0,
                    duration = 60,
                    expirationTime = nil,
                },
                [114255] = {
                    name = "圣光涌动",
                    remaining = 0,
                    duration = 20,
                    count = 0,
                    countMin = 0,
                    countMax = 2,
                    countStep = 1,
                    expirationTime = nil,
                },
                [450215] = {
                    name = "熵能裂隙",
                    remaining = 0,
                    duration = 12,
                    expirationTime = nil,
                },
                [186263] = {
                    name = "暗影愈合",
                    remaining = 0,
                    duration = 15,
                    expirationTime = nil,
                },
                [472433] = {
                    name = "福音",
                    remaining = 0,
                    duration = 120,
                    count = 0,
                    countMin = 0,
                    countMax = 2,
                    countStep = 1,
                    expirationTime = nil,
                },
            },
            bySpellOverride = {
                [17] = {
                    name = "虚空之盾",
                    auraID = 1253591,
                    spellId = 17,
                    overrideSpellID = 1253593
                },
                [585] = {
                    name = "惩击",
                    auraID = 450215,
                    spellId = 585,
                    overrideSpellID = 450215
                },
                [2061] = {
                    name = "暗影愈合",
                    auraID = 186263,
                    spellId = 2061,
                    overrideSpellID = 186263
                },
            },
            byActivationOverlay = {
                [114255] = {
                    name = "圣光涌动",
                    auraID = 114255
                },
            },
            bySuccess = {
                [194509] = { { name = "真言术：耀", auraName = "福音", auraID = 472433, step = -1 } },
                [2061] = { { name = "圣光涌动", auraID = 114255, step = -1 } },
            },
            byIcon = {
                [1253591] = {
                    name = "虚空之盾",
                    auraID = 1253591,
                    spellId = 17,
                    overrideSpellID = 1253593,
                },
                [186263] = {
                    name = "暗影愈合",
                    auraID = 186263,
                    spellId = 2061,
                    overrideSpellID = 186263,
                },
            },
        }
        fu.blocks = {
            assistant = 11,
            target_valid = 12,
            group_type = 13,
            members_count = 14,
            hero_talent = 15,
            encounterID = 16,
            difficultyID = 17,
            failedSpell = 18,
            auras = {
                ["虚空之盾"] = {
                    index = 19,
                    auraRef = fu.auras.bySpellCooldown[1253591],
                    showKey = "remaining",
                },
                ["圣光涌动"] = {
                    index = 20,
                    auraRef = fu.auras.bySpellCooldown[114255],
                    showKey = "remaining",
                },
                ["熵能裂隙"] = {
                    index = 21,
                    auraRef = fu.auras.bySpellCooldown[450215],
                    showKey = "remaining",
                },
                ["暗影愈合"] = {
                    index = 22,
                    auraRef = fu.auras.bySpellCooldown[186263],
                    showKey = "remaining",
                },
                ["福音"] = {
                    index = 23,
                    auraRef = fu.auras.bySpellCooldown[472433],
                    showKey = "remaining",
                },
            },
            spell_cd = {
                [17] = { index = 23, spellId = 17, name = "真言术：盾" },
                [47540] = { index = 24, spellId = 47540, name = "苦修" },
                [194509] = { index = 25, spellId = 194509, name = "真言术：耀" },
                [527] = { index = 26, spellId = 527, name = "纯净术" },
                [19236] = { index = 27, spellId = 19236, name = "绝望祷言" },
                [8092] = { index = 28, spellId = 8092, name = "心灵震爆" },
                [472433] = { index = 29, spellId = 472433, name = "福音" },
                [32379] = { index = 30, spellId = 32379, name = "暗言术：灭" },
                [232633] = { index = 31, spellId = 232633, name = "奥术洪流" },
                [8122] = { index = 32, spellId = 8122, name = "心灵尖啸", failed = true },
                [32375] = { index = 33, spellId = 32375, name = "群体驱散", failed = true },
                [62618] = { index = 34, spellId = 62618, name = "真言术：障", failed = true },
                [421453] = { index = 35, spellId = 421453, name = "终极苦修", failed = true },
            },
            spell_charge = {
                [47540] = { index = 36, spellId = 47540, name = "苦修" }
            },
        }
        fu.group_blocks = {
            unit_start = 40,
            block_num = 5,
            healthPercent = 1,
            role = 2,
            dispel = 3,
            aura = { [4] = { 194384 }, [5] = { 17, 1253593 }, },
        }
        fu.assistant_spells = {
            [8092] = 1,  -- 心灵震爆
            [585] = 2,   -- 惩击
            [32379] = 3, -- 暗言术：灭
            [589] = 4,   -- 暗言术：痛
            [21562] = 5, -- 真言术：韧
            [47540] = 6, -- 苦修
        }
    elseif specIndex == 2 then
        fu.powerType = "MANA"
        fu.auras = {
            bySpellCooldown = {
                [114255] = {
                    name = "圣光涌动",
                    remaining = 0,
                    duration = 20,
                    count = 0,
                    countMin = 0,
                    countMax = 2,
                    countStep = 1,
                    expirationTime = nil,
                },
                [390993] = {
                    name = "织光者",
                    remaining = 0,
                    duration = 20,
                    count = 0,
                    countMin = 0,
                    countMax = 4,
                    countStep = 1,
                    expirationTime = nil,
                },
                [1262766] = {
                    name = "祈福",
                    remaining = 0,
                    duration = 32,
                    expirationTime = nil,
                },
            },
            byActivationOverlay = {
                [114255] = { name = "圣光涌动", auraID = 114255 },
            },
            bySpellOverride = {
                [2061] = {
                    name = "祈福",
                    auraID = 1262766,
                    spellId = 2061,
                    overrideSpellID = 1262763
                },
            },
            bySuccess = {
                [194509] = { { name = "真言术：耀", auraName = "福音", auraID = 472433, step = -1 } },
                [596] = { { name = "织光者", auraID = 390993, step = -1 } },
            },
        }
        fu.blocks = {
            assistant = 11,
            target_valid = 12,
            group_type = 13,
            members_count = 14,
            hero_talent = 15,
            encounterID = 16,
            difficultyID = 17,
            failedSpell = 18,
            castingSpell = 36,
            auras = {
                ["织光者"] = {
                    index = 19,
                    auraRef = fu.auras.bySpellCooldown[390993],
                    showKey = "remaining",
                },
                ["织光者层数"] = {
                    index = 20,
                    auraRef = fu.auras.bySpellCooldown[390993],
                    showKey = "count",
                },
                ["圣光涌动"] = {
                    index = 21,
                    auraRef = fu.auras.bySpellCooldown[114255],
                    showKey = "remaining",
                },

                ["祈福"] = {
                    index = 22,
                    auraRef = fu.auras.bySpellCooldown[1262766],
                    showKey = "remaining",
                },
            },
            spell_cd = {
                [33076] = { index = 23, name = "愈合祷言", isSpellKnown = false },
                [2050] = { index = 24, name = "圣言术：静", isSpellKnown = false },
                [88625] = { index = 26, name = "圣言术：罚", isSpellKnown = false },
                [527] = { index = 27, name = "纯净术", isSpellKnown = false },
                [19236] = { index = 28, name = "绝望祷言", isSpellKnown = false },
                [200183] = { index = 29, name = "神圣化身", isSpellKnown = false, failed = true },
                [120517] = { index = 30, name = "光晕", isSpellKnown = false, failed = true },
                [64843] = { index = 31, name = "神圣赞美诗", isSpellKnown = false, failed = true },
                [14914] = { index = 32, name = "神圣之火", isSpellKnown = false },
                [8122] = { index = 33, name = "心灵尖啸", isSpellKnown = false, failed = true },
                [32375] = { index = 34, name = "群体驱散", isSpellKnown = false, failed = true },
                [232633] = { index = 35, name = "奥术洪流", isSpellKnown = false },
            },
            spell_charge = {
                [2050] = { index = 25, name = "圣言术：静" }
            },
        }
        fu.group_blocks = {
            unit_start = 40,
            block_num = 5,
            healthPercent = 1,
            role = 2,
            dispel = 3,
            aura = { [4] = { 41635 }, [5] = { 139 }, },
        }
        fu.assistant_spells = {
            [88625] = 1,  -- 圣言术：罚
            [585] = 2,    -- 惩击
            [14914] = 3,  -- 神圣之火
            [132157] = 4, -- 神圣新星
            [21562] = 5,  -- 真言术：韧
        }
    elseif specIndex == 3 then
        fu.powerType = "INSANITY"
        fu.blocks = {
            assistant = 11,
            target_valid = 12,
            failedSpell = 13,
            hero_talent = 14,
            encounterID = 15,
            difficultyID = 16,
            spell_cd = {
                [8092] = { index = 31, name = "心灵震爆" },
                [32379] = { index = 32, name = "暗言术：灭" },
                [263165] = { index = 33, name = "虚空洪流" },
                [228260] = { index = 34, name = "虚空形态", failed = true },
                [1227280] = { index = 35, name = "触须猛击" },
                [19236] = { index = 36, name = "绝望祷言" },
                [8122] = { index = 37, name = "心灵尖啸", failed = true },
                [32375] = { index = 38, name = "群体驱散", failed = true },
                [15286] = { index = 39, name = "吸血鬼的拥抱", failed = true },
                [120644] = { index = 40, name = "光晕" },
            },
        }
        fu.assistant_spells = {
            [34914] = 1,    -- 吸血鬼之触
            [8092] = 2,     -- 心灵震爆
            [232698] = 3,   -- 暗影形态
            [32379] = 4,    -- 暗言术：灭
            [589] = 5,      -- 暗言术：痛
            [335467] = 6,   -- 暗言术：癫
            [21562] = 7,    -- 真言术：韧
            [15407] = 8,    -- 精神鞭笞
            [228260] = 9,   -- 虚空形态
            [263165] = 10,  -- 虚空洪流
            [1227280] = 11, -- 触须猛击
            [450983] = 12,  -- 虚空冲击
            [1242173] = 13, -- 虚空齐射
            [391403] = 14,  -- 精神鞭笞：狂
            [120644] = 15,  -- 光晕
        }
    end
end

function fu.CreateClassMacro()
    local dynamicSpells = { "苦修", "快速治疗", "真言术：盾", "愈合祷言", "纯净术", "圣言术：静" }
    local staticSpells = {
        [1] = "心灵震爆",
        [2] = "惩击",
        [3] = "暗言术：痛",
        [4] = "真言术：韧",
        [5] = "神圣新星",
        [6] = "苦修",
        [7] = "真言术：耀",
        [8] = "福音",
        [9] = "终极苦修",
        [10] = "绝望祷言",
        [11] = "暗言术：灭",
        [12] = "吸血鬼之触",
        [13] = "[nostance:1]暗影形态",
        [14] = "暗言术：癫",
        [15] = "精神鞭笞",
        [16] = "虚空形态",
        [17] = "虚空洪流",
        [18] = "触须猛击",
        [19] = "虚空冲击",
        [20] = "虚空齐射",
        [21] = "圣言术：罚",
        [22] = "神圣之火",
        [23] = "治疗祷言",
        [24] = "神圣化身",
        [25] = "奥术洪流",
        [26] = "心灵尖啸",
        [27] = "[@cursor]群体驱散",
        [28] = "[@cursor]真言术：障",
        [29] = "神圣赞美诗",
        [30] = "光晕",
    }

    fu.CreateMacro(dynamicSpells, staticSpells)
end
