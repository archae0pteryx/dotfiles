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

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.schedule(emphasize_git_changes)
  end,
})

vim.schedule(emphasize_git_changes)
