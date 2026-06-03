# -*- coding: utf-8 -*-
"""通用战斗时间轴调度器。"""

from dataclasses import dataclass, field
import re
import time


DEFAULT_TIMELINE_LATE_SEC = 4.00
TIMELINE_SCAN_START_OFFSET = 1.20
TIMELINE_RETRY_INTERVAL = 0.35


SPELL_ID_TO_NAME = {
    322118: "青龙下凡",
    115310: "还魂术",
    443028: "天神御身",
}


_TIMELINE_LINE_RE = re.compile(r"^\{time:(\d{2}):(\d{2}\.\d+)\}\s*-\s*\{spell:(\d+)\}\s*$")


def _timeline_events(raw_text: str) -> list["TimelineEvent"]:
    """把 WCL 原文轴转换成 TimelineEvent 列表。"""
    events: list[TimelineEvent] = []
    for raw_line in raw_text.splitlines():
        line = raw_line.strip()
        if not line:
            continue
        match = _TIMELINE_LINE_RE.match(line)
        if not match:
            raise ValueError(f"无法解析时间轴行: {raw_line!r}")
        minute = int(match.group(1))
        second = float(match.group(2))
        spell_id = int(match.group(3))
        events.append(TimelineEvent(minute * 60 + second, spell_id))
    return events


@dataclass(frozen=True)
class TimelineEvent:
    time_sec: float
    spell_id: int
    target: int = 0
    lead_sec: float = 0.80
    late_sec: float = DEFAULT_TIMELINE_LATE_SEC


@dataclass
class TimelineSession:
    active: bool = False
    boss_id: int = 0
    start_at: float = 0.0
    start_source: float = 0.0
    start_scan_ms: float = 0.0
    fired: set[int] = field(default_factory=set)
    pending: dict[int, float] = field(default_factory=dict)


TIMELINE_TABLES = {
    "织雾": {
        1: _timeline_events("""
{time:00:07.9} -  {spell:443028}
{time:00:17.8} -  {spell:322118}
{time:00:55.2} -  {spell:115310}
{time:01:48.0} -  {spell:443028}
{time:02:24.8} -  {spell:322118}
{time:04:00.9} -  {spell:115310}
{time:04:31.0} -  {spell:322118}
{time:05:04.3} -  {spell:443028}
{time:06:27.6} -  {spell:115310}
{time:06:40.0} -  {spell:443028}
{time:06:43.2} -  {spell:322118}
        """),
        2: _timeline_events("""
{time:00:12.2} -  {spell:443028}
{time:01:03.1} -  {spell:115310}
{time:01:28.1} -  {spell:322118}
{time:01:43.1} -  {spell:443028}
{time:03:19.6} -  {spell:443028}
{time:03:31.0} -  {spell:322118}
{time:04:14.0} -  {spell:115310}
{time:05:08.9} -  {spell:443028}
{time:05:34.2} -  {spell:322118}
        """),
        3: _timeline_events("""
{time:00:15.6} -  {spell:443028}
{time:00:23.9} -  {spell:322118}
{time:01:24.1} -  {spell:115310}
{time:01:51.9} -  {spell:443028}
{time:02:24.9} -  {spell:322118}
{time:03:25.6} -  {spell:443028}
{time:04:27.9} -  {spell:322118}
{time:04:57.4} -  {spell:115310}
{time:05:16.5} -  {spell:443028}
        """),

        4: _timeline_events("""
{time:00:23.6} -  {spell:443028}
{time:00:34.4} -  {spell:322118}
{time:01:15.4} -  {spell:115310}
{time:02:10.2} -  {spell:443028}
{time:02:38.1} -  {spell:322118}
{time:03:47.9} -  {spell:443028}
{time:04:32.1} -  {spell:115310}
{time:04:48.4} -  {spell:322118}
{time:05:31.9} -  {spell:443028}
{time:06:53.6} -  {spell:322118}
        """),
        5: _timeline_events("""
{time:00:09.7} -  {spell:322118}
{time:00:39.8} -  {spell:443028}
{time:01:12.8} -  {spell:115310}
{time:02:09.7} -  {spell:322118}
{time:02:25.4} -  {spell:443028}
{time:03:54.5} -  {spell:115310}
{time:04:05.2} -  {spell:443028}
{time:04:11.3} -  {spell:322118}
{time:05:45.9} -  {spell:443028}
{time:06:14.1} -  {spell:322118}
{time:06:36.5} -  {spell:115310}
        """),
        7: _timeline_events("""
{time:00:02.0} -  {spell:322118}
{time:00:16.0} -  {spell:115310}
{time:00:16.4} -  {spell:443028}
{time:01:50.8} -  {spell:443028}
{time:02:09.3} -  {spell:322118}
{time:03:26.9} -  {spell:443028}
{time:04:14.8} -  {spell:322118}
{time:05:11.2} -  {spell:443028}
{time:06:14.8} -  {spell:322118}
        """),
        8: _timeline_events("""
{time:00:02.7} -  {spell:443028}
{time:00:53.4} -  {spell:115310}
{time:01:42.7} -  {spell:443028}
{time:01:54.9} -  {spell:322118}
{time:03:21.9} -  {spell:443028}
{time:04:13.5} -  {spell:115310}
{time:04:44.5} -  {spell:322118}
{time:05:03.5} -  {spell:443028}
        """),
        9: _timeline_events("""
{time:00:03.3} -  {spell:443028}
{time:00:59.8} -  {spell:322118}
{time:01:33.3} -  {spell:443028}
{time:02:12.6} -  {spell:115310}
{time:03:01.1} -  {spell:322118}
{time:03:42.8} -  {spell:443028}
{time:05:03.0} -  {spell:322118}
{time:05:14.8} -  {spell:115310}
{time:05:32.0} -  {spell:443028}
{time:05:24.3} -  {spell:322118}
{time:07:32.6} -  {spell:443028}
{time:08:54.0} -  {spell:115310}
{time:09:04.7} -  {spell:322118}
{time:09:05.8} -  {spell:443028}
        """),
    }
}


_SESSIONS: dict[str, TimelineSession] = {}


def _get_session(spec_name: str) -> TimelineSession:
    session = _SESSIONS.get(spec_name)
    if session is None:
        session = TimelineSession()
        _SESSIONS[spec_name] = session
    return session


def _reset_session(session: TimelineSession) -> None:
    session.active = False
    session.boss_id = 0
    session.start_at = 0.0
    session.start_source = 0.0
    session.start_scan_ms = 0.0
    session.fired.clear()
    session.pending.clear()


def _spell_ready(spells: dict, spell_name: str | None) -> bool:
    if not spell_name:
        return False
    return spells.get(spell_name, -1) == 0


def _spell_name(spell_id: int) -> str | None:
    return SPELL_ID_TO_NAME.get(spell_id)


def _start_session(session: TimelineSession, boss_id: int, state_dict: dict) -> None:
    session.active = True
    session.boss_id = boss_id
    session.start_source = time.monotonic()
    session.start_scan_ms = float(state_dict.get("_scan_ms", 0.0) or 0.0)
    session.start_at = (
        session.start_source
        - (session.start_scan_ms / 2000.0)
        - TIMELINE_SCAN_START_OFFSET
    )
    session.fired.clear()
    session.pending.clear()


def get_timeline_action(state_dict, spec_name):
    """返回 (事件下标, 技能名, 显示文案)，没有可用时间轴技能则返回三个 None。"""
    combat = bool(state_dict.get("战斗", False))
    boss_id = int(state_dict.get("首领战", 0) or 0)
    session = _get_session(spec_name)
    boss_tables = TIMELINE_TABLES.get(spec_name) or {}
    events = boss_tables.get(boss_id)

    if not combat or not events:
        if session.active or session.fired or session.pending:
            _reset_session(session)
        return None, None, None

    if (not session.active) or session.boss_id != boss_id:
        _start_session(session, boss_id, state_dict)

    now = time.monotonic()
    elapsed = now - session.start_at
    spells = state_dict.get("spells") or {}
    retry_candidate = None

    for idx, event in enumerate(events):
        if idx in session.fired:
            continue

        if elapsed + event.lead_sec < event.time_sec:
            break

        if elapsed > event.time_sec + event.late_sec:
            session.pending.pop(idx, None)
            session.fired.add(idx)
            continue

        spell_name = _spell_name(event.spell_id)
        spell_ready = _spell_ready(spells, spell_name)

        if idx in session.pending:
            if not spell_ready:
                session.pending.pop(idx, None)
                session.fired.add(idx)
                continue
            if now - session.pending[idx] < TIMELINE_RETRY_INTERVAL:
                continue
            retry_candidate = retry_candidate or (idx, spell_name, f"时间轴 重试 {spell_name}")
            continue

        if not spell_ready:
            continue

        return idx, spell_name, f"时间轴 施放 {spell_name}"

    if retry_candidate is not None:
        return retry_candidate

    return None, None, None


def get_timeline_debug(state_dict, spec_name):
    combat = bool(state_dict.get("战斗", False))
    boss_id = int(state_dict.get("首领战", 0) or 0)
    boss_tables = TIMELINE_TABLES.get(spec_name) or {}
    events = boss_tables.get(boss_id)
    session = _get_session(spec_name)

    if not combat:
        return "未战斗"
    if not events:
        return f"无 boss 轴 boss={boss_id}"
    if not session.active or session.boss_id != boss_id:
        return f"等待计时 boss={boss_id}"

    elapsed = time.monotonic() - session.start_at
    spells = state_dict.get("spells") or {}
    for idx, event in enumerate(events):
        if idx in session.fired:
            continue
        spell_name = _spell_name(event.spell_id)
        cd = spells.get(spell_name, -1)
        pending = " pending" if idx in session.pending else ""
        return (
            f"boss={boss_id} t={elapsed:.1f} next={event.time_sec:.1f} "
            f"{spell_name} cd={cd} scan={session.start_scan_ms:.1f}ms{pending}"
        )
    return f"boss={boss_id} t={elapsed:.1f} 全部完成"


def mark_timeline_action_fired(spec_name, event_index):
    """先标记为 pending；下一轮看到技能 CD 变化后，才确认这条轴完成。"""
    if event_index is None:
        return
    session = _get_session(spec_name)
    if event_index not in session.fired:
        session.pending[event_index] = time.monotonic()
