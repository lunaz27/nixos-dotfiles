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

      nixd = {
        settings = {
          nixd = {
            nixpkgs = {
              expr = "import (builtins.getFlake (toString ./.)).inputs.nixpkgs { }",
            },

            options = {
              nixos = {
                expr = "(builtins.getFlake (toString ./.)).nixosConfigurations."
                  .. vim.uv.os_gethostname()
                  .. ".options",
              },
              home_manager = {
                expr = "(builtins.getFlake (toString ./.)).nixosConfigurations."
                  .. vim.uv.os_gethostname()
                  .. ".options.home-manager.users.type.getSubOptions",
              },
            },
          },
        },
      },

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

      asm_lsp = {},
    },
  },
}
