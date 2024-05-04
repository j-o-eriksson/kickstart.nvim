local actions = require 'telescope.actions'
local action_state = require 'telescope.actions.state'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values

local function mysplit(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
    table.insert(t, str)
  end
  return t
end

local myfunc = function()
  local str = vim.fn.system { 'git', 'log', '--pretty=oneline', '--abbrev-commit', '--', '.' }
  return mysplit(str, '\n')
end

local commit_diff = function(opts)
  opts = opts or {}
  pickers
    .new(opts, {
      prompt_taitle = 'Git Difference',
      finder = finders.new_dynamic { fn = myfunc },
      sorter = conf.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          local githash = mysplit(selection[1], ' ')[1]
          vim.fn.execute('DiffviewOpen ' .. githash)
        end)
        return true
      end,
    })
    :find()
end
--
-- to execute the function
commit_diff(require('telescope.themes').get_dropdown {})
