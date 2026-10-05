{ pkgs, ... }:

{
  # Ensure the package is available to the user environment
  home.packages = [ pkgs.klassy ];

  # Forcing the configuration files into immutable Nix state management
  xdg.configFile."klassystylerc".text = ''
	[Global]
	LookAndFeelSet=org.kde.breezedark.desktop

	[Windeco]
	WindowCornerRadius=20

	[Windeco Exception 0]
	BorderSize=0
	Enabled=true
	ExceptionBorder=false
	ExceptionMatchTitleBarToApplicationColor=false
	ExceptionPreset=
	ExceptionProgramNamePattern=
	ExceptionWindowPropertyPattern=.*
	ExceptionWindowPropertyType=0
	HideTitleBar=1
	OpaqueTitleBar=false
	PreventApplyOpacityToHeader=false
  '';

  # Depending on your exact version, general presets might also populate here:
  xdg.configFile."klassyrc".text = ''
    [General]
    SystemIconInheritance=true
  '';
}
