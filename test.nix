{ ctp
, inputs
, ...
}:
let
  common = {
    catppuccin.flavour = "mocha";
    users.users.test = {
      isNormalUser = true;
      home = "/home/test";
    };
  };

  ctpEnable = {
    enable = true;
    catppuccin.enable = true;
  };
in
{
  name = "module-test";

  nodes.machine = { lib, ... }: {
    imports = [
      ctp.nixosModules.catppuccin
      inputs.home-manager.nixosModules.default
      common
    ];

    boot.loader.grub = ctpEnable;

    console = ctpEnable;

    programs.dconf.enable = true; # required for gtk

    virtualisation = {
      memorySize = 4096;
      writableStore = true;
    };

    home-manager.users.test = {
      imports = [
        ctp.homeManagerModules.catppuccin
      ];

      inherit (common) catppuccin;

      xdg.enable = true;

      home = {
        username = "test";
        stateVersion = lib.mkDefault "23.11";
      };

      manual.manpages.enable = lib.mkDefault false;

      i18n.inputMethod = {
        enabled = "fcitx5";
        fcitx5.catppuccin.enable = true;
      };

      programs = {
        alacritty = ctpEnable;
        bat = ctpEnable;
        bottom = ctpEnable;
        btop = ctpEnable;
        cava = ctpEnable;
        fish = ctpEnable;
        foot = ctpEnable;
        fzf = ctpEnable;
        git.enable = true; # Required for delta
        git.delta = ctpEnable;
        gitui = ctpEnable;
        glamour.catppuccin.enable = true;
        helix = ctpEnable;
        home-manager.enable = false;
        imv = ctpEnable;
        k9s = ctpEnable;
        kitty = ctpEnable;
        lazygit = ctpEnable;
        micro = ctpEnable;
        mpv = ctpEnable;
        neovim = ctpEnable;
        rio = ctpEnable;
        rofi = ctpEnable;
        starship = ctpEnable;
        swaylock = ctpEnable;
        tmux = ctpEnable;
        yazi = ctpEnable;
        zathura = ctpEnable;
      };

      gtk = lib.recursiveUpdate ctpEnable { catppuccin.cursor.enable = true; };

      services = {
        dunst = ctpEnable;
        mako = ctpEnable;
        polybar =
          ctpEnable
          // {
            script = ''
              polybar top &
            '';
          };
      };

      wayland.windowManager.sway = ctpEnable;
      wayland.windowManager.hyprland = ctpEnable;
    };
  };

  testScript = _: ''
    machine.start()
    machine.wait_for_unit("home-manager-test.service")
    machine.wait_until_succeeds("systemctl status home-manager-test.service")
    machine.succeed("echo \"system started!\"")
  '';
}
