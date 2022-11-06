require("mason").setup()
require("mason-lspconfig").setup()

require("mason-lspconfig").setup_handlers {
  -- The first entry (without a key) will be the default handler for LSPs
  -- and will be called for each installed LSP that doesn't have
  -- a dedicated handler
  function (server_name)
    -- Add additional capabilities supported by nvim-cmp
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local lspconfig = require('lspconfig')
    lspconfig[server_name].setup {
      capabilities = capabilities
    }
  end,
  ["sumneko_lua"] = function ()
    require'lspconfig'.sumneko_lua.setup {
      settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = {'vim'},
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = {
            enable = false,
          },
        },
      },
    }
  end,
  ["clangd"] = function ()
    require'lspconfig'.clangd.setup {
      cmd = { 'clangd', '--enable-config', '--suggest-missing-includes'}
    }
  end
  -- Dedicated handlers are possible, ex:
  -- ["rust_analyzer"] = function ()
    -- require("rust-tools").setup {}
  -- end
}



local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
local luasnip = require("luasnip")
local cmp = require("cmp")
if cmp == nil then
  return
end

cmp.setup {
  snippet = {
      expand = function(args)
        require'luasnip'.lsp_expand(args.body)
      end
    },

 mapping = {
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },

 sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

require("luasnip.loaders.from_vscode").lazy_load()
-- require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/snippets"})
