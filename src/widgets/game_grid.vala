public class Timecraft.RetroGame.GameGrid : Gtk.EventBox {

    private int cells_width = 5;

    private int current_cell_x = 0;
    private int current_cell_y = 1;
    private float max_cell_x = 0;

    private Gtk.Grid games;
    private System system;
    
    private Granite.Widgets.Welcome welcome;
    
    private GameButton[] buttons = {};
    
    private GameButton? last_selected_button = null;
    
    public static GameGrid? instance;
    
    private RetroCore[] available_cores;
    
    private Gtk.ComboBox core_selector;

    //public signal void activated (int index);

    //protected new GLib.List<Gtk.Button> children = new GLib.List<Gtk.Button> ();

    public GameGrid (System system) {
        this.system = system;
        games = new Gtk.Grid ();
        this.system.get_games ();
        // Do we have any games for this system?
        add_games ();
        
        
        
        // Get a list of cores for popover
        Gtk.ListStore cores = new Gtk.ListStore (1, typeof (string));
        Gtk.TreeIter core_iter;
        // Puts the core names in the ListStore
        
        available_cores = this.system.cores;
        
        foreach (RetroCore current_core in available_cores) {
            string core_name = current_core.name;
            cores.append (out core_iter);
            cores.set (core_iter, 0, core_name, -1);
            
            
        }
        // Makes a new ComboBox with the list of core names
        core_selector = new Gtk.ComboBox.with_model (cores);
        // Allow for the text to be shown
        var renderer = new Gtk.CellRendererText ();
        core_selector.pack_start (renderer, true);
        core_selector.add_attribute (renderer, "text", 0);
        core_selector.set_active (0);

        
        core_selector.margin = 12;
        core_selector.halign = Gtk.Align.CENTER;
        core_selector.valign = Gtk.Align.CENTER;
        core_selector.hexpand = true;
        core_selector.width_request = 200;

        core_selector.get_child ().halign = Gtk.Align.CENTER;
        
        
        
        
        
        
        core_selector.changed.connect ( () => {
            
            
        });
        
        
        
        
        

        add (games);
        
        if (((max_cell_x / 2.0) % 2).to_string ().contains (".")) {
            games.attach (core_selector, (int)GLib.Math.floor ((max_cell_x / 2.0) + 0.5), 0, 2, 1);
        }
        else if (!((max_cell_x / 2.0) % 2).to_string ().contains (".") && max_cell_x != 0) {
            games.attach (core_selector, (int)(max_cell_x / 2), 0, 1, 1);
        }
        else if (max_cell_x == 0) {
            games.attach (core_selector, 0, 0, 1, 1);
        }
        
        
        instance = this;

    }
    
    public void add_games () {
        
        if (system.found_games){
            foreach (Game current_game in system.games) {
                var button = new GameButton (current_game);
                
                buttons += button;
                if (current_cell_x > cells_width) {
                    current_cell_y ++;
                    current_cell_x = -1;
                }
                
                if (current_cell_x > max_cell_x) {
                    max_cell_x = current_cell_x;
                }
                
                games.attach (button, ++current_cell_x, current_cell_y, 1, 1);
                
            }
        
                games.expand = true;
                games.margin = 20;
                games.orientation = Gtk.Orientation.HORIZONTAL;
                games.halign = Gtk.Align.CENTER;
                games.valign = Gtk.Align.START;
        
                games.set_column_homogeneous (true);
                games.set_column_spacing (20);
                games.set_row_homogeneous (true);
                games.set_row_spacing (20);
                
                
                
        }
        else {
        
            welcome = new Granite.Widgets.Welcome (@"Install a game for the $(system.name)", "");
            welcome.append ("applications-games", "Install game", "");
            
            games.attach (welcome, 0, 0, 1, 1);
            
            welcome.activated.connect ( (index) => {
                var install_game = new InstallGame ();
                install_game.clicked ();
            });
        }

    }
    
    public void game_changed (GameButton new_game) {
        foreach (GameButton current_button in buttons) {
            if (current_button != new_game) {
                current_button.active = false;
                current_button.icon = current_button.game.image;
            }
            if (current_button == new_game && last_selected_button == new_game && 
                last_selected_button.game.to_string () == Application.instance.selected_game.to_string ()) {
                
                int active_core = core_selector.get_active ();
                Application.instance.selected_core = available_cores[active_core];
                
                Application.instance.prepare_core ();
                
                
                //message (Application.instance.selected_game.to_string ());
            }
        }
        last_selected_button = new_game;
        new_game.icon = new Gtk.Image.from_icon_name ("media-playback-start", Gtk.IconSize.DIALOG);
        
        MainWindow.instance.show_all ();
    }
}
