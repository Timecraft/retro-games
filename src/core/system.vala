public class Timecraft.RetroGame.System : GLib.Object {
    // Image representing the console/system
    public Gtk.Image image;
    // Name of said console/system
    public string name;
    // Path to libretro core
    public string path;
    // Path to system directory
    public string system_path;
    
    // Available cores for emulation
    private RetroCore[] _cores;
    public RetroCore[] cores;
    
    // All available games
    public Game[] games = {};
    public bool found_games = false;
    private GLib.File[] game_files = {};
    
    public System (string path, string display_name) {
        this.path = path;
        this.name = display_name;
    }
    // Constructs a System from a GLib.File
    public System.from_file (GLib.File file) {
        message ("Creating system...");
        this.path = file.get_path () + "/";
        this.name = file.get_path ().substring (file.get_path ().last_index_of ("/") + 1, -1);
        this.system_path = file.get_path () + "/";
        this.image = new Gtk.Image.from_icon_name ("application-x-executable", Gtk.IconSize.DIALOG);
        
        
        
        find_core ();
        
    }
    
    // Convenience function to create a list of systems from an array of GLib.Files
    public static System[] from_files (GLib.File[] files) {
        System[] systems_list = {};
        foreach (GLib.File current_file in files) {
            systems_list += new System.from_file (current_file);
            
        }
        return systems_list;
    }
    
    
    public void find_core () {
        bool found_libretro_core = false;
        var file = GLib.File.new_for_path (this.path);
        try {
            var file_enumerator = file.enumerate_children (GLib.FileAttribute.STANDARD_DISPLAY_NAME, GLib.FileQueryInfoFlags.NONE);
            while (true) {
                GLib.FileInfo current_file_info;
                file_enumerator.iterate (out current_file_info, null, null);

                if (current_file_info == null) {
                    break;
                }
                if (current_file_info.get_display_name ().contains ("cores") && !current_file_info.get_display_name ().contains ("retrogame")) {
                    var core_enumerator = GLib.File.new_for_path (this.path + "/cores").enumerate_children (GLib.FileAttribute.STANDARD_DISPLAY_NAME, GLib.FileQueryInfoFlags.NONE);
                    while (true) {
                        core_enumerator.iterate (out current_file_info, null, null);
                        if (current_file_info == null) {
                            break;
                        }
                        else {
                            //path = file.get_path () + "/" + current_file_info.get_display_name ();
                            
                            _cores += new RetroCore (file.get_path () + "/cores/" + current_file_info.get_display_name ());
                            found_libretro_core = true;
                        }
                    }//endwhile
                    
                }//endif (filename contains "core")
            }//endwhile
        }//endtry
        catch (Error e) {
            error ("%s", e.message);
        }
        if (!found_libretro_core) {
            critical ("Could not find a libretro core for %s system", this.name);
        }
        cores = _cores;
    }//endfunc
    
    public Game?[] get_games () {
        game_files = {};
        
        var file = GLib.File.new_for_path (this.path);
        
        try {
            var file_enumerator = file.enumerate_children (GLib.FileAttribute.STANDARD_DISPLAY_NAME, GLib.FileQueryInfoFlags.NONE);
            while (true) {
                GLib.FileInfo current_file_info;
                file_enumerator.iterate (out current_file_info, null, null);
                if (current_file_info == null) {
                    break;
                }
                else if (   !current_file_info.get_display_name ().contains ("libretro") && 
                            !current_file_info.get_display_name ().contains (".sav") && 
                            !current_file_info.get_display_name ().contains ("cores")) {
                            
                    game_files += GLib.File.new_for_path (file.get_path () + "/" + current_file_info.get_display_name ());
                    found_games = true;
                }
            }
        }
        catch (Error e) {
            error ("%s", e.message);
        }
        if (!found_games) {
            critical ("Could not find any games for %s system", this.name);
            return {};
        }
        else {
            games = Game.from_files (game_files);
            foreach (Game current_game in games) {
                
                current_game.set_system (this);
            }
            return games;
        }
        
    }
    
    public string to_string () {
        return this.name;
    }
    
}
