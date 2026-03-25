# -*- coding: utf-8 -*-
"""牧师职业的逻辑决策（戒律 / 暗影）。"""

from utils import *

def run_priest_logic(state_dict, spec_name):
    spells = state_dict.get("spells") or {}
    health = state_dict.get("生命值")
    power = state_dict.get("能量值")
    assistant = state_dict.get("一键辅助")
    target_valid = state_dict.get("目标有效")
    combat = state_dict.get("战斗")
    casting = state_dict.get("施法")
    channeling = state_dict.get("引导")
    moving = state_dict.get("移动")
    group_type = state_dict.get("队伍类型", 0)
    # 默认返回：无操作
    action_hotkey = None
    current_step = "无匹配技能"
    unit_info = {}

    if spec_name == "戒律":
        evangelism_cd = spells.get("福音", -1)
        radiance_cd = spells.get("真言术：耀", -1)
        shield_cd = spells.get("真言术：盾", -1)
        penance_cd = spells.get("苦修", -1)
        shadow_death_cd = spells.get("暗言术：灭", -1)
        mind_blast_cd = spells.get("心灵震爆", -1)
        entropic_rift_cd = state_dict.get("熵能裂隙", 0)
        surge_of_light = state_dict.get("圣光涌动", 0)
        void_shield = state_dict.get("虚空之盾", -1)

        dispel_unit, _ = get_unit_with_dispel_type(state_dict, 1)
        lowest_u, lowest_p = get_lowest_health_unit(state_dict, 100)
        no_ato_u, no_ato_p = get_lowest_health_unit_without_aura(state_dict, "救赎", 100)
        no_shd_lowest_u, no_shd_lowest_p = get_lowest_health_unit_without_aura(state_dict, "真言术：盾", 100)
        no_shd_u, no_shd_p = get_lowest_health_unit_without_aura(state_dict, "真言术：盾", 101)
        no_ato_count_90 = count_units_without_aura_below_health(state_dict, "救赎", 90)
        atonement_count = count_units_with_aura(state_dict, "救赎")

        unit_info = {
            "dispel_unit": dispel_unit,
            "lowest_unit": lowest_u,
            "lowest_unit_pct": lowest_p,
            "no_atonement_unit": no_ato_u,
            "no_atonement_pct": no_ato_p,
            "no_shield_lowest_unit": no_shd_lowest_u,
            "no_shield_lowest_pct": no_shd_lowest_p,
            "no_shield_unit": no_shd_u,
            "no_shield_pct": no_shd_p,
            "no_atonement_count_90": no_ato_count_90,
            "atonement_count": atonement_count,
        }

        if channeling > 0:
            current_step = "引导,不执行任何操作"
        elif spells.get("绝望祷言") == 0 and health < 50:
            current_step = "施放 绝望祷言"
            action_hotkey = get_hotkey(0, "绝望祷言")
        elif spells.get("纯净术") == 0 and dispel_unit is not None:
            current_step = f"施放 纯净术 on {dispel_unit}"
            action_hotkey = get_hotkey(int(dispel_unit), "纯净术")
        elif spells.get("奥术洪流") == 0 and power <= 90:
            current_step = "施放 奥术洪流"
            action_hotkey = get_hotkey(0, "奥术洪流")
        elif assistant == 5:
            current_step = "施放 真言术：韧"
            action_hotkey = get_hotkey(0, "真言术：韧")
        elif spells.get("心灵尖啸") < 1 and state_dict.get("法术失败") == 32:
            current_step = "施放 心灵尖啸"
            action_hotkey = get_hotkey(0, "心灵尖啸")
        elif spells.get("群体驱散") < 1 and state_dict.get("法术失败") == 33:
            current_step = "施放 群体驱散"
            action_hotkey = get_hotkey(0, "群体驱散")
        elif spells.get("真言术：障") < 1 and state_dict.get("法术失败") == 34:
            current_step = "施放 真言术：障"
            action_hotkey = get_hotkey(0, "真言术：障")
        elif spells.get("终极苦修") < 1 and state_dict.get("法术失败") == 35:
            current_step = "施放 终极苦修"
            action_hotkey = get_hotkey(0, "终极苦修")
        elif state_dict.get("英雄天赋") == 1:
            if evangelism_cd == 0 and no_ato_count_90 >= 4:
                current_step = "施放 福音"
                action_hotkey = get_hotkey(0, "福音")
            elif radiance_cd == 0 and casting == 0 and no_ato_count_90 >= 3:
                current_step = "施放 真言术：耀"
                action_hotkey = get_hotkey(0, "真言术：耀")
            elif target_valid and combat and assistant == 4:
                current_step = "施放 暗言术：痛"
                action_hotkey = get_hotkey(0, "暗言术：痛")
            elif surge_of_light > 0 and no_ato_u is not None and no_ato_p is not None and no_ato_p < 90:
                current_step = f"施放 快速治疗 on {no_ato_u}, 无救赎生命低于90%的单位"
                action_hotkey = get_hotkey(int(no_ato_u), "快速治疗")
            elif surge_of_light > 0 and lowest_u is not None and lowest_p is not None and lowest_p < 90:
                current_step = f"施放 快速治疗 on {lowest_u}, 生命最低的单位"
                action_hotkey = get_hotkey(int(lowest_u), "快速治疗")
            elif shield_cd == 0 and no_ato_u is not None:
                current_step = f"施放 真言术：盾 on {no_ato_u}, 无救赎单位"
                action_hotkey = get_hotkey(int(no_ato_u), "真言术：盾")
            elif shield_cd == 0 and no_shd_lowest_u is not None:
                current_step = f"施放 真言术：盾 on {no_shd_lowest_u}, 无盾生命最低的单位"
                action_hotkey = get_hotkey(int(no_shd_lowest_u), "真言术：盾")
            elif shield_cd == 0 and no_shd_u is not None:
                current_step = f"施放 真言术：盾 on {no_shd_u}, 无盾单位"
                action_hotkey = get_hotkey(int(no_shd_u), "真言术：盾")
            elif evangelism_cd == 0 and no_ato_count_90 >= 1 and group_type == 46:
                current_step = "队伍中, 施放 福音"
                action_hotkey = get_hotkey(0, "福音")
            elif radiance_cd == 0 and casting == 0 and no_ato_count_90 >= 1 and group_type == 46:
                current_step = "施放 真言术：耀"
                action_hotkey = get_hotkey(0, "真言术：耀")
            elif penance_cd == 0 and lowest_u is not None and lowest_p is not None and lowest_p < 80:
                current_step = f"施放 苦修 on {lowest_u}, 生命最低的单位"
                action_hotkey = get_hotkey(int(lowest_u), "苦修")
            elif target_valid and combat:
                if shadow_death_cd == 0:
                    current_step = "施放 暗言术：灭"
                    action_hotkey = get_hotkey(0, "暗言术：灭")
                elif not moving and mind_blast_cd == 0:
                    current_step = "施放 心灵震爆"
                    action_hotkey = get_hotkey(0, "心灵震爆")
                elif penance_cd == 0:
                    current_step = "施放 苦修"
                    action_hotkey = get_hotkey(0, "苦修")
                elif not moving:
                    current_step = "施放 惩击"
                    action_hotkey = get_hotkey(0, "惩击")
                else:
                    current_step = "战斗中-无匹配技能"
        elif state_dict.get("英雄天赋") == 2:
            if combat:
                if target_valid and assistant == 4:
                    current_step = "施放 暗言术：痛"
                    action_hotkey = get_hotkey(0, "暗言术：痛")
                elif target_valid and entropic_rift_cd > 0 and penance_cd == 0:
                    current_step = "施放 苦修"
                    action_hotkey = get_hotkey(0, "苦修")
                elif shield_cd == 0  and no_ato_u is not None and no_ato_p < 99:
                    current_step = f"施放 真言术：盾 on {no_ato_u}, 无救赎生命最低的单位, 有虚空之盾"
                    action_hotkey = get_hotkey(int(no_ato_u), "真言术：盾")
                elif surge_of_light > 0 and no_ato_u is not None and no_ato_p < 90:
                    current_step = f"施放 快速治疗 on {no_ato_u}, 无救赎生命低于90%的单位"
                    action_hotkey = get_hotkey(int(no_ato_u), "快速治疗")
                elif evangelism_cd == 0 and (no_ato_count_90 >= 4 or (group_type == 46 and no_ato_count_90 >= 1)):
                    current_step = "施放 福音"
                    action_hotkey = get_hotkey(0, "福音")
                elif radiance_cd == 0 and casting == 0 and (no_ato_count_90 >= 4 or (group_type == 46 and no_ato_count_90 >= 1)):
                    current_step = "施放 真言术：耀"
                    action_hotkey = get_hotkey(0, "真言术：耀")
                elif shadow_death_cd == 0:
                    current_step = "施放 暗言术：灭"
                    action_hotkey = get_hotkey(0, "暗言术：灭")
                elif not moving and mind_blast_cd == 0:
                    current_step = "施放 心灵震爆"
                    action_hotkey = get_hotkey(0, "心灵震爆")
                elif not moving and target_valid and entropic_rift_cd > 0:
                    current_step = "施放 惩击"
                    action_hotkey = get_hotkey(0, "惩击")
                elif shield_cd == 0 and no_ato_u is not None and no_ato_p < 90:
                    current_step = f"施放 真言术：盾 on {no_ato_u}, 无救赎生命最低的单位"
                    action_hotkey = get_hotkey(int(no_ato_u), "真言术：盾")   
                elif target_valid and penance_cd == 0 and void_shield == 0:
                    current_step = "施放 苦修"
                    action_hotkey = get_hotkey(0, "苦修")
                elif target_valid:
                    current_step = "施放 惩击"
                    action_hotkey = get_hotkey(0, "惩击")

    elif spec_name == "神牧":
        current_step = "神牧专精,不执行任何操作"
        return None, current_step, unit_info

    elif spec_name == "暗影":
        # 暗影逻辑比较简单，不需要 unit_info
        if channeling > 0:
            current_step = "在引导,不执行任何操作"
        elif spells.get("绝望祷言") == 0 and health < 50:
            current_step = "施放 绝望祷言"
            action_hotkey = get_hotkey(0, "绝望祷言")
        elif assistant == 7:
            current_step = "施放 真言术：韧"
            action_hotkey = get_hotkey(0, "真言术：韧")
        elif assistant == 3:
            current_step = "施放 暗影形态"
            action_hotkey = get_hotkey(0, "暗影形态")
        elif target_valid and spells.get("虚空形态") < 1 and state_dict.get("法术失败") == 34:
            current_step = "施放 虚空形态"
            action_hotkey = get_hotkey(0, "虚空形态")
        elif spells.get("心灵尖啸") < 1 and state_dict.get("法术失败") == 37:
            current_step = "施放 心灵尖啸"
            action_hotkey = get_hotkey(0, "心灵尖啸")
        elif spells.get("群体驱散") < 1 and state_dict.get("法术失败") == 38:
            current_step = "施放 群体驱散"
            action_hotkey = get_hotkey(0, "群体驱散")
        elif spells.get("吸血鬼的拥抱") < 1 and state_dict.get("法术失败") == 39:
            current_step = "施放 吸血鬼的拥抱"
            action_hotkey = get_hotkey(0, "吸血鬼的拥抱")
        elif combat and target_valid:
            action_map = {
                1: ("吸血鬼之触", "吸血鬼之触"),
                2: ("心灵震爆", "心灵震爆"),
                4: ("暗言术：灭", "暗言术：灭"),
                5: ("暗言术：痛", "暗言术：痛"),
                6: ("暗言术：癫", "暗言术：癫"),
                8: ("精神鞭笞", "精神鞭笞"),
                9: ("虚空形态", "虚空形态"),
                10: ("虚空洪流", "虚空洪流"),
                11: ("触须猛击", "触须猛击"),
                12: ("虚空冲击", "虚空冲击"),
                13: ("虚空齐射", "虚空齐射"),
            }
            tup = action_map.get(assistant)
            if tup:
                current_step = f"施放 {tup[0]}"
                action_hotkey = get_hotkey(0, tup[1])
            else:
                current_step = "战斗中-无匹配技能"

    

    return action_hotkey, current_step, unit_info
