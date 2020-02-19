public class Timecraft.RetroGame.RetroCore : GLib.Object {
    public string path;
    public string name;
    
    public static RetroCore instance;
    
    public RetroCore (string path) {
        this.path = path;
        this.name = path.substring (path.last_index_of ("/") + 1, -1).replace (".so", "");
        
        
        
        instance = this;
    }
    
    public string to_string () {
        return this.name;
    }

}
