-- Asiimov colorscheme for Neovim.
-- Palette source: https://github.com/jnigri/asiimov-theme
-- Flavor follows 'background': dark -> "Asiimov Dark", light -> "Asiimov".
-- Syntax is deliberately sparse: orange keywords/numbers, green strings,
-- muted italic comments, everything else plain text.

local M = {}

M.palettes = {
  dark = {
    base = "#141516",
    surface = "#1d1f20",
    overlay = "#2c2f31",
    text = "#e6e8e9",
    muted = "#8a8f93",
    accent = "#ff5a00",
    link = "#ff8a3d",
    success = "#5fcf7d",
    error = "#ff4d6a",
    stripe = "#eef0f1",
    blaze = "#ff5a00",
    -- derived (not in the upstream palette)
    amber = "#ffb547",
    border = "#3a3d40",
    subtle = "#4f5357",
  },
  light = {
    base = "#eef0f1",
    surface = "#e1e4e6",
    overlay = "#ccd1d4",
    text = "#161616",
    muted = "#6c7176",
    accent = "#e85400",
    link = "#b33a00",
    success = "#23803f",
    error = "#c8102e",
    stripe = "#1c1c1c",
    blaze = "#ff5a00",
    -- derived (not in the upstream palette)
    amber = "#a86400",
    border = "#bcc1c5",
    subtle = "#a3a8ac",
  },
}

local function hex2rgb(hex)
  return tonumber(hex:sub(2, 3), 16), tonumber(hex:sub(4, 5), 16), tonumber(hex:sub(6, 7), 16)
end

--- Mix `fg` over `bg` with opacity `alpha` (0..1).
function M.blend(fg, bg, alpha)
  local r1, g1, b1 = hex2rgb(fg)
  local r2, g2, b2 = hex2rgb(bg)
  local function mix(a, b)
    return math.floor(a * alpha + b * (1 - alpha) + 0.5)
  end
  return string.format("#%02x%02x%02x", mix(r1, r2), mix(g1, g2), mix(b1, b2))
end

function M.colors()
  return M.palettes[vim.o.background == "light" and "light" or "dark"]
end

function M.highlights(c)
  local blend = M.blend
  local diff_add = blend(c.success, c.base, 0.15)
  local diff_del = blend(c.error, c.base, 0.15)
  local diff_chg = blend(c.accent, c.base, 0.10)
  local diff_txt = blend(c.accent, c.base, 0.25)

  return {
    -- Editor UI ------------------------------------------------------------
    Normal = { fg = c.text, bg = c.base },
    NormalNC = { fg = c.text, bg = c.base },
    NormalFloat = { fg = c.text, bg = c.surface },
    FloatBorder = { fg = c.border, bg = c.surface },
    FloatTitle = { fg = c.accent, bg = c.surface, bold = true },
    FloatFooter = { fg = c.muted, bg = c.surface },
    Cursor = { fg = c.base, bg = c.accent },
    lCursor = { link = "Cursor" },
    CursorIM = { link = "Cursor" },
    TermCursor = { link = "Cursor" },
    CursorLine = { bg = c.surface },
    CursorColumn = { bg = c.surface },
    ColorColumn = { bg = c.surface },
    CursorLineNr = { fg = c.text, bold = true },
    CursorLineSign = { bg = c.surface },
    CursorLineFold = { fg = c.muted, bg = c.surface },
    LineNr = { fg = c.subtle },
    LineNrAbove = { link = "LineNr" },
    LineNrBelow = { link = "LineNr" },
    SignColumn = { fg = c.muted },
    FoldColumn = { fg = c.subtle },
    Folded = { fg = c.muted, bg = c.surface },
    VertSplit = { fg = c.border },
    WinSeparator = { fg = c.border },
    EndOfBuffer = { fg = c.base },
    NonText = { fg = c.subtle },
    Whitespace = { fg = c.border },
    SpecialKey = { fg = c.subtle },
    Conceal = { fg = c.muted },
    Visual = { bg = c.overlay },
    VisualNOS = { bg = c.overlay },
    Search = { fg = c.base, bg = c.link },
    IncSearch = { fg = c.base, bg = c.accent, bold = true },
    CurSearch = { link = "IncSearch" },
    Substitute = { fg = c.base, bg = c.error },
    MatchParen = { fg = c.accent, bold = true, underline = true },
    StatusLine = { fg = c.text, bg = c.surface },
    StatusLineNC = { fg = c.muted, bg = c.surface },
    TabLine = { fg = c.muted, bg = c.surface },
    TabLineFill = { bg = c.base },
    -- bg doubles as bufferline's underline color for the active buffer
    TabLineSel = { fg = c.base, bg = c.accent, bold = true },
    WinBar = { fg = c.muted },
    WinBarNC = { fg = c.subtle },
    Pmenu = { fg = c.text, bg = c.surface },
    PmenuSel = { fg = c.text, bg = c.overlay, bold = true },
    PmenuSbar = { bg = c.surface },
    PmenuThumb = { bg = c.subtle },
    PmenuKind = { fg = c.accent, bg = c.surface },
    PmenuKindSel = { fg = c.accent, bg = c.overlay },
    PmenuExtra = { fg = c.muted, bg = c.surface },
    PmenuExtraSel = { fg = c.muted, bg = c.overlay },
    PmenuMatch = { fg = c.accent, bold = true },
    PmenuMatchSel = { fg = c.accent, bold = true },
    WildMenu = { link = "PmenuSel" },
    Directory = { fg = c.accent },
    Title = { fg = c.accent, bold = true },
    Question = { fg = c.success },
    MoreMsg = { fg = c.success },
    ModeMsg = { fg = c.text, bold = true },
    MsgArea = { fg = c.text },
    ErrorMsg = { fg = c.error, bold = true },
    WarningMsg = { fg = c.amber },
    QuickFixLine = { bg = c.overlay, bold = true },
    QuickFixLineNr = { fg = c.accent },
    SpellBad = { sp = c.error, undercurl = true },
    SpellCap = { sp = c.amber, undercurl = true },
    SpellLocal = { sp = c.link, undercurl = true },
    SpellRare = { sp = c.link, undercurl = true },
    DiffAdd = { bg = diff_add },
    DiffDelete = { bg = diff_del },
    DiffChange = { bg = diff_chg },
    DiffText = { bg = diff_txt },
    Added = { fg = c.success },
    Removed = { fg = c.error },
    Changed = { fg = c.link },
    healthError = { fg = c.error },
    healthSuccess = { fg = c.success },
    healthWarning = { fg = c.amber },

    -- Syntax ---------------------------------------------------------------
    Comment = { fg = c.muted, italic = true },
    Constant = { fg = c.accent },
    String = { fg = c.success },
    Character = { fg = c.success },
    Number = { fg = c.accent },
    Float = { fg = c.accent },
    Boolean = { fg = c.accent },
    Identifier = { fg = c.text },
    Function = { fg = c.text },
    Statement = { fg = c.accent },
    Conditional = { fg = c.accent },
    Repeat = { fg = c.accent },
    Label = { fg = c.accent },
    Operator = { fg = c.text },
    Keyword = { fg = c.accent },
    Exception = { fg = c.accent },
    PreProc = { fg = c.accent },
    Include = { fg = c.accent },
    Define = { fg = c.accent },
    Macro = { fg = c.link },
    PreCondit = { fg = c.accent },
    Type = { fg = c.text },
    StorageClass = { fg = c.accent },
    Structure = { fg = c.text },
    Typedef = { fg = c.accent },
    Special = { fg = c.link },
    SpecialChar = { fg = c.link },
    Tag = { fg = c.accent },
    Delimiter = { fg = c.text },
    SpecialComment = { fg = c.muted, bold = true },
    Debug = { fg = c.error },
    Underlined = { underline = true },
    Bold = { bold = true },
    Italic = { italic = true },
    Ignore = { fg = c.subtle },
    Error = { fg = c.error },
    Todo = { fg = c.base, bg = c.accent, bold = true },

    -- Treesitter -----------------------------------------------------------
    ["@variable"] = { fg = c.text },
    ["@variable.builtin"] = { fg = c.link },
    ["@variable.parameter"] = { fg = c.text },
    ["@variable.member"] = { fg = c.text },
    ["@constant"] = { fg = c.text },
    ["@constant.builtin"] = { fg = c.accent },
    ["@constant.macro"] = { fg = c.link },
    ["@module"] = { fg = c.text },
    ["@module.builtin"] = { fg = c.link },
    ["@label"] = { fg = c.accent },
    ["@string"] = { link = "String" },
    ["@string.documentation"] = { fg = c.muted, italic = true },
    ["@string.regexp"] = { fg = c.link },
    ["@string.escape"] = { fg = c.link },
    ["@string.special"] = { fg = c.link },
    ["@string.special.url"] = { fg = c.link, underline = true },
    ["@character"] = { link = "Character" },
    ["@character.special"] = { fg = c.link },
    ["@boolean"] = { link = "Boolean" },
    ["@number"] = { link = "Number" },
    ["@number.float"] = { link = "Float" },
    ["@type"] = { fg = c.text },
    ["@type.builtin"] = { fg = c.text },
    ["@type.definition"] = { fg = c.text },
    ["@attribute"] = { fg = c.link },
    ["@property"] = { fg = c.text },
    ["@function"] = { fg = c.text },
    ["@function.builtin"] = { fg = c.text },
    ["@function.call"] = { fg = c.text },
    ["@function.macro"] = { fg = c.link },
    ["@function.method"] = { fg = c.text },
    ["@function.method.call"] = { fg = c.text },
    ["@constructor"] = { fg = c.text },
    ["@operator"] = { fg = c.text },
    ["@keyword"] = { fg = c.accent },
    ["@keyword.coroutine"] = { fg = c.accent },
    ["@keyword.function"] = { fg = c.accent },
    ["@keyword.operator"] = { fg = c.accent },
    ["@keyword.import"] = { fg = c.accent },
    ["@keyword.type"] = { fg = c.accent },
    ["@keyword.modifier"] = { fg = c.accent },
    ["@keyword.repeat"] = { fg = c.accent },
    ["@keyword.return"] = { fg = c.accent },
    ["@keyword.exception"] = { fg = c.accent },
    ["@keyword.conditional"] = { fg = c.accent },
    ["@keyword.directive"] = { fg = c.accent },
    ["@punctuation.delimiter"] = { fg = c.text },
    ["@punctuation.bracket"] = { fg = c.text },
    ["@punctuation.special"] = { fg = c.link },
    ["@comment"] = { link = "Comment" },
    ["@comment.documentation"] = { link = "Comment" },
    ["@comment.error"] = { fg = c.base, bg = c.error, bold = true },
    ["@comment.warning"] = { fg = c.base, bg = c.amber, bold = true },
    ["@comment.todo"] = { fg = c.base, bg = c.accent, bold = true },
    ["@comment.note"] = { fg = c.base, bg = c.muted, bold = true },
    ["@markup.strong"] = { bold = true },
    ["@markup.italic"] = { italic = true },
    ["@markup.strikethrough"] = { strikethrough = true },
    ["@markup.underline"] = { underline = true },
    ["@markup.heading"] = { fg = c.accent, bold = true },
    ["@markup.quote"] = { fg = c.muted, italic = true },
    ["@markup.math"] = { fg = c.link },
    ["@markup.link"] = { fg = c.link },
    ["@markup.link.label"] = { fg = c.link },
    ["@markup.link.url"] = { fg = c.link, underline = true },
    ["@markup.raw"] = { fg = c.success },
    ["@markup.list"] = { fg = c.accent },
    ["@markup.list.checked"] = { fg = c.success },
    ["@markup.list.unchecked"] = { fg = c.muted },
    ["@diff.plus"] = { fg = c.success },
    ["@diff.minus"] = { fg = c.error },
    ["@diff.delta"] = { fg = c.link },
    ["@tag"] = { fg = c.accent },
    ["@tag.builtin"] = { fg = c.accent },
    ["@tag.attribute"] = { fg = c.text },
    ["@tag.delimiter"] = { fg = c.muted },

    -- LSP ------------------------------------------------------------------
    LspReferenceText = { bg = c.overlay },
    LspReferenceRead = { bg = c.overlay },
    LspReferenceWrite = { bg = c.overlay, underline = true },
    LspInlayHint = { fg = c.subtle, italic = true },
    LspCodeLens = { fg = c.muted },
    LspSignatureActiveParameter = { fg = c.accent, bold = true },
    LspInfoBorder = { link = "FloatBorder" },
    ["@lsp.type.namespace"] = { link = "@module" },
    ["@lsp.type.parameter"] = { link = "@variable.parameter" },
    ["@lsp.type.property"] = { link = "@property" },
    ["@lsp.type.variable"] = {}, -- let treesitter decide
    ["@lsp.mod.deprecated"] = { strikethrough = true },

    -- Diagnostics ----------------------------------------------------------
    DiagnosticError = { fg = c.error },
    DiagnosticWarn = { fg = c.amber },
    DiagnosticInfo = { fg = c.link },
    DiagnosticHint = { fg = c.muted },
    DiagnosticOk = { fg = c.success },
    DiagnosticUnderlineError = { sp = c.error, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.amber, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.link, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.muted, undercurl = true },
    DiagnosticUnderlineOk = { sp = c.success, undercurl = true },
    DiagnosticVirtualTextError = { fg = c.error, bg = blend(c.error, c.base, 0.10) },
    DiagnosticVirtualTextWarn = { fg = c.amber, bg = blend(c.amber, c.base, 0.10) },
    DiagnosticVirtualTextInfo = { fg = c.link, bg = blend(c.link, c.base, 0.10) },
    DiagnosticVirtualTextHint = { fg = c.muted, bg = c.surface },
    DiagnosticVirtualTextOk = { fg = c.success, bg = blend(c.success, c.base, 0.10) },
    DiagnosticUnnecessary = { fg = c.muted },
    DiagnosticDeprecated = { strikethrough = true },

    -- Git signs ------------------------------------------------------------
    GitSignsAdd = { fg = c.success },
    GitSignsChange = { fg = c.link },
    GitSignsDelete = { fg = c.error },
    GitSignsCurrentLineBlame = { fg = c.subtle },

    -- Snacks (picker, dashboard, notifier, indent, input) -----------------
    SnacksIndent = { fg = c.overlay },
    SnacksIndentScope = { fg = c.subtle },
    SnacksDashboardHeader = { fg = c.accent },
    SnacksDashboardIcon = { fg = c.accent },
    SnacksDashboardKey = { fg = c.accent, bold = true },
    SnacksDashboardDesc = { fg = c.text },
    SnacksDashboardFooter = { fg = c.muted },
    SnacksDashboardSpecial = { fg = c.link },
    SnacksPicker = { link = "NormalFloat" },
    SnacksPickerBorder = { link = "FloatBorder" },
    SnacksPickerTitle = { link = "FloatTitle" },
    SnacksPickerMatch = { fg = c.accent, bold = true },
    SnacksPickerPrompt = { fg = c.accent },
    SnacksPickerSelected = { fg = c.accent },
    SnacksPickerDir = { fg = c.muted },
    SnacksPickerTotals = { fg = c.muted },
    SnacksPickerListCursorLine = { bg = c.overlay },
    SnacksInputBorder = { fg = c.accent, bg = c.surface },
    SnacksInputTitle = { fg = c.accent, bg = c.surface, bold = true },
    SnacksNotifierError = { fg = c.error },
    SnacksNotifierWarn = { fg = c.amber },
    SnacksNotifierInfo = { fg = c.link },
    SnacksNotifierBorderError = { fg = c.error },
    SnacksNotifierBorderWarn = { fg = c.amber },
    SnacksNotifierBorderInfo = { fg = c.border },
    SnacksNotifierTitleError = { fg = c.error, bold = true },
    SnacksNotifierTitleWarn = { fg = c.amber, bold = true },
    SnacksNotifierTitleInfo = { fg = c.accent, bold = true },

    -- blink.cmp ------------------------------------------------------------
    BlinkCmpMenu = { link = "Pmenu" },
    BlinkCmpMenuBorder = { link = "FloatBorder" },
    BlinkCmpMenuSelection = { link = "PmenuSel" },
    BlinkCmpLabelMatch = { fg = c.accent, bold = true },
    BlinkCmpLabelDeprecated = { fg = c.muted, strikethrough = true },
    BlinkCmpLabelDetail = { fg = c.muted },
    BlinkCmpLabelDescription = { fg = c.muted },
    BlinkCmpKind = { fg = c.accent },
    BlinkCmpSource = { fg = c.muted },
    BlinkCmpDoc = { link = "NormalFloat" },
    BlinkCmpDocBorder = { link = "FloatBorder" },
    BlinkCmpSignatureHelpBorder = { link = "FloatBorder" },

    -- which-key ------------------------------------------------------------
    WhichKey = { fg = c.accent },
    WhichKeyGroup = { fg = c.link },
    WhichKeyDesc = { fg = c.text },
    WhichKeySeparator = { fg = c.subtle },
    WhichKeyValue = { fg = c.muted },
    WhichKeyBorder = { link = "FloatBorder" },
    WhichKeyNormal = { link = "NormalFloat" },
    WhichKeyTitle = { link = "FloatTitle" },

    -- noice ----------------------------------------------------------------
    NoiceCmdlinePopupBorder = { fg = c.accent },
    NoiceCmdlinePopupTitle = { fg = c.accent, bold = true },
    NoiceCmdlineIcon = { fg = c.accent },
    NoiceCmdlinePopupBorderSearch = { fg = c.link },
    NoiceCmdlineIconSearch = { fg = c.link },
    NoiceConfirmBorder = { fg = c.accent },

    -- flash ----------------------------------------------------------------
    FlashLabel = { fg = c.base, bg = c.accent, bold = true },
    FlashMatch = { fg = c.text, bg = c.overlay },
    FlashCurrent = { fg = c.base, bg = c.link },
    FlashBackdrop = { fg = c.subtle },

    -- mini.files / mini.icons ---------------------------------------------
    MiniFilesBorder = { link = "FloatBorder" },
    MiniFilesBorderModified = { fg = c.accent, bg = c.surface },
    MiniFilesDirectory = { fg = c.accent },
    MiniFilesFile = { fg = c.text },
    MiniFilesNormal = { link = "NormalFloat" },
    MiniFilesTitle = { fg = c.muted, bg = c.surface },
    MiniFilesTitleFocused = { fg = c.accent, bg = c.surface, bold = true },
    MiniFilesCursorLine = { bg = c.overlay },
    MiniIconsAzure = { fg = c.muted },
    MiniIconsBlue = { fg = c.accent },
    MiniIconsCyan = { fg = c.muted },
    MiniIconsGreen = { fg = c.success },
    MiniIconsGrey = { fg = c.muted },
    MiniIconsOrange = { fg = c.accent },
    MiniIconsPurple = { fg = c.link },
    MiniIconsRed = { fg = c.error },
    MiniIconsYellow = { fg = c.amber },

    -- trouble / todo-comments ---------------------------------------------
    TroubleNormal = { fg = c.text, bg = c.base },
    TroubleNormalNC = { fg = c.text, bg = c.base },
    TodoBgTODO = { fg = c.base, bg = c.accent, bold = true },
    TodoFgTODO = { fg = c.accent },
    TodoBgFIX = { fg = c.base, bg = c.error, bold = true },
    TodoFgFIX = { fg = c.error },
    TodoBgWARN = { fg = c.base, bg = c.amber, bold = true },
    TodoFgWARN = { fg = c.amber },
    TodoBgNOTE = { fg = c.base, bg = c.success, bold = true },
    TodoFgNOTE = { fg = c.success },
    TodoBgHACK = { fg = c.base, bg = c.link, bold = true },
    TodoFgHACK = { fg = c.link },
    TodoBgPERF = { fg = c.base, bg = c.muted, bold = true },
    TodoFgPERF = { fg = c.muted },
    TodoBgTEST = { fg = c.base, bg = c.muted, bold = true },
    TodoFgTEST = { fg = c.muted },

    -- render-markdown ------------------------------------------------------
    RenderMarkdownCode = { bg = c.surface },
    RenderMarkdownCodeInline = { fg = c.success, bg = c.surface },
    RenderMarkdownH1Bg = { bg = blend(c.accent, c.base, 0.18) },
    RenderMarkdownH2Bg = { bg = blend(c.accent, c.base, 0.12) },
    RenderMarkdownH3Bg = { bg = blend(c.accent, c.base, 0.08) },
    RenderMarkdownH4Bg = { bg = c.surface },
    RenderMarkdownH5Bg = { bg = c.surface },
    RenderMarkdownH6Bg = { bg = c.surface },

    -- lazy.nvim / mason ----------------------------------------------------
    LazyH1 = { fg = c.base, bg = c.accent, bold = true },
    LazyButton = { fg = c.text, bg = c.overlay },
    LazyButtonActive = { fg = c.base, bg = c.accent, bold = true },
    LazySpecial = { fg = c.accent },
    LazyProgressDone = { fg = c.accent },
    LazyProgressTodo = { fg = c.overlay },
    LazyReasonPlugin = { fg = c.link },
    MasonHeader = { fg = c.base, bg = c.accent, bold = true },
    MasonHighlight = { fg = c.accent },
    MasonHighlightBlockBold = { fg = c.base, bg = c.accent, bold = true },
    MasonMutedBlock = { fg = c.text, bg = c.overlay },
  }
end

function M.load()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "asiimov"

  local c = M.colors()
  for group, spec in pairs(M.highlights(c)) do
    vim.api.nvim_set_hl(0, group, spec)
  end

  -- :terminal buffers use the same ANSI palette as the Ghostty theme.
  local term = vim.o.background == "light"
      and { "#1c1c1c", "#c8102e", "#23803f", "#a86400", "#e85400", "#b33a00", "#4d5357", "#a3a8ac",
            "#6c7176", "#e0314d", "#2e9a4f", "#c27a0a", "#ff6a1a", "#d14f10", "#6c7176", "#bfc4c7" }
    or { "#2c2f31", "#ff4d6a", "#5fcf7d", "#ffb547", "#ff5a00", "#ff8a3d", "#b8bec2", "#e6e8e9",
         "#8a8f93", "#ff7a90", "#8ae0a0", "#ffc874", "#ff7a2e", "#ffab73", "#d5d9dc", "#ffffff" }
  for i, color in ipairs(term) do
    vim.g["terminal_color_" .. (i - 1)] = color
  end
end

return M
