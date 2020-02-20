public class Timecraft.RetroGame.SystemButton : Gtk.Button {
    public System system {get; set;}
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
    
    public SystemButton (System system) {
        Object (
            icon: system.image,
            title: system.name,
            system: system
        );
         clicked.connect (() => {
             
             MainWindow.instance.make_game_grid (system);
             
             
             Application.instance.selected_system = this.system;
         });
    }
    
    public SystemButton.no_system () {
        Object (
            icon: new Gtk.Image.from_icon_name ("applications-games", Gtk.IconSize.DIALOG),
            title: "Install game",
            system: null
        );
        clicked.connect (() => {
            new InstallCore ();
        });
    }
    construct {
        // Title label
        button_title = new Gtk.Label (null);
        button_title.get_style_context ().add_class (Granite.STYLE_CLASS_H3_LABEL);
        button_title.halign = Gtk.Align.CENTER;
        button_title.valign = Gtk.Align.CENTER;
        
        get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);

        // Button contents wrapper
        button_grid = new Gtk.Grid ();
        button_grid.column_spacing = 12;
        button_grid.valign = Gtk.Align.CENTER;
        button_grid.halign = Gtk.Align.CENTER;
    
        button_grid.attach (button_title, 0, 2, 1, 1);

        
        this.add (button_grid);
        
       
        
    }
}
