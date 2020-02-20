public class Timecraft.RetroGame.InstallGameButton : Gtk.Button {
    
    public InstallGameButton (MainWindow main_window) {
        Object (
            image: new Gtk.Image.from_icon_name ("applications-games", Gtk.IconSize.LARGE_TOOLBAR),
            always_show_image: true,
            label: "Install Game",
            tooltip_text: "Install Game",
            margin_start: 10,
            margin_top: 20,
            margin_end: 10,
            margin_bottom: 20
        );
        clicked.connect ( () => {
            new InstallGame (main_window);
            main_window.headerbar.hide_install_popover ();
            
        });
    }
}
