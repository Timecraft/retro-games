public class Timecraft.RetroGame.InstallCoreButton : Gtk.Button {
    public InstallCoreButton (MainWindow main_window) {
        Gtk.Image input_gaming_new = new Gtk.Image.from_icon_name ("com.github.timecraft.retro", Gtk.IconSize.LARGE_TOOLBAR);
        input_gaming_new.pixel_size = 24;
        
        input_gaming_new.icon_name = "input-gaming-new";
        Object (
            image: input_gaming_new,
            always_show_image: true,
            label: "Install Core",
            tooltip_text: "Install Core",
            margin_start: 10,
            margin_top: 20,
            margin_end: 10,
            margin_bottom: 20
        );
        clicked.connect ( () => {
            new InstallCore (main_window);
            main_window.headerbar.hide_install_popover ();
        });
    }
}
