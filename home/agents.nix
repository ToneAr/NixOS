{ inputs, ... }:

{
  imports = [ inputs.hermes-agent.homeManagerModules.default ];

  programs.hermes-agent.enable = true;
  services.hermes-agent = {
      enable = true;
      gateway.enable = true;
    };

  home.file = let rules = ../assets/agents/AGENTS.md; in {
    ".config/agents/AGENTS.md".source = rules;
    ".codex/AGENTS.md".source = rules;
    ".gemini/GEMINI.md".source = rules;
    ".claude/CLAUDE.md".text = "@~/.config/agents/AGENTS.md\n";
  };
}
