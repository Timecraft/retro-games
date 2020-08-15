public class Timecraft.RetroGame.Headerbar : Gtk.HeaderBar {
    
    private InstallButton install_button;
    private BackButton back_button;
    
    private ControlButton control_button;
    
    public MainWindow main_window {get; construct;}
    
    public Headerbar (MainWindow main_window) {
        Object (
            title: "Retro",
            show_close_button: true,
            main_window: main_window
        );
        install_button = new InstallButton (main_window);
        
        pack_end (install_button);
        
        control_button = new ControlButton (main_window);
        
        pack_start (control_button);
        
    }
    
    public void add_back_button () {
        if (back_button == null) {
            back_button = new BackButton (main_window);
        }
        pack_start (back_button);
    }
    
    public void remove_back_button () {
        remove (back_button);
        back_button = null;
    }
    
    public void hide_install_popover () {
        install_button.popover.hide ();
    }
    
}
