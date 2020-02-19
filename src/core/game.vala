public class Timecraft.RetroGame.Game : GLib.Object {
    // Image representing the game, should be box art
    public Gtk.Image image {get; set;}
    // Name of the game, if we can determine that
    public string name;
    // Path to the ROM
    public string path;
    // System associated with this game
    public System system;
    /// Path to URI
    public string uri;
    
    public Game (string path, string display_name) {
      this.path = path;
      this.name = display_name;
      
    }
        
    public Game.from_file (GLib.File file) {
        this.path = file.get_path ();
        this.name = file.get_path ().substring (file.get_path ().last_index_of ("/") + 1, -1);
        this.image = new Gtk.Image.from_icon_name ("application-x-executable", Gtk.IconSize.DIALOG);
        
        // Create a more correct name...
       this.name = this.name.replace ("_", " ");
       // Removes the .extension from game name
       this.name = this.name.replace (this.name.substring (this.name.last_index_of ("."), -1), "");
       
       // File URI
       this.uri = file.get_uri ();
    }
    
    // Convenience function to create a list of games from an array of GLib.Files
    public static Game[] from_files (GLib.File[] files) {
        Game[] games_list = {};
        foreach (GLib.File current_file in files) {
            games_list += new Game.from_file (current_file);
        }
        return games_list;
    }
    
    public string to_string () {
        return this.name;
    }
    
    public void set_system (System new_system) {
        this.system = new_system;
    }
    
    public System get_system () {
        return this.system;
    }
}
