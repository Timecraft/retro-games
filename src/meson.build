# Define executable
#   Name
#   Sources
#   Dependencies
#   Install

input_dir = join_paths (meson.source_root (), 'src/core/vapis')


executable (
    meson.project_name (),
    
    # Root files
    join_paths ('main.vala'),
    
    # Core files
    join_paths ('core/game.vala'),
    join_paths ('core/system.vala'),
    join_paths ('core/install_core.vala'),
    join_paths ('core/install_game.vala'),
    join_paths ('core/core.vala'),
    join_paths ('core/view.vala'),
    join_paths ('core/retro_gamepad.vala'),
    join_paths ('core/gamepad_mapping_builder.vala'),
    
    
    # Widget files
    join_paths ('widgets/main_window.vala'),
    join_paths ('widgets/game_button.vala'),
    join_paths ('widgets/system_grid.vala'),
    join_paths ('widgets/system_button.vala'),
    join_paths ('widgets/headerbar.vala'),
    join_paths ('widgets/install_button.vala'),
    join_paths ('widgets/game_grid.vala'),
    join_paths ('widgets/install_core_button.vala'),
    join_paths ('widgets/install_core_options.vala'),
    join_paths ('widgets/back_button.vala'),
    join_paths ('widgets/install_game_button.vala'),
    join_paths ('widgets/control_button.vala'),
    join_paths ('widgets/control_window.vala'),
    join_paths ('widgets/control_headerbar.vala'),
    join_paths ('widgets/control_view.vala'),
    
    
    asresources,
    
    # Dependencies
    dependencies: [
        dependency ('granite'),
        dependency ('gtk+-3.0'),
        dependency ('glib-2.0'),
        dependency ('retro-gtk-0.14'),
        dependency ('gmodule-2.0'),
        dependency ('manette-0.2'),
        dependency ('libxml-2.0'),
        dependency ('librsvg-2.0'),
        cc.find_library('m'),
        valac.find_library ('event-codes', dirs: input_dir)
    ],
    c_args: '-I' + input_dir,
    install: true
)
