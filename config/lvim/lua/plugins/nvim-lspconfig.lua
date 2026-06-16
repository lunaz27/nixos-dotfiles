return {
  "neovim/nvim-lspconfig",

  opts = {
    servers = {
      lua_ls = {
        settings = {
          Lua = {
            workspace = {
              checkThirdParty = false,
              library = vim.api.nvim_get_runtime_file("", true),
            },

            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      },

      svls = {},

      nixd = {},

      arduino_language_server = {
        cmd = {
          "arduino-language-server",
          "-cli-config",
          os.getenv("HOME") .. "/.arduino15/arduino-cli.yaml",
          "-fqbn",
          "arduino:avr:uno",
        },
      },

      just = {},

      mesonlsp = {},
    },
  },
}
