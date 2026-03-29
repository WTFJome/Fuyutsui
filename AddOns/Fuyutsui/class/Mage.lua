local _, fu = ...
if fu.classId ~= 8 then return end
local creat = fu.updateOrCreatTextureByIndex

fu.HarmfulSpellId = 116 -- 寒冰箭

fu.auras = {
    bySpellCooldown = {
        [1247730] = {
            name = "热能真空",
            remaining = 0,
            duration = 12,
            expirationTime = nil,
        },
        [1222865] = {
            name = "冰川尖刺！",
            remaining = 0,
            duration = nil,
            expirationTime = nil,
        },
        [190446] = {
            name = "冰冷智慧",
            remaining = 0,
            duration = 20,
            expirationTime = nil,
        },
        [270232] = {
            name = "冰冻之雨",
            remaining = 0,
            duration = 12,
            expirationTime = nil,
        },
        [44544] = {
            name = "寒冰指",
            remaining = 0,
            duration = 30,
            count = 0,
            countMin = 0,
            countMax = 2,
            countStep = 1,
            expirationTime = nil,
        },
    },
    bySuccess = {
        -- 冰枪术
        [30455] = {
            { name = "寒冰指", auraID = 44544, step = -1 },
            { name = "热能真空", auraID = 1247730 },
        },
        -- 冰风暴
        [44614] = {
            { name = "冰冷智慧", auraID = 190446 },
        },
    },
    byIcon = {
        [116] = {
            name = "冰川尖刺！",
            auraID = 1222865,
            spellId = 116,
            overrideSpellID = 199786,
        },
    },
}

fu.heroSpell = {
    [443739] = 1, -- 疾咒师
    [448601] = 2, -- 日怒
    [431044] = 3, -- 霜火
}

function fu.updateSpecInfo()
    local specIndex = C_SpecializationInfo.GetSpecialization()
    fu.powerType = nil
    fu.blocks = nil
    fu.group_blocks = nil
    fu.assistant_spells = nil
    if specIndex == 1 then
        fu.powerType = "MANA"
        fu.blocks = {
            holyPower = 11,
            target_valid = 12,
            group_type = 13,
            members_count = 14,
            encounterID = 15,
            difficultyID = 16,
            failedSpell = 17,
            auras = {
                [223819] = {
                    name = "神圣意志",
                    index = 18,
                    remaining = 0,
                    duration = 12,
                    expirationTime = nil,
                },
                [54149] = {
                    name = "圣光灌注",
                    index = 19,
                    remaining = 0,
                    duration = 15,
                    expirationTime = nil,
                },
                [414273] = {
                    name = "神性之手",
                    index = 20,
                    remaining = 0,
                    duration = 19.5,
                    applications = 0,
                    expirationTime = nil,
                },
            },
            spell_cd = {
                [20473] = { index = 21, spellId = 20473, name = "神圣震击" },
                [4987] = { index = 22, spellId = 4987, name = "清洁术" },
                [115750] = { index = 23, spellId = 115750, name = "盲目之光", failed = true },
                [275773] = { index = 24, spellId = 275773, name = "审判" },
                [375576] = { index = 25, spellId = 375576, name = "圣洁鸣钟" },
                [114165] = { index = 26, spellId = 114165, name = "神圣棱镜" },
                [31821] = { index = 27, spellId = 31821, name = "光环掌握", failed = true },
                [6940] = { index = 28, spellId = 6940, name = "牺牲祝福" },
                [1044] = { index = 29, spellId = 1044, name = "自由祝福", failed = true },
                [853] = { index = 30, spellId = 853, name = "制裁之锤", failed = true },
                [1022] = { index = 31, spellId = 1022, name = "保护祝福", failed = true },
                [633] = { index = 32, spellId = 633, name = "圣疗术" },
            },
            spell_charge = {
                [20473] = { index = 32, spellId = 20473, name = "神圣震击" },
            },
        }
        fu.group_blocks = {
            unit_start = 40,
            block_num = 6,
            healthPercent = 1,
            role = 2,
            dispel = 3,
            aura = {
                [4] = { 156322 },        -- 永恒之火
                [5] = { 1244893 },       -- 救世道标
                [6] = { 53563, 156910 }, -- 圣光道标, 信仰道标
            },
        }
        fu.assistant_spells = {
        }
    elseif specIndex == 2 then
        fu.HarmfulSpellId = 275779
        fu.powerType = "MANA"
        fu.blocks = {
            holyPower = 11,
            target_valid = 12,
            assistant = 13,
            failedSpell = 14,
            holyBulwark = 15,
            auras = {
                [223819] = {
                    name = "神圣意志",
                    index = 16,
                    remaining = 0,
                    duration = 12,
                    expirationTime = nil,
                },
                [432496] = {
                    name = "神圣壁垒",
                    index = 17,
                    remaining = 0,
                    duration = 20,
                    expirationTime = nil,
                },
                [432502] = {
                    name = "圣洁武器",
                    index = 18,
                    remaining = 0,
                    duration = 20,
                    expirationTime = nil,
                },
                [327510] = {
                    name = "闪耀之光",
                    index = 19,
                    remaining = 0,
                    duration = 30,
                    expirationTime = nil,
                },
            },
            spell_cd = {
                [213644] = { index = 21, spellId = 213644, name = "清毒术" },
                [115750] = { index = 22, spellId = 115750, name = "盲目之光", failed = true },
                [275779] = { index = 23, spellId = 275779, name = "审判" },
                [375576] = { index = 24, spellId = 375576, name = "圣洁鸣钟" },
                [6940] = { index = 25, spellId = 6940, name = "牺牲祝福" },
                [1044] = { index = 26, spellId = 1044, name = "自由祝福", failed = true },
                [853] = { index = 27, spellId = 853, name = "制裁之锤", failed = true },
                [1022] = { index = 28, spellId = 1022, name = "保护祝福", failed = true },
                [432459] = { index = 29, spellId = 432459, name = "神圣壁垒" },
                [31935] = { index = 31, spellId = 31935, name = "复仇者之盾" },
                [26573] = { index = 32, spellId = 26573, name = "奉献" },
                [53600] = { index = 33, spellId = 53600, name = "正义盾击" },
                [204019] = { index = 34, spellId = 204019, name = "祝福之锤" },
            },
            spell_charge = {
                [432459] = { index = 30, spellId = 432459, name = "神圣壁垒" },
            },
        }
        fu.assistant_spells = {
            [375576] = 1, -- 圣洁鸣钟
            [31935] = 2,  -- 复仇者之盾
            [26573] = 3,  -- 奉献
            [275779] = 4, -- 审判
            [53600] = 5,  -- 正义盾击
            [204019] = 6, -- 祝福之锤
        }
    elseif specIndex == 3 then
        fu.powerType = "MANA"
        fu.auras = {
            bySpellCooldown = {
                [1247730] = {
                    name = "热能真空",
                    remaining = 0,
                    duration = 12,
                    expirationTime = nil,
                },
                [190446] = {
                    name = "冰冷智慧",
                    remaining = 0,
                    duration = 20,
                    expirationTime = nil,
                },
                [270232] = {
                    name = "冰冻之雨",
                    remaining = 0,
                    duration = 12,
                    expirationTime = nil,
                },
                [44544] = {
                    name = "寒冰指",
                    remaining = 0,
                    duration = 30,
                    count = 0,
                    countMin = 0,
                    countMax = 2,
                    countStep = 1,
                    expirationTime = nil,
                },
            },
            bySuccess = {
                -- 冰枪术
                [30455] = {
                    { name = "寒冰指", auraID = 44544, step = -1 },
                    { name = "热能真空", auraID = 1247730 },
                },
                -- 冰风暴
                [44614] = {
                    { name = "冰冷智慧", auraID = 190446 },
                },
            },
            byIcon = {
                [116] = {
                    name = "冰川尖刺！",
                    auraID = nil,
                    spellId = 116,
                    overrideSpellID = 199786,
                    isIcon = 1,
                },
            },
        }

        fu.blocks = {
            assistant = 11,
            target_valid = 12,
            failedSpell = 13,
            hero_talent = 14,
            encounterID = 15,
            difficultyID = 16,
            castingSpell = 17,
            enemy_count = 24,
            auras = {
                ["热能真空"] = {
                    name = "热能真空",
                    index = 18,
                    auraRef = fu.auras.bySpellCooldown[1247730],
                    showKey = "remaining",
                },
                ["冰川尖刺！"] = {
                    index = 19,
                    auraRef = fu.auras.byIcon[116],
                    showKey = "isIcon",
                    name = "冰川尖刺！",
                },
                ["冰冷智慧"] = {
                    index = 20,
                    auraRef = fu.auras.bySpellCooldown[190446],
                    showKey = "remaining",
                    name = "冰冷智慧",
                },
                ["冰冻之雨"] = {
                    index = 21,
                    auraRef = fu.auras.bySpellCooldown[270232],
                    showKey = "remaining",
                    name = "冰冻之雨",
                },
                ["寒冰指"] = {
                    index = 22,
                    auraRef = fu.auras.bySpellCooldown[44544],
                    showKey = "remaining",
                    name = "寒冰指",
                },
                ["寒冰指层数"] = {
                    index = 23,
                    auraRef = fu.auras.bySpellCooldown[44544],
                    showKey = "count",
                    name = "寒冰指层数",
                },
            },
            spell_cd = {
                [475] = { index = 31, name = "解除诅咒" },
                [110959] = { index = 32, name = "强化隐形术", failed = true },
                [122] = { index = 33, name = "冰霜新星", failed = true },
                [2139] = { index = 34, name = "法术反制" },
                [31661] = { index = 35, name = "龙息术", failed = true },
                [1248829] = { index = 36, name = "暴风雪", failed = true },
                [190356] = { index = 37, name = "暴风雪", failed = true },
                [84714] = { index = 38, name = "寒冰宝珠" },
                [205021] = { index = 39, name = "冰霜射线" },
                [11426] = { index = 40, name = "寒冰护体" },
                [44614] = { index = 41, name = "冰风暴" },
            },
            spell_charge = {
                [44614] = { index = 42, name = "冰风暴" },
            },
        }
        fu.assistant_spells = {
            [116] = 1,    -- 寒冰箭
            [199786] = 2, -- 冰川尖刺
            [30455] = 3,  -- 冰枪术
            [205021] = 4, -- 冰霜射线
            [44614] = 5,  -- 冰风暴
            [1459] = 6,   -- 奥术智慧
            [84714] = 7,  -- 寒冰宝珠
        }
    end
end

function fu.CreateClassMacro()
    local dynamicSpells = { "解除诅咒" }
    local specialSpells = {}
    local staticSpells = {
        [1] = "寒冰箭",
        [2] = "强化隐形术",
        [3] = "冰霜新星",
        [4] = "法术反制",
        [5] = "变形术",
        [6] = "奥术智慧",
        [7] = "法术吸取",
        [8] = "冰枪术",
        [9] = "寒冰宝珠",
        [10] = "冰霜射线",
        [11] = "冰风暴",
        [12] = "寒冰护体",
        [13] = "暴风雪",
        [14] = "龙息术",
    }
    fu.CreateMacro(dynamicSpells, staticSpells, specialSpells)
end
