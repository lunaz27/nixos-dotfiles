local ls = require("luasnip")
local t = ls.text_node
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node

return {
  s("fcomment", {
    f(function()
      local cstr = vim.bo.commentstring
      local prefix = cstr ~= "" and cstr:match("^(.-)%s*%%s") or "#"
      return prefix .. " ── "
    end),

    i(1, "Title"),

    f(function(args)
      local title = args[1][1]
      local cstr = vim.bo.commentstring
      local prefix = cstr ~= "" and cstr:match("^(.-)%s*%%s") or "#"

      local left_text = prefix .. " ── " .. title .. " "
      local current_width = vim.fn.strdisplaywidth(left_text)

      local dash_width = math.max(1, vim.fn.strdisplaywidth("─"))
      local max_width = 80

      local remaining_width = max_width - current_width
      local dash_count = math.floor(remaining_width / dash_width)

      if dash_count > 0 then
        return " " .. string.rep("─", dash_count)
      else
        return " "
      end
    end, { 1 }),

    t({ "", "" }),
  }),
}
