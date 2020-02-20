public class Timecraft.RetroGame.InstallButton : Gtk.Button {
    
    public Gtk.Popover popover;
    
    
    public InstallButton (MainWindow main_window) {
        Object (
            image: new Gtk.Image.from_icon_name ("text-x-install", Gtk.IconSize.LARGE_TOOLBAR)
        );
        
        clicked.connect ( () => {
            var grid = new Gtk.Grid ();
            if (main_window.current_grid == "system_grid") {
                grid.attach (new InstallCoreButton (main_window), 0, 0, 1, 1);
            }
            else if (main_window.current_grid == "game_grid") {
                grid.attach (new InstallGameButton (main_window), 0, 1, 1, 1);
            }
            
            
            
            popover = new Gtk.Popover (this);
            popover.add (grid);
            popover.show_all ();
        });
        
    }
    
}
