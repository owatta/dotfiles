{ inputs, lib, config, pkgs, ... }:

# TODO: figure out a way to keep the emacs config there

{ imports = [];
  home = { username = "alto"; homeDirectory = "/home/alto";
  };

  # link the configuration file in current directory to the specified
  # location in home directory
  # home.file.".emacs.d" = { source = ./emacs; recursive = true; };

  programs.git = {
    enable = true;
    userName = "owatta";
    userEmail = "arsenii.korniec@bk.ru";
  };

  # Packages
  home.packages = with pkgs; [
      emacs
      glamoroustoolkit

      gopls
      rust-analyzer
      sbcl

      mpv
      yt-dlp

      texliveFull
      pandoc

      firefox
      telegram-desktop
      qbittorrent

    ];

    programs.bash = { enable = true; enableCompletion = true; };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage when a
  # new home Manager release introduces backwards incompatible
  # changes.  You can update home Manager without changing this
  # value. See the home Manager release notes for a list of state
  # version changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}