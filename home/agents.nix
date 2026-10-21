{
  home.file = let rules = ../assets/agents/AGENTS.md; in {
    ".config/agents/AGENTS.md".source = rules;
    ".codex/AGENTS.md".source = rules;
    ".gemini/GEMINI.md".source = rules;
    ".claude/CLAUDE.md".text = "@~/.config/agents/AGENTS.md\n";
  };
}
