public class Timecraft.RetroGame.MainWindow : Gtk.Window {
    Gtk.Settings gtk_settings = Gtk.Settings.get_default ();
    
    private GameGrid game_grid;
    private SystemGrid system_grid;
    
    private Headerbar headerbar;
    
    private System system;
    
    public Retro.CoreView game_view;
    
    // Let's all other widgets know which grid is currently active
    public string current_grid;
    
    
    public static MainWindow instance;
    
    
    public MainWindow (Gtk.Application application) {
        Object (
            application: application,
            resizable: true,
            height_request: 800,
            width_request: 1200
        );
        gtk_settings.gtk_application_prefer_dark_theme = true;
        
        system_grid = new SystemGrid ();
        headerbar = new Headerbar ();
        set_titlebar (headerbar);
        current_grid = "system_grid";
        
        add (system_grid);
        show_all ();
        instance = this;
    }
    
    public void make_game_grid (System system) {
        Headerbar.instance.add_back_button ();
        remove (system_grid);
        system_grid.destroy ();
        
        game_grid = new GameGrid (system);
        this.system = system;
        add (game_grid);
        current_grid = "game_grid";
        show_all ();
        
    }
    
    public void go_back () {
        remove (game_grid);
        game_grid.destroy ();
        
        system_grid = new SystemGrid ();
        add (system_grid);
        current_grid = "system_grid";
        show_all ();
    }
    
    public void update_system_grid () {
        
        
        remove (system_grid);
        system_grid.destroy ();
        
        system_grid = new SystemGrid ();
        current_grid = "system_grid";
        add (system_grid);
        
        show_all ();
    }
    
    public void update_game_grid () {
        remove (game_grid);
        game_grid.destroy ();
        
        game_grid = new GameGrid (system);
        current_grid = "game_grid";
        add (game_grid);
        
        show_all ();
    }
    
    public void load_game_view (Retro.Core core) {
        game_view = new Retro.CoreView ();
        
        game_view.set_core (core);
        
        remove (game_grid);
        game_grid.destroy ();
        
        add (game_view);
        message (core.get_filename ());
        
        try {
            
            core.boot ();
            
            core.iteration ();
            core.reset ();
            
            
        }
        catch (Error e) {
            error ("%s", e.message);
        }
        
        game_view.set_key_joypad_mapping (null);
        
        var key_joypad_mapping = new Retro.KeyJoypadMapping ();
        GLib.HashTable<Retro.JoypadId, uint16> key_map = new GLib.HashTable<Retro.JoypadId, uint16> (null, null);
        
        key_map.insert (Retro.JoypadId.A,       (uint16) Gdk.Key.x);
        key_map.insert (Retro.JoypadId.B,       (uint16) Gdk.Key.z);
        key_map.insert (Retro.JoypadId.Y,       (uint16) Gdk.Key.a);
        key_map.insert (Retro.JoypadId.X,       (uint16) Gdk.Key.s);
        key_map.insert (Retro.JoypadId.UP,      (uint16) Gdk.Key.Up);
        key_map.insert (Retro.JoypadId.DOWN,    (uint16) Gdk.Key.Down);
        key_map.insert (Retro.JoypadId.LEFT,    (uint16) Gdk.Key.Left);
        key_map.insert (Retro.JoypadId.RIGHT,   (uint16) Gdk.Key.Right);
        key_map.insert (Retro.JoypadId.START,   (uint16) Gdk.Key.Return);
        key_map.insert (Retro.JoypadId.SELECT,  (uint16) Gdk.Key.Shift_R);
        
        key_map.foreach ( (joypad, keyboard) => {
            key_joypad_mapping.set_button_key (joypad, keyboard);
        });
        
        game_view.set_key_joypad_mapping (key_joypad_mapping);
        
        //core.set_default_controller (Retro.ControllerType.KEYBOARD, null);
        
        game_view.set_as_default_controller (core);
        
        
        
        
        core.set_keyboard (game_view);
        
        
        //core.set_default_controller (Retro.ControllerType.JOYPAD, null);
        
        
        
        
        
        
        
        core.run ();
        Headerbar.instance.remove_back_button ();
        
        show_all ();
    }
}
