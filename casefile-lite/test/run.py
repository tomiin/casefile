#!/usr/bin/env python3
# Runs the Lua harness via embedded Lua (lupa) so Casefile Lite can be proven
# without a FiveM server. Run from the resource root:  python3 test/run.py
import sys
from lupa import LuaRuntime
lua = LuaRuntime(unpack_returned_tuples=True)
try:
    lua.execute(open("test/harness.lua", "r", encoding="utf-8").read())
except Exception as e:
    print("Lua error:", e); sys.exit(1)
