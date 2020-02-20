public class Timecraft.RetroGame.MainWindow : Gtk.Window {
    Gtk.Settings gtk_settings = Gtk.Settings.get_default ();
    
    private GameGrid game_grid;
    private SystemGrid system_grid;
    
    private Headerbar headerbar;
    
    private System system;
    
    
    
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
        remove (game_grid);
        game_grid.destroy ();
        new View (core);
    }
    
}
