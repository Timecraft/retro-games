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
    join_paths ('core/structs.vala'),
    join_paths ('core/enums.vala'),
    
    
    # Widget files
    # Main Window
    join_paths ('widgets/main_window/main_window.vala'),
    join_paths ('widgets/main_window/game_button.vala'),
    join_paths ('widgets/main_window/system_grid.vala'),
    join_paths ('widgets/main_window/system_button.vala'),
    join_paths ('widgets/main_window/headerbar.vala'),
    join_paths ('widgets/main_window/install_button.vala'),
    join_paths ('widgets/main_window/game_grid.vala'),
    join_paths ('widgets/main_window/install_core_button.vala'),
    join_paths ('widgets/main_window/install_core_options.vala'),
    join_paths ('widgets/main_window/back_button.vala'),
    join_paths ('widgets/main_window/install_game_button.vala'),
    #Control Window
    join_paths ('widgets/control_window/control_button.vala'),
    join_paths ('widgets/control_window/control_window.vala'),
    join_paths ('widgets/control_window/control_headerbar.vala'),
    join_paths ('widgets/control_window/control_view.vala'),
    
    
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
