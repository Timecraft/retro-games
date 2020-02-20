public class Timecraft.RetroGame.MainWindow : Gtk.Window {
    Gtk.Settings gtk_settings = Gtk.Settings.get_default ();
    
    private GameGrid game_grid;
    private SystemGrid system_grid;
    
    public Headerbar headerbar;
    
    private System system;
    
    private View game_view_instance;
    
    public RetroGame.Application retro_application {get; construct;}
    
    
    // Let's all other widgets know which grid is currently active
    public string current_grid;
    
    
    
    
    
    public MainWindow (RetroGame.Application application) {
        
        Object (
            application: application,
            retro_application: application,
            resizable: true,
            height_request: 800,
            width_request: 1200
        );
        gtk_settings.gtk_application_prefer_dark_theme = true;
        message ((this == null).to_string ());
        system_grid = new SystemGrid (this);
        headerbar = new Headerbar (this);
        set_titlebar (headerbar);
        current_grid = "system_grid";
        
        add (system_grid);
        
        
        
        show_all ();
    }
    
    ~MainWindow () {
        game_view_instance.main_loop.stop ();
    }
    
    public void make_game_grid (System system) {
        headerbar.add_back_button ();
        remove (system_grid);
        system_grid.destroy ();
        
        game_grid = new GameGrid (system, this);
        this.system = system;
        add (game_grid);
        current_grid = "game_grid";
        show_all ();
        
    }
    
    public void go_back () {
        remove (game_grid);
        game_grid.destroy ();
        
        system_grid = new SystemGrid (this);
        add (system_grid);
        current_grid = "system_grid";
        show_all ();
    }
    
    public void update_system_grid () {
        
        
        remove (system_grid);
        system_grid.destroy ();
        
        system_grid = new SystemGrid (this);
        current_grid = "system_grid";
        add (system_grid);
        
        show_all ();
    }
    
    public void update_game_grid () {
        remove (game_grid);
        game_grid.destroy ();
        
        game_grid = new GameGrid (system, this);
        current_grid = "game_grid";
        add (game_grid);
        
        show_all ();
    }
    
    public void load_game_view (Retro.Core core) {
        remove (game_grid);
        game_grid.destroy ();
        game_view_instance = new View (core, this);
        add (game_view_instance.game_view);
    }
    
}
