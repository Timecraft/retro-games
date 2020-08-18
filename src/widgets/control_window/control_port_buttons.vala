// Radio buttons that represent the 4 ports on **most** game consoles

public class Timecraft.RetroGame.ControlPortButtons : Gtk.Grid {
    private Gtk.ToggleButton port_1;
    private Gtk.ToggleButton port_2;
    private Gtk.ToggleButton port_3;
    private Gtk.ToggleButton port_4;
    

    
    
    
    public signal void port_changed (int port_num);
    
    public ControlPortButtons () {

        port_1 = new Gtk.ToggleButton ();
        port_2 = new Gtk.ToggleButton ();
        port_3 = new Gtk.ToggleButton ();
        port_4 = new Gtk.ToggleButton ();
        
        port_1.set_image (new Gtk.Image.from_icon_name ("input-gaming", Gtk.IconSize.DIALOG));
        port_2.set_image (new Gtk.Image.from_icon_name ("input-gaming", Gtk.IconSize.DIALOG));
        port_3.set_image (new Gtk.Image.from_icon_name ("input-gaming", Gtk.IconSize.DIALOG));
        port_4.set_image (new Gtk.Image.from_icon_name ("input-gaming", Gtk.IconSize.DIALOG));
        
        attach (port_1, 0, 0, 1, 1);
        attach (port_2, 1, 0, 1, 1);
        attach (port_3, 2, 0, 1, 1);
        attach (port_4, 3, 0, 1, 1);
        
        port_1.set_active (true);
        port_changed (0);
        
        port_1.toggled.connect ( () => {
            port_changed (0); // Arrays start at 0.
            
            port_2.set_active (false);
            port_3.set_active (false);
            port_4.set_active (false);
            
        });
        
        port_2.toggled.connect ( () => {
            port_changed (1); // Arrays start at 0.
            
            port_1.set_active (false);
            port_3.set_active (false);
            port_4.set_active (false);
        });
        
        port_3.toggled.connect ( () => {
            port_changed (2); // Arrays start at 0.
            
            port_1.set_active (false);
            port_2.set_active (false);
            port_4.set_active (false);
        });
        
        port_4.toggled.connect ( () => {
            port_changed (3); // Arrays start at 0.
            
            port_1.set_active (false);
            port_2.set_active (false);
            port_3.set_active (false);
        });
        
    }
}
