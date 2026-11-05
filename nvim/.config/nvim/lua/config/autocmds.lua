local group = vim.api.nvim_create_augroup("user_config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = group,
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "TermClose", "TermLeave" }, {
  group = group,
  desc = "Reload files changed outside nvim",
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd.checktime()
    end
  end,
})

local timers = {}

local function autosave(buf)
  if not vim.api.nvim_buf_is_loaded(buf) then
    return
  end
  local bo = vim.bo[buf]
  if not bo.modified or bo.buftype ~= "" or not bo.modifiable or bo.readonly
    or vim.api.nvim_buf_get_name(buf) == "" then
    return
  end
  -- Flag the write so format-on-save skips it; formatting mid-edit moves text.
  vim.b[buf].autosaving = true
  vim.api.nvim_buf_call(buf, function()
    vim.cmd("silent! lockmarks update")
  end)
  vim.b[buf].autosaving = false
end

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
  group = group,
  desc = "Autosave after a short delay",
  callback = function(args)
    local buf = args.buf
    if timers[buf] then
      timers[buf]:stop()
    else
      timers[buf] = vim.uv.new_timer()
    end
    timers[buf]:start(1000, 0, vim.schedule_wrap(function()
      -- Do not write mid-insert; InsertLeave will reschedule.
      if vim.fn.mode() ~= "i" then
        autosave(buf)
      end
    end))
  end,
})

vim.api.nvim_create_autocmd("FocusLost", {
  group = group,
  desc = "Autosave when nvim loses focus",
  callback = function(args)
    autosave(args.buf)
  end,
})

vim.api.nvim_create_autocmd("BufLeave", {
  group = group,
  desc = "Autosave after switching buffers",
  callback = function(args)
    -- Let :bdelete!, :bwipeout! and :edit! finish discarding the buffer first.
    vim.schedule(function()
      autosave(args.buf)
    end)
  end,
})

vim.api.nvim_create_autocmd("BufUnload", {
  group = group,
  callback = function(args)
    if timers[args.buf] then
      timers[args.buf]:close()
      timers[args.buf] = nil
    end
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  group = group,
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lines = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

local git_status_groups = {
  "SnacksPickerGitStatusAdded",
  "SnacksPickerGitStatusModified",
  "SnacksPickerGitStatusDeleted",
  "SnacksPickerGitStatusRenamed",
  "SnacksPickerGitStatusCopied",
  "SnacksPickerGitStatusUntracked",
  "SnacksPickerGitStatusStaged",
  "SnacksPickerGitStatusUnmerged",
}

local function emphasize_git_changes()
  for _, name in ipairs(git_status_groups) do
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    if next(hl) then
      hl.bold = true
      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
  group = group,
  callback = function()
    vim.schedule(emphasize_git_changes)
  end,
})
