{ pkgs, ... }: {
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "get-nvim" ''
      set -e

      # 1. Define Variables
      NVIM_CONFIG_DIR="$HOME/.config/nvim"
      REPO_URL="https://github.com/MagicBOTAlex/NVimConfigs"

      # 2. Delete Existing Config
      if [ -d "$NVIM_CONFIG_DIR" ]; then
        echo "🗑️  Deleting existing Neovim configuration at $NVIM_CONFIG_DIR..."
        rm -rf "$NVIM_CONFIG_DIR"
      fi

      # 3. Clone Fresh
      echo "⚙️  Cloning new Neovim Configs..."
      git clone "$REPO_URL" "$NVIM_CONFIG_DIR"

      echo "✅ Done!"
    '')
  ];
}

