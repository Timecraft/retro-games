public class Timecraft.RetroGame.GameButton : Gtk.ToggleButton {
    public Game game {get; set;}
    // In essence, this is a Granite.Widgets.WelcomeButton without the description text
    
    Gtk.Image? _icon;
    Gtk.Label button_title;
    Gtk.Grid button_grid;
    
    public string title {
        get { return button_title.get_text (); }
        set { button_title.set_text (value); }
    }
    
    public Gtk.Image? icon {
        get { return _icon; }
        set {
            if (_icon != null) {
            _icon.destroy ();
            }   
            _icon = value;
            if (_icon != null) {
                _icon.set_pixel_size (48);
                _icon.halign = Gtk.Align.CENTER;
                _icon.valign = Gtk.Align.CENTER;
                button_grid.attach (_icon, 0, 0, 1, 2);
            }
        }
    }
    
    public GameButton (Game game) {
        Object (
            icon: game.image,
            title: game.name,
            game: game
        );
         clicked.connect (() => {
             message (game.path);
             
             // TODO: Set up system startup
             Application.instance.selected_game = game;
             GameGrid.instance.game_changed (this);
             //this.active = true;
         });
    }

    
    public GameButton.no_game (System system) {
        Object (
            icon: new Gtk.Image.from_icon_name ("applications-games", Gtk.IconSize.DIALOG),
            title: @"Install game for $(system.name)",
            game: null
        );
        
        
        clicked.connect (() => {
            message (game.path);
            // TODO: Set up game startup
        });
        
    }
    
        construct {
            // Title label
            button_title = new Gtk.Label (null);
            button_title.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
            button_title.halign = Gtk.Align.START;
            button_title.valign = Gtk.Align.END;
            button_title.margin = 12;
            
            get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
    
            // Button contents wrapper
            button_grid = new Gtk.Grid ();
            button_grid.column_spacing = 12;
        
            button_grid.attach (button_title, 0, 2, 1, 1);
            this.add (button_grid);
            
        }
        
        
        
    
}
