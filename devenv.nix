{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  devcontainer = {
    enable = true;
    settings = {
      customizations.vscode.extensions = [
        "Anthropic.claude-code"
        "mkhl.direnv"
        "EditorConfig.EditorConfig"
        "usernamehw.errorlens"
        "DavidAnson.vscode-markdownlint"
        "Gruntfuggly.triggertaskonsave"
      ];
      # would need a postCreateCommand to clone the repo to use this
      # workspaceMount = "source=volume-name,target=/workspace/vscode-devenv,type=volume";
    };
  };

  # https://devenv.sh/basics/
  env.GREET = "devenv";

  # https://devenv.sh/packages/
  packages = with pkgs; [
    git
    vim
  ];

  # https://devenv.sh/languages/
  languages.javascript.enable = true;

  # https://devenv.sh/processes/
  processes.dev.exec = "${lib.getExe pkgs.watchexec} -n -- ls -la";

  # https://devenv.sh/services/
  services.postgres = {
    enable = true;
    initialScript = ''
      CREATE ROLE vscode WITH LOGIN SUPERUSER;
    '';
  };

  # https://devenv.sh/scripts/
  scripts.hello.exec = ''
    echo hello from $GREET
  '';

  # https://devenv.sh/basics/
  enterShell = ''
    hello         # Run scripts directly
    git --version # Use packages
  '';

  # https://devenv.sh/tasks/
  # tasks = {
  #   "myproj:setup".exec = "mytool build";
  #   "devenv:enterShell".after = [ "myproj:setup" ];
  # };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    git --version | grep --color=auto "${pkgs.git.version}"
  '';

  # https://devenv.sh/git-hooks/
  git-hooks.hooks = {
    nixfmt.enable = true;
    shellcheck.enable = true;
  };

  # See full reference at https://devenv.sh/reference/options/
}
