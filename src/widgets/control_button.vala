public class Timecraft.RetroGame.ControlButton : Gtk.Button {
    
    public ControlButton (MainWindow main_window) {
        
        Gtk.Image controller_icon = new Gtk.Image.from_icon_name ("com.github.timecraft.retro", Gtk.IconSize.LARGE_TOOLBAR);
        controller_icon.pixel_size = 24;
        
        
        
        Object (
            
        );
    }
}
