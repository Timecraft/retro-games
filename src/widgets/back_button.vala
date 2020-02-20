public class Timecraft.RetroGame.BackButton : Gtk.Button {
    
    
    public BackButton (MainWindow main_window) {
        Object (
            label: "Back"
        );
        get_style_context ().add_class (Granite.STYLE_CLASS_BACK_BUTTON);
        clicked.connect ( () => {
            main_window.go_back ();
            destroy ();
        });
    }
}
