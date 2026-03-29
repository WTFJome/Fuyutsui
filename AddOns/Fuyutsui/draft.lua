local _, fu = ...

fu.auras = {
    -- SPELL_UPDATE_COOLDOWN
    -- 获取光环的事件, 返回参数: 光环ID
    bySpellCooldown = {
        ["光环ID"] = {
            name = "光环名称",
            remaining = 0,        -- 剩余时间, 一般为0
            duration = 60,        -- 光环的持续时间
            expirationTime = nil, -- 光环的结束时间
            count = 0,            -- 可选, 光环的层数
            countMin = 0,         -- 可选, 光环的最小层数
            countMax = 2,         -- 可选, 光环的最大层数
            countStep = 1,        -- 可选, 光环的层数步长
        },
    },
    -- COOLDOWN_VIEWER_SPELL_OVERRIDE_UPDATED
    -- 法术覆盖事件, 返回参数: 基本法术ID, 覆盖法术ID
    bySpellOverride = {
        ["基本法术ID"] = {
            name = "技能名称",
            auraID = "光环ID",
            spellId = "基本法术ID",
            overrideSpellID = "覆盖法术ID"
        },
    },
    -- SPELL_ACTIVATION_OVERLAY_SHOW
    -- SPELL_ACTIVATION_OVERLAY_HIDE
    -- 法术发光事件, 返回参数: 法术ID
    byOverlay = {
        ["法术ID"] = {
            name = "光环名称",
            auraID = "光环ID"
        },
    },
    -- SPELL_ACTIVATION_OVERLAY_SHOW
    -- SPELL_ACTIVATION_OVERLAY_HIDE
    -- 屏幕提示事件, 返回参数: 法术ID
    byActivationOverlay = {
        ["法术ID"] = {
            name = "光环名称",
            auraID = "光环ID"
        },
    },
    -- UNIT_SPELLCAST_SUCCEEDED
    -- 法术成功事件, 返回参数: 法术ID
    -- 注意: 每个法术ID可以对应多个光环, 所以需要放入一个table中
    bySuccess = {

        ["法术ID"] = {
            {
                name = "技能名称1",
                auraID = "光环ID1",
                step = -1 -- 可选, 光环的步长
            },
            {
                name = "技能名称2",
                auraID = "光环ID2",

            },
        },

    },
    -- 法术图标事件"SPELL_UPDATE_ICON",
    -- 返回参数: 法术ID
    byIcon = {
        ["法术ID"] = {
            name = "光环名称",
            auraID = "光环ID", -- 可选, 光环ID,
            spellId = "法术ID",
            overrideSpellID = "覆盖法术ID",
            isIcon = 1, -- 可选, 如果不为nil, 那么将使用isIcon的值作为光环的层数
        },
    }
}
