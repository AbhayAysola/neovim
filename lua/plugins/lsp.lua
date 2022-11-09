require("mason").setup()
require("mason-lspconfig").setup()

require("mason-lspconfig").setup_handlers {
    -- The first entry (without a key) will be the default handler for LSPs
    -- and will be called for each installed LSP that doesn't have
    -- a dedicated handler
    function(server_name)
        -- Add additional capabilities supported by nvim-cmp
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local lspconfig = require('lspconfig')
        lspconfig[server_name].setup {capabilities = capabilities}
    end,
    ["sumneko_lua"] = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        require'lspconfig'.sumneko_lua.setup {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT'
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = {'vim'}
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file("", true)
                    },
                    -- Do not send telemetry data containing a randomized but unique identifier
                    telemetry = {enable = false}
                }
            }
        }
    end
    -- Dedicated handlers are possible, ex:
    -- ["rust_analyzer"] = function ()
    -- require("rust-tools").setup {}
    -- end
}

local cmp = require("cmp")
if cmp == nil then return end

local opts = {
    border = "rounded",
    winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None"
}

cmp.setup({
    mapping = {
        ["<Tab>"] = cmp.mapping.select_next_item(),
        ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(9),
        ["<C-u>"] = cmp.mapping.scroll_docs(-9),
        ["<C-CR>"] = cmp.mapping.confirm()
    },
    preselect = cmp.PreselectMode.None,
    snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end
    },
    window = {completion = opts, documentation = opts},
    sources = cmp.config.sources({
        {name = "nvim_lsp", group_index = 1},
        {name = "luasnip", group_index = 1}
    })
})

require("luasnip.loaders.from_vscode").lazy_load()
