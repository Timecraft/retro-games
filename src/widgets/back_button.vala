public class Timecraft.RetroGame.BackButton : Gtk.Button {
    public static BackButton instance; 
    
    public BackButton () {
        Object (
            label: "Back"
        );
        get_style_context ().add_class (Granite.STYLE_CLASS_BACK_BUTTON);
        clicked.connect ( () => {
            MainWindow.instance.go_back ();
            Headerbar.instance.remove_back_button ();
        });
    }
}
