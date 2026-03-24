-- ~/.config/nvim/colors/void_black.lua

-- 1. Setup
vim.cmd('hi clear')
if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
end

vim.o.termguicolors = true
vim.g.colors_name = 'void_black'

-- 2. Your Exact XTerm Palette
local c = {
    -- Background / Foreground
    bg             = { gui = "#000000", cterm = 0 },
    fg             = { gui = "#ffffff", cterm = 15 },
    panel          = { gui = "#111111", cterm = 0 },
    panel_alt      = { gui = "#1a1a1a", cterm = 0 },
    -- Normal Colors (0-7)
    black          = { gui = "#000000", cterm = 0 },
    red            = { gui = "#cc0000", cterm = 1 },
    green          = { gui = "#00cc00", cterm = 2 },
    yellow         = { gui = "#cccc00", cterm = 3 },
    blue           = { gui = "#0000cc", cterm = 4 },
    magenta        = { gui = "#cc00cc", cterm = 5 },
    cyan           = { gui = "#00cccc", cterm = 6 },
    gray           = { gui = "#cccccc", cterm = 7 },

    -- Bright Colors (8-15)
    dark_gray      = { gui = "#555555", cterm = 8 },
    bright_red     = { gui = "#ff0000", cterm = 9 },
    bright_green   = { gui = "#00ff00", cterm = 10 },
    bright_yellow  = { gui = "#ffff00", cterm = 11 },
    bright_blue    = { gui = "#0000ff", cterm = 12 },
    bright_magenta = { gui = "#ff00ff", cterm = 13 },
    bright_cyan    = { gui = "#00ffff", cterm = 14 },
    white          = { gui = "#ffffff", cterm = 15 },
}

-- 3. FIXED Helper function
local function hl(group, fg, bg, attr)
    local opts = {}
    -- Handle Colors
    if fg then
        opts.fg = fg.gui; opts.ctermfg = fg.cterm
    end
    if bg then
        opts.bg = bg.gui; opts.ctermbg = bg.cterm
    end
    -- Handle Attributes (bold, italic, etc.)
    -- nvim_set_hl requires boolean keys (e.g. { bold = true })
    if attr then
        opts[attr] = true
    end
    vim.api.nvim_set_hl(0, group, opts)
end

-- 4. General UI
hl('Normal', c.fg, c.bg)
hl('NormalFloat', c.fg, c.dark_gray)
hl('NonText', c.dark_gray, c.bg)
hl('Cursor', c.black, c.white)
hl('CursorLine', nil, nil, 'bold')
hl('LineNr', c.dark_gray, c.bg)
hl('CursorLineNr', c.bright_yellow, c.bg, 'bold')
hl('StatusLine', c.white, c.panel)
hl('StatusLineNC', c.dark_gray, c.panel_alt)
hl('VertSplit', c.dark_gray, c.bg)
hl('Visual', c.white, c.blue)
hl('NormalFloat', c.fg, c.panel)
hl('Search', c.black, c.bright_yellow)
hl('IncSearch', c.black, c.bright_yellow, 'bold')
hl('MatchParen', c.black, c.bright_cyan)
hl('Pmenu', c.white, c.black)
hl('PmenuSel', c.black, c.bright_yellow, 'bold')
hl('PmenuSbar', c.dark_gray, c.black)
hl('PmenuThumb', c.white, c.bright_blue)
hl('WildMenu', c.black, c.bright_green, 'bold')
hl('FloatBorder', c.bright_cyan, c.black)
hl('NormalFloat', c.white, c.black)
hl('Title', c.bright_yellow, nil, 'bold')
hl('Question', c.bright_yellow, nil, 'bold')
hl('MoreMsg', c.bright_green, nil, 'bold')
hl('WarningMsg', c.bright_yellow, nil, 'bold')
hl('ErrorMsg', c.bright_red, nil, 'bold')
hl('HelpCommand', c.bright_cyan, nil, 'bold')
hl('HelpHeader', c.bright_yellow, nil, 'bold')
hl('HelpSectionDelim', c.dark_gray, nil)

-- 5. Syntax Highlighting (High Contrast)
hl('Comment', c.dark_gray, nil, 'italic')
hl('CursorColumn', nil, c.panel)
hl('ColorColumn', nil, c.panel_alt)
hl('Folded', c.cyan, c.panel)
hl('FoldColumn', c.dark_gray, c.panel)
hl('SignColumn', nil, c.bg)

hl('Constant', c.cyan, nil)
hl('String', c.green, nil)
hl('Character', c.green, nil)

hl('Identifier', c.white, nil)
hl('Function', c.bright_blue, nil, 'bold')

hl('Statement', c.bright_red, nil, 'bold')
hl('Operator', c.bright_magenta, nil)

hl('PreProc', c.yellow, nil)
hl('Type', c.bright_yellow, nil)
hl('Special', c.bright_magenta, nil)

hl('Error', c.bright_red, nil, 'bold')
hl('Todo', c.black, c.bright_yellow, 'bold')

-- 6. Diagnostics (LSP)
hl('DiagnosticError', c.bright_red, nil, 'bold')
hl('DiagnosticWarn', c.bright_yellow, nil)
hl('DiagnosticInfo', c.bright_blue, nil)
hl('DiagnosticHint', c.bright_cyan, nil)

-- 7. Git Signs
hl('GitSignsAdd', c.green, nil)
hl('GitSignsChange', c.yellow, nil)
hl('GitSignsDelete', c.red, nil)
