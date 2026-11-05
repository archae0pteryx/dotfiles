-- Use PATH for servers managed by Go, rustup and Xcode to match their toolchains.
local mason_servers = {
  "basedpyright", "bashls", "jsonls", "lua_ls", "marksman",
  "terraformls", "vtsls", "yamlls",
}
local system_servers = { "clangd", "gopls", "rust_analyzer" }

local function on_attach(args)
  local buf = args.buf
  local function map(lhs, rhs, desc, mode)
    vim.keymap.set(mode or "n", lhs, rhs, { buffer = buf, desc = desc })
  end

  map("gd", function() Snacks.picker.lsp_definitions() end, "Goto definition")
  map("gD", function() Snacks.picker.lsp_declarations() end, "Goto declaration")
  map("gy", function() Snacks.picker.lsp_type_definitions() end, "Goto type definition")
  map("gI", function() Snacks.picker.lsp_implementations() end, "Goto implementation")
  map("grr", function() Snacks.picker.lsp_references() end, "References")
  map("<leader>cr", vim.lsp.buf.rename, "Rename symbol")
  map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
  map("<leader>ci", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = buf }), { bufnr = buf })
  end, "Toggle inlay hints")
end

return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "mason-org/mason.nvim", cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonLog" }, opts = {} },
      "neovim/nvim-lspconfig",
      "saghen/blink.cmp",
    },
    opts = {
      ensure_installed = mason_servers,
      -- stylua is installed for conform; do not also run it as an LSP.
      automatic_enable = { exclude = vim.list_extend({ "stylua" }, system_servers) },
    },
    config = function(_, opts)
      vim.diagnostic.config({
        severity_sort = true,
        virtual_text = { spacing = 2, source = "if_many" },
        float = { source = "if_many" },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("user_lsp", { clear = true }),
        callback = on_attach,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
          },
        },
      })

      require("mason-lspconfig").setup(opts)
      vim.lsp.enable(system_servers)
    end,
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = { "goimports", "prettierd", "ruff", "shfmt", "stylua" },
    },
  },
}
