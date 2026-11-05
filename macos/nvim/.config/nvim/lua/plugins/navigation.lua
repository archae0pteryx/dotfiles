local function pick(source, opts)
  return function() Snacks.picker[source](opts) end
end

return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 900,
    ---@type snacks.Config
    opts = {
      explorer = { replace_netrw = true },
      input = {},
      notifier = {},
      picker = {
        sources = {
          explorer = {
            hidden = true,
            layout = { layout = { position = "right" } },
          },
          files = { hidden = true },
          grep = { hidden = true },
          projects = {
            dev = {
              "~/Code/archae0pteryx",
              "~/Code/eyepop",
              "~/Code/killallgit",
              "~/Code/pocketcereal",
            },
          },
        },
      },
    },
    keys = {
      -- Find
      { "<leader><space>", pick("smart"), desc = "Find files (smart)" },
      { "<leader>ff", pick("files"), desc = "Files" },
      { "<leader>fr", pick("recent"), desc = "Recent files" },
      { "<leader>fb", pick("buffers"), desc = "Buffers" },
      { "<leader>fp", pick("projects"), desc = "Projects" },
      { "<leader>fc", pick("files", { cwd = vim.fn.stdpath("config") }), desc = "Config files" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File explorer" },

      -- Search
      { "<leader>/", pick("grep"), desc = "Grep project" },
      { "<leader>sw", pick("grep_word"), desc = "Grep word or selection", mode = { "n", "x" } },
      { "<leader>sb", pick("lines"), desc = "Buffer lines" },
      { "<leader>sd", pick("diagnostics"), desc = "Diagnostics" },
      { "<leader>sD", pick("diagnostics_buffer"), desc = "Buffer diagnostics" },
      { "<leader>ss", pick("lsp_symbols"), desc = "Document symbols" },
      { "<leader>sS", pick("lsp_workspace_symbols"), desc = "Workspace symbols" },
      { "<leader>sh", pick("help"), desc = "Help pages" },
      { "<leader>sk", pick("keymaps"), desc = "Keymaps" },
      { "<leader>sc", pick("commands"), desc = "Commands" },
      { "<leader>sr", pick("resume"), desc = "Resume last picker" },

      -- Buffers
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete buffer" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete other buffers" },
    },
  },
}
