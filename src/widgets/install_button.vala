public class Timecraft.RetroGame.InstallButton : Gtk.Button {
    
    public Gtk.Popover popover;
    public static InstallButton instance;
    
    public InstallButton () {
        Object (
            image: new Gtk.Image.from_icon_name ("text-x-install", Gtk.IconSize.LARGE_TOOLBAR)
        );
        
        clicked.connect ( () => {
            var grid = new Gtk.Grid ();
            if (MainWindow.instance.current_grid == "system_grid") {
                grid.attach (new InstallCoreButton (), 0, 0, 1, 1);
            }
            else if (MainWindow.instance.current_grid == "game_grid") {
                grid.attach (new InstallGameButton (), 0, 1, 1, 1);
            }
            
            
            
            popover = new Gtk.Popover (this);
            popover.add (grid);
            popover.show_all ();
        });
        instance = this;
    }
    
}
