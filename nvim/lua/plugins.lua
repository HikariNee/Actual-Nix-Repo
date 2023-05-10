require("lazy").setup({
	"tpope/vim-sleuth",
	{
		'neovim/nvim-lspconfig',
	},
	{'j-hui/fidget.nvim', opts = {}},
	'hrsh7th/nvim-cmp',
	'hrsh7th/cmp-nvim-lsp',
	'L3MON4D3/LuaSnip',
	'saadparwaiz1/cmp_luasnip',
	{
		'nvim-lualine/lualine.nvim',
	},
        { 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
	{ -- Highlight, edit, and navigate code
    		'nvim-treesitter/nvim-treesitter',
    		dependencies = {
      			'nvim-treesitter/nvim-treesitter-textobjects',
    		},
    		build = ":TSUpdate",
  	},
	'Alexis12119/nightly.nvim', 
	'olivercederborg/poimandres.nvim',
	'nanozuki/tabby.nvim',
	'goolord/alpha-nvim',
	'lewis6991/gitsigns.nvim',
	'phaazon/hop.nvim',
	'windwp/nvim-autopairs',
	'neovimhaskell/haskell-vim',
	'sbdchd/neoformat'

})

require("poimandres").setup({})



vim.cmd "colorscheme poimandres"
require("lualine").setup{options = {theme = 'poimandres'}}
require("nvim-autopairs").setup{}
