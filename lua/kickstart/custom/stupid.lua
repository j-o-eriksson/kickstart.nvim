local gitlog = function()
  local str = vim.fn.system { 'git', 'log', '--pretty=oneline', '--abbrev-commit', '--', '.' }
  return vim.split(str, '\n')
end

local commit_diff = function(opts)
  opts = opts or {}
  require('telescope.pickers')
    .new(opts, {
      prompt_taitle = 'Git Difference',
      finder = require('telescope.finders').new_dynamic { fn = gitlog },
      sorter = require('telescope.config').values.generic_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        local actions = require 'telescope.actions'
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = require('telescope.actions.state').get_selected_entry()
          local githash = vim.split(selection[1], ' ')[1]
          vim.fn.execute('DiffviewOpen ' .. githash .. '^!')
        end)
        return true
      end,
    })
    :find()
end

local m = {}
m.run = function()
  commit_diff(require('telescope.themes').get_dropdown {})
end
return m
