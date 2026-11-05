return {
  {
    -- The main branch needs the tree-sitter CLI and a C compiler.
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    -- Parsers live in opts so tests/nvim can install the same list.
    opts = {
      parsers = {
        "bash", "c", "cpp", "diff", "dockerfile", "gitcommit", "go", "gomod",
        "hcl", "javascript", "json", "lua", "markdown", "markdown_inline", "nix",
        "python", "rust", "terraform", "toml", "tsx", "typescript", "vim", "vimdoc",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").install(opts.parsers)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
}
