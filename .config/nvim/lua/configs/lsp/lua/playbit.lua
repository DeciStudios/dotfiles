-- playbit-preprocess.lua
-- lua_ls plugin: rewrites LuaPreprocess/Playbit macro syntax into plain
-- Lua before parsing, so normal diagnostics keep working on the rest
-- of the file instead of being disabled outright.

function OnSetText(uri, text)
	local diffs = {}

	-- @@"file.lua" / @@'file.lua'  (insert-file macro) -> delete entirely,
	-- since a bare string isn't a valid Lua statement on its own.
	for s, e in text:gmatch("()@@['\"].-['\"]()") do
		diffs[#diffs + 1] = { start = s, finish = e - 1, text = "" }
	end

	-- @@name(...)  (macro function call) -> strip the leading "@@",
	-- leaving a normal function call.
	for s, e in text:gmatch("()@@()[%a_]") do
		diffs[#diffs + 1] = { start = s, finish = e - 1, text = "" }
	end

	-- inline blocks: !( ... ) and !!( ... ) -> strip the marker, keep the parens
	for s, e in text:gmatch("()!!?()%(") do
		diffs[#diffs + 1] = { start = s, finish = e - 1, text = "" }
	end

	-- preprocessor lines: "!" or "!!" as the first non-blank char on a line
	-- (and not already handled above as a "!(" / "!!(" block)
	local searchPos = 1
	while true do
		local s, e = text:find("[!]+", searchPos)
		if not s then
			break
		end
		searchPos = e + 1

		local lineStart = text:sub(1, s - 1):match(".*\n()") or 1
		local before = text:sub(lineStart, s - 1)
		if before:match("^[ \t]*$") and text:sub(e + 1, e + 1) ~= "(" then
			diffs[#diffs + 1] = { start = s, finish = e, text = "" }
		end
	end

	if #diffs == 0 then
		return nil
	end
	return diffs
end
