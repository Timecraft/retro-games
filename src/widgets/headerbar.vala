public class Timecraft.RetroGame.Headerbar : Gtk.HeaderBar {
    
    private InstallButton install_button;
    private BackButton back_button;
    
    public static Headerbar instance;
    
    public Headerbar () {
        Object (
            title: "Retro",
            show_close_button: true
        );
        install_button = new InstallButton ();
        
        pack_end (install_button);
        instance = this;
    }
    
    public void add_back_button () {
        if (BackButton.instance == null) {
            back_button = new BackButton ();
        }
        pack_start (back_button);
    }
    
    public void remove_back_button () {
        back_button.destroy ();
    }
    
}
