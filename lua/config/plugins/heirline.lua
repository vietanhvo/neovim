return {
	"rebelot/heirline.nvim",
	lazy = false,
	dependencies = {
		"echasnovski/mini.icons",
		"neovim/nvim-lspconfig",
	},
	config = function()
		local heirline = require("heirline")
		local conditions = require("heirline.conditions")
		local utils = require("heirline.utils")
		local colors = require("catppuccin.palettes").get_palette()

		conditions.buffer_not_empty = function()
			return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
		end

		conditions.hide_in_width = function(size)
			return vim.api.nvim_get_option_value("columns", { scope = "local" }) > (size or 140)
		end

		-- Status line
		local Align = { provider = "%=", hl = { bg = colors.crust } }
		local Space = { provider = " " }

		local ViMode = {
			{
				init = function(self)
					self.mode = vim.api.nvim_get_mode().mode
					if not self.once then
						vim.api.nvim_create_autocmd("ModeChanged", {
							pattern = "*:*o",
							command = "redrawstatus",
						})
						self.once = true
					end
				end,
				static = {
					MODE_NAMES = {
						["!"] = "SHELL",
						["R"] = "REPLACE",
						["Rc"] = "REPLACE",
						["Rv"] = "V-REPLACE",
						["Rvc"] = "V-REPLACE",
						["Rvx"] = "V-REPLACE",
						["Rx"] = "REPLACE",
						["S"] = "S-LINE",
						["V"] = "V-LINE",
						["Vs"] = "V-LINE",
						["\19"] = "S-BLOCK",
						["\22"] = "V-BLOCK",
						["\22s"] = "V-BLOCK",
						["c"] = "COMMAND",
						["ce"] = "EX",
						["cv"] = "EX",
						["i"] = "INSERT",
						["ic"] = "INSERT",
						["ix"] = "INSERT",
						["n"] = "NORMAL",
						["niI"] = "NORMAL",
						["niR"] = "NORMAL",
						["niV"] = "NORMAL",
						["no"] = "O-PENDING",
						["noV"] = "O-PENDING",
						["no\22"] = "O-PENDING",
						["nov"] = "O-PENDING",
						["nt"] = "NORMAL",
						["ntT"] = "NORMAL",
						["r"] = "REPLACE",
						["r?"] = "CONFIRM",
						["rm"] = "MORE",
						["s"] = "SELECT",
						["t"] = "TERMINAL",
						["v"] = "VISUAL",
						["vs"] = "VISUAL",
					},
					MODE_COLORS = {
						[""] = colors.yellow,
						[""] = colors.yellow,
						["s"] = colors.yellow,
						["!"] = colors.maroon,
						["R"] = colors.flamingo,
						["Rc"] = colors.flamingo,
						["Rv"] = colors.rosewater,
						["Rx"] = colors.flamingo,
						["S"] = colors.teal,
						["V"] = colors.lavender,
						["Vs"] = colors.lavender,
						["c"] = colors.peach,
						["ce"] = colors.peach,
						["cv"] = colors.peach,
						["i"] = colors.green,
						["ic"] = colors.green,
						["ix"] = colors.green,
						["n"] = colors.blue,
						["niI"] = colors.blue,
						["niR"] = colors.blue,
						["niV"] = colors.blue,
						["no"] = colors.pink,
						["no"] = colors.pink,
						["noV"] = colors.pink,
						["nov"] = colors.pink,
						["nt"] = colors.red,
						["null"] = colors.pink,
						["r"] = colors.teal,
						["r?"] = colors.maroon,
						["rm"] = colors.sky,
						["s"] = colors.teal,
						["t"] = colors.red,
						["v"] = colors.mauve,
						["vs"] = colors.mauve,
					},
				},
				provider = function(self)
					local mode = self.mode:sub(1, 1)
					return string.format("▌ %s ", self.MODE_NAMES[mode])
				end,
				hl = function(self)
					local mode = self.mode:sub(1, 1)
					return { fg = self.MODE_COLORS[mode], bg = colors.mantle, bold = true }
				end,
				update = {
					"ModeChanged",
				},
			},
			{
				provider = "",
				hl = { bg = colors.crust, fg = colors.mantle },
			},
		}
		local FileNameBlock = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(0)
			end,
			condition = conditions.buffer_not_empty,
			hl = { bg = colors.crust, fg = colors.subtext1 },
		}

		local FileIcon = {
			init = function(self)
				local filename = self.filename
				local extension = vim.fn.fnamemodify(filename, ":e")
				self.icon, self.icon_color =
					require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })
			end,
			provider = function(self)
				return self.icon and (self.icon .. " ")
			end,
			hl = function(self)
				return { fg = self.icon_color }
			end,
		}

		local FileName = {
			provider = function(self)
				local filename = vim.fn.fnamemodify(self.filename, ":t")
				if filename == "" then
					return "[No Name]"
				end
				if not conditions.width_percent_below(#filename, 0.25) then
					filename = vim.fn.pathshorten(filename)
				end
				return filename
			end,
			hl = { fg = colors.subtext1, bold = true },
		}

		local FileFlags = {
			{
				condition = function()
					return vim.bo.modified
				end,
				provider = " ● ",
				hl = { fg = colors.lavender },
			},
			{
				condition = function()
					return not vim.bo.modifiable or vim.bo.readonly
				end,
				provider = "",
				hl = { fg = colors.red },
			},
		}

		local FileNameModifer = {
			hl = function()
				if vim.bo.modified then
					return { fg = colors.text, bold = true, force = true }
				end
			end,
		}

		FileNameBlock = utils.insert(
			FileNameBlock,
			FileIcon,
			utils.insert(FileNameModifer, FileName),
			FileFlags,
			{ provider = "%<" }
		)

		local FileType = {
			provider = function()
				return (" %s "):format(vim.bo.filetype)
			end,
			hl = { bg = colors.crust, fg = colors.overlay0 },
			condition = function()
				return conditions.buffer_not_empty() and conditions.hide_in_width()
			end,
		}

		local FileSize = {
			provider = function()
				local suffix = { "b", "k", "M", "G", "T", "P", "E" }
				local fsize = vim.fn.getfsize(vim.api.nvim_buf_get_name(0))
				fsize = (fsize < 0 and 0) or fsize
				if fsize < 1024 then
					return string.format(" %s ", fsize .. suffix[1])
				end

				local i = 0
				if fsize ~= nil then
					i = math.floor((math.log(fsize) / math.log(1024)))
				end

				return string.format(" %.2g%s ", fsize / math.pow(1024, i), suffix[i + 1])
			end,
			hl = { bg = colors.crust, fg = colors.overlay0 },
			condition = function()
				return conditions.buffer_not_empty() and conditions.hide_in_width()
			end,
		}

		local LSPActive = {
			condition = function()
				return conditions.hide_in_width(120) and conditions.lsp_attached()
			end,
			update = { "LspAttach", "LspDetach" },
			on_click = {
				callback = function()
					vim.defer_fn(function()
						vim.cmd("LspInfo")
					end, 100)
				end,
				name = "heirline_LSP",
			},
			provider = function()
				local names = {}
				for _, server in pairs(vim.lsp.get_clients()) do
					table.insert(names, server.name)
				end

				if #names == 0 then
					return ""
				end

				return ("  %s "):format(table.concat(names, " "))
			end,
			hl = { bg = colors.crust, fg = colors.subtext1, bold = true, italic = false },
		}

		local Linters = {
			provider = function()
				local linters = require("lint")._resolve_linter_by_ft(vim.bo.filetype)

				if #linters == 0 then
					return ""
				end

				return ("  %s "):format(table.concat(linters, " "))
			end,
			hl = { bg = colors.crust, fg = colors.overlay0 },
			condition = function()
				return conditions.buffer_not_empty() and conditions.hide_in_width()
			end,
		}

		local Formatters = {
			provider = function()
				local formatters = {}
				for _, formatter in pairs(require("conform").list_formatters()) do
					if formatter.available then
						table.insert(formatters, formatter.name)
					end
				end

				if #formatters == 0 then
					return ""
				end

				return ("  %s "):format(table.concat(formatters, " "))
			end,
			on_click = {
				callback = function()
					vim.defer_fn(function() end, 100)
				end,
				name = "heirline_Formatters",
			},
			hl = { bg = colors.crust, fg = colors.overlay0 },
			condition = function()
				return conditions.buffer_not_empty() and conditions.hide_in_width()
			end,
		}

		local Diagnostics = {
			condition = function()
				return conditions.buffer_not_empty() and conditions.hide_in_width() and conditions.has_diagnostics()
			end,

			error_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.ERROR],
			warn_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.WARN],
			info_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.INFO],
			hint_icon = vim.diagnostic.config()["signs"]["text"][vim.diagnostic.severity.HINT],

			init = function(self)
				self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
				self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
				self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
				self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
			end,
			update = { "DiagnosticChanged", "BufEnter" },
			hl = { bg = colors.crust },
			Space,
			{
				provider = function(self)
					return self.errors > 0 and ("%s%s "):format(self.error_icon, self.errors)
				end,
				hl = { fg = colors.red },
			},
			{
				provider = function(self)
					return self.warnings > 0 and ("%s%s "):format(self.warn_icon, self.warnings)
				end,
				hl = { fg = colors.yellow },
			},
			{
				provider = function(self)
					return self.info > 0 and ("%s%s "):format(self.info_icon, self.info)
				end,
				hl = { fg = colors.sapphire },
			},
			{
				provider = function(self)
					return self.hints > 0 and ("%s%s "):format(self.hint_icon, self.hints)
				end,
				hl = { fg = colors.sky },
			},
			Space,
		}

		local Git = {
			condition = conditions.is_git_repo,
			init = function(self)
				self.status_dict = vim.b.gitsigns_status_dict
				self.has_changes = self.status_dict.added ~= 0
					or self.status_dict.removed ~= 0
					or self.status_dict.changed ~= 0
			end,
			hl = { bg = colors.mantle },
			{
				provider = "",
				hl = { bg = colors.crust, fg = colors.mantle },
			},
			{
				provider = function(self)
					return ("  %s"):format(self.status_dict.head == "" and "~" or self.status_dict.head)
				end,
				hl = { fg = colors.mauve },
			},
			{
				provider = function(self)
					local count = self.status_dict.added or 0
					return count > 0 and ("  %s"):format(count)
				end,
				hl = { fg = colors.green },
				condition = function()
					return conditions.buffer_not_empty() and conditions.hide_in_width()
				end,
			},
			{
				provider = function(self)
					local count = self.status_dict.removed or 0
					return count > 0 and ("  %s"):format(count)
				end,
				hl = { fg = colors.red },
				condition = function()
					return conditions.buffer_not_empty() and conditions.hide_in_width()
				end,
			},
			{
				provider = function(self)
					local count = self.status_dict.changed or 0
					return count > 0 and ("  %s"):format(count)
				end,
				hl = { fg = colors.peach },
				condition = function()
					return conditions.buffer_not_empty() and conditions.hide_in_width()
				end,
			},
			Space,
		}

		local FileFormat = {
			provider = function()
				local fmt = vim.bo.fileformat
				if fmt == "unix" then
					return " LF "
				elseif fmt == "mac" then
					return " CR "
				else
					return " CRLF "
				end
			end,
			hl = { bg = colors.crust, fg = colors.overlay0 },
			condition = function()
				return conditions.buffer_not_empty() and conditions.hide_in_width()
			end,
		}

		local FileEncoding = {
			provider = function()
				local enc = (vim.bo.fenc ~= "" and vim.bo.fenc) or vim.o.enc
				return (" %s "):format(enc:upper())
			end,
			condition = function()
				return conditions.buffer_not_empty() and conditions.hide_in_width()
			end,
			hl = { bg = colors.crust, fg = colors.overlay0 },
		}

		local IndentSizes = {
			provider = function()
				local indent_type = vim.api.nvim_get_option_value("expandtab", { scope = "local" }) and "Spaces"
					or "Tab Size"
				local indent_size = vim.api.nvim_get_option_value("tabstop", { scope = "local" })

				return (" %s: %s "):format(indent_type, indent_size)
			end,
			hl = { bg = colors.crust, fg = colors.overlay0 },
			condition = function()
				return conditions.buffer_not_empty() and conditions.hide_in_width()
			end,
		}

		local HelpFileName = {
			condition = function()
				return vim.bo.filetype == "help"
			end,
			provider = function()
				local filename = vim.api.nvim_buf_get_name(0)
				return vim.fn.fnamemodify(filename, ":t")
			end,
			hl = { fg = colors.blue },
		}

		local SpecialStatusline = {
			condition = function()
				return conditions.buffer_matches({
					buftype = { "nofile", "prompt", "help", "quickfix" },
					filetype = { "^git.*", "fugitive" },
				})
			end,

			FileType,
			Space,
			HelpFileName,
			FileFlags,
			Align,
		}

		local DefaultStatusline = {
			ViMode,
			FileNameBlock,
			FileType,
			FileSize,
			Align,
			LSPActive,
			Linters,
			Formatters,
			Diagnostics,
			FileFormat,
			FileEncoding,
			IndentSizes,
			Git,
		}

		local StatusLines = {
			hl = function()
				if conditions.is_active() then
					return "StatusLine"
				else
					return "StatusLineNC"
				end
			end,

			fallthrough = false,

			SpecialStatusline,
			DefaultStatusline,
		}

		local TablineBufnr = {
			provider = function(self)
				return tostring(self.bufnr) .. ". "
			end,
			hl = "Comment",
		}

		local TablineFileName = {
			provider = function(self)
				local filename = self.filename
				filename = filename == "" and "[No Name]" or vim.fn.fnamemodify(filename, ":t")
				return filename
			end,
			hl = function()
				return { italic = true }
			end,
		}

		local TablineFileFlags = {
			{
				condition = function(self)
					return vim.api.nvim_get_option_value("modified", { buf = self.bufnr })
				end,
				provider = "[+]",
				hl = { fg = "green" },
			},
			{
				condition = function(self)
					return not vim.api.nvim_get_option_value("modifiable", { buf = self.bufnr })
						or vim.api.nvim_get_option_value("readonly", { buf = self.bufnr })
				end,
				provider = function(self)
					if vim.api.nvim_get_option_value("buftype", { buf = self.bufnr }) == "terminal" then
						return "  "
					else
						return ""
					end
				end,
				hl = { fg = "orange" },
			},
		}

		local TablineFileNameBlock = {
			init = function(self)
				self.filename = vim.api.nvim_buf_get_name(self.bufnr)
			end,
			hl = function(self)
				if self.is_active then
					return "TabLineSel"
				else
					return "TabLine"
				end
			end,
			on_click = {
				callback = function(_, minwid, _, button)
					if button == "m" then
						vim.schedule(function()
							vim.api.nvim_buf_delete(minwid, { force = false })
						end)
					else
						vim.api.nvim_win_set_buf(0, minwid)
					end
				end,
				minwid = function(self)
					return self.bufnr
				end,
				name = "heirline_tabline_buffer_callback",
			},
			TablineBufnr,
			FileIcon,
			TablineFileName,
			TablineFileFlags,
		}

		local TablineBufferBlock = utils.surround({ "", "" }, function(self)
			if self.is_active then
				return utils.get_highlight("TabLineSel").bg
			else
				return utils.get_highlight("TabLine").bg
			end
		end, { TablineFileNameBlock })

		local BufferLine = utils.make_buflist(
			TablineBufferBlock,
			{ provider = "", hl = { fg = "gray" } },
			{ provider = "", hl = { fg = "gray" } }
		)

		local Tabpage = {
			provider = function(self)
				return "%" .. self.tabnr .. "T " .. self.tabpage .. " %T"
			end,
			hl = function(self)
				if not self.is_active then
					return "TabLine"
				else
					return "TabLineSel"
				end
			end,
		}

		local TabPages = {
			-- only show this component if there's 2 or more tabpages
			condition = function()
				return #vim.api.nvim_list_tabpages() >= 2
			end,
			{ provider = "%=" },
			utils.make_tablist(Tabpage),
		}

		local TabLineOffset = {
			condition = function(self)
				local win = vim.api.nvim_tabpage_list_wins(0)[1]
				local bufnr = vim.api.nvim_win_get_buf(win)
				self.winid = win

				if vim.bo[bufnr].filetype == "NvimTree" then
					self.title = "NvimTree"
					return true
				end
			end,

			provider = function(self)
				local title = self.title
				local width = vim.api.nvim_win_get_width(self.winid)
				local pad = math.ceil((width - #title) / 2)
				return string.rep(" ", pad) .. title .. string.rep(" ", pad)
			end,

			hl = function(self)
				if vim.api.nvim_get_current_win() == self.winid then
					return "TablineSel"
				else
					return "Tabline"
				end
			end,
		}

		local TabLine = { TabLineOffset, BufferLine, TabPages }

		-- Setup
		heirline.setup({
			statusline = StatusLines,
			tabline = TabLine,
		})

		vim.o.showtabline = 2
		vim.cmd([[au FileType * if index(['wipe', 'delete'], &bufhidden) >= 0 | set nobuflisted | endif]])
	end,
}
