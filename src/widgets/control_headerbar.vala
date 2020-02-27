public class Timecraft.RetroGame.ControlHeaderBar : Gtk.HeaderBar {
    
    public ControlHeaderBar (ControlWindow control_window) {
        Object (
            title: "Set up controller",
            show_close_button: true
        );
        Gtk.Button reset_button = new Gtk.Button.from_icon_name ("edit-undo", Gtk.IconSize.LARGE_TOOLBAR);
        
        pack_start (reset_button);
        
        reset_button.clicked.connect ( () => {
            message ("Resetting control scheme");
            
            control_window.reset ();
        });
    }
    
}
