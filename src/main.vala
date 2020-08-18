public class Timecraft.RetroGame.Application : Gtk.Application {
    MainWindow main_window;
    
    public static Application? instance;
    
    public string data_dir;
    public GLib.File games_dir;
    
    // Get custom icons
    public weak Gtk.IconTheme default_theme;
    
    // Are there systems installed?
    public System[] systems;
    public bool systems_found = false;
    
    
    // System selected
    public System selected_system {get; set;}
    // Game selected
    public Game selected_game {get; set;}
    
    private GLib.File[] console_dirs;
    
    public RetroGamepad[] controllers = {null, null, null, null};
    /*
        Emulator variables. Includes:
        Core
        Game
    */
    
    public Retro.Core emulator_core;
    public RetroCore selected_core;
    
    public Application () {
        Object (
            application_id: "com.github.timecraft.retro",
            flags: ApplicationFlags.FLAGS_NONE
        );
        instance = this;
    }
    
    protected override void activate () {
        string[] empty_args = {};
        unowned string[] unowned_args = empty_args;
        
        /* RetroGtk does not have a way to ask for it's version.
         * Due to this, I am going to hardcode the version in the app
         * so that I can have a fighting chance at debugging other user's
         * issues, like Dolphin (GameCube/Wii) emu crashing on boot attempt.
        */
        message ("Hardcoded RetroGtk version: 0.14");
        
        Grl.init (ref unowned_args);
        default_theme = Gtk.IconTheme.get_default ();
        default_theme.add_resource_path ("/com/github/timecraft/retro");
        
        Gtk.Settings.get_default().set_property("gtk-icon-theme-name", "elementary");
        Gtk.Settings.get_default().set_property("gtk-theme-name", "elementary");

        systems = try_get_systems ();
                
        main_window = new MainWindow (this);
        
        Grl.deinit ();
    }
    
    
    public System?[] try_get_systems () {
        console_dirs = null;
        data_dir = GLib.Environment.get_user_data_dir () + "/com.github.timecraft.retro";
        games_dir = GLib.File.new_for_path (data_dir);

        
        if (!games_dir.query_exists ()) {
            try {
                games_dir.make_directory ();
            }
            catch (Error e) {
                error ("%s", e.message);
            }
        }
        try {
            var games_dir_enumerator = games_dir.enumerate_children (GLib.FileAttribute.STANDARD_DISPLAY_NAME, GLib.FileQueryInfoFlags.NONE);
            
            // Adds a file to the console directories variable that has the 
            // path of the games directory and the display name of the child files of the games directory
            // e.g. /home/$USER/.local/share/com.github.timecraft.retro-games/GameCube
            while (true) {
                GLib.FileInfo current_file_info;
                games_dir_enumerator.iterate (out current_file_info, null, null);
                if (current_file_info == null) {
                    break;
                }
                if (!current_file_info.get_display_name ().contains ("controls")) {
                    console_dirs += GLib.File.new_for_path (games_dir.get_path () + "/" + current_file_info.get_display_name ());
                    systems_found = true;
                }
            }
        }
        catch (Error e) {
            error ("%s", e.message);
        }
        
        return System.from_files (console_dirs);
    }
    
    public void refresh_systems () {
        systems = try_get_systems ();
    }
    
    public void prepare_core () {
        emulator_core = new Retro.Core (this.selected_core.path);
        emulator_core.set_medias ({selected_game.uri});
        
        //emulator_core.set_controller (0, )
        
        
        
        main_window.load_game_view (emulator_core, controllers);
    }
    
    public void add_controller (uint port, Manette.Device controller) {
        controllers [port] = new RetroGamepad (controller);
        message (@"Controller added on port $(port)");
    }
    
    public static int main (string[] args) {
        
        var app = new Application ();
        return app.run (args);
    }
    
    
    
}
