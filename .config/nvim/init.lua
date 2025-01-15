--[[
-- plugin configuration
--]]
local Plug = vim.fn['plug#']
vim.call('plug#begin')

-- general stuff
Plug('neovim/nvim-lspconfig')
Plug('williamboman/mason.nvim')
Plug('archseer/colibri.vim')
Plug('morhetz/gruvbox')
Plug('nanotech/jellybeans.vim')
Plug('nvim-lualine/lualine.nvim')
Plug('tpope/vim-surround')
Plug('tpope/vim-commentary')
Plug('tpope/vim-fugitive')
Plug('junegunn/vim-easy-align')
Plug('junegunn/fzf', { ['do'] = function()
  vim.fn['fzf#install']()
end })
Plug('junegunn/fzf.vim')
Plug('wellle/targets.vim')
Plug('github/copilot.vim')

-- language specific
Plug('rust-lang/rust.vim')
Plug('Tetralux/odin.vim')
Plug('fatih/vim-go')
Plug('ziglang/zig.vim')
Plug('tikhomirov/vim-glsl')
Plug('ARM9/arm-syntax-vim')

-- my stuff
Plug('~/src/c-primitive-types.vim')
Plug('~/src/geo/geo.vim')
Plug('gsmrs/pio-asm.vim')

vim.call('plug#end')


--[[
-- General configuration
--]]
vim.cmd("colorscheme jellybeans")

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.number = true
vim.o.cursorline = true
vim.o.scrolloff = 2

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.magic = true

vim.o.showmatch = true
vim.o.matchtime = 1 -- tenths of seconds

vim.o.errorbells = false
vim.o.visualbell = false

vim.o.path = vim.o.path .. "**"

vim.o.expandtab = true
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4

vim.o.smartindent = false
vim.o.wrap = true

vim.o.completeopt = "longest,menuone"
vim.o.synmaxcol = 200

vim.o.listchars = "tab:»·,trail:·,nbsp:·"
vim.o.list = true

-- maximum syntax highlighting columns, avoids lag in long wrapped lines
vim.o.synmaxcol = 200

-- don't treat C99 compound literals as errors
vim.g.c_no_curly_error = 1

--[[
-- key bindings
--]]

vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

vim.keymap.set("n", "<leader>w", ":w!<cr>")
vim.keymap.set("n", "<leader>q", ":q!<cr>")

vim.keymap.set("n", "<leader>n", ":bp<cr>")
vim.keymap.set("n", "<leader>m", ":bn<cr>")

vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set("n", "<C-p>", ":<C-u>Files<cr>")
vim.keymap.set("n", "<leader>g", ":<C-u>GitFiles<cr>")
vim.keymap.set("n", "<leader>t", ":<C-u>Tags<cr>")
vim.keymap.set("n", "<A-p>", ":<C-u>Buffers<cr>")

vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")

vim.keymap.set("n", "<leader><cr>", ":nohl<cr>", { silent = true })

vim.keymap.set("n", "<C-j>", ":cnext<CR>zz")
vim.keymap.set("n", "<C-k>", ":cprevious<CR>zz")

vim.keymap.set("n", "<leader>j", ":lnext<CR>zz")
vim.keymap.set("n", "<leader>k", ":lprevious<CR>zz")

-- Close the current buffer
vim.keymap.set("n", "<leader>bd", ":bd<cr>")

vim.keymap.set("n", "<leader>cd", ":cd %:p:h<cr>:pwd<cr>")

vim.keymap.set("x", "ga", "<Plug>(EasyAlign)")
vim.keymap.set("n", "ga", "<Plug>(EasyAlign)")


--[[
-- Neovide
--]]

if vim.g.neovide then
    vim.o.guifont = "Berkeley Mono:h11:#e-subpixelantialias:#h-full"
    vim.g.neovide_scroll_animation_length = 0.066
    vim.g.neovide_scroll_animation_far_lines = 1
    vim.g.neovide_cursor_animation_length = 0.033
end

--[[
-- misc. init
--]]

require('mason').setup()

require('lualine').setup({
    sections = {
        lualine_c = {{'filename', path=1}}
    }
})

function TrimWhitespace()
    -- Save cursor position
    local cursor_pos = vim.fn.getpos('.')

    -- Remove trailing whitespace
    vim.cmd([[%s/\s\+$//e]])

    -- Restore cursor position
    vim.fn.setpos('.', cursor_pos)
end
vim.api.nvim_create_user_command('TrimWhitespace', TrimWhitespace, {})

--[[
-- LSP configuration
--]]
local lspconfig = require("lspconfig")
lspconfig.gopls.setup({})
lspconfig.clangd.setup({})
lspconfig.zls.setup({})
lspconfig.ols.setup({})
lspconfig.pylsp.setup({
    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    ignore = {'E402'},
                    maxLineLength = 120
                }
            }
        }
    }

})
lspconfig.rust_analyzer.setup({})

vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

local use_semantic_highlighting = true

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)

        if not use_semantic_highlighting then
            client.server_capabilities.semanticTokensProvider = nil
        end

        vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set({"n", "i"}, "<C-k>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({"n", "v"}, "<space>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<space>gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format { async = true }
        end, opts)
        vim.keymap.set("n", "<space>h", vim.lsp.buf.document_highlight, opts)
        vim.keymap.set("n", "<space>cr", vim.lsp.buf.clear_references, ops)
        vim.keymap.set("n", "<space>u", vim.lsp.buf.document_symbol, opts)
    end,
})
