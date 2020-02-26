public class Timecraft.RetroGame.MainWindow : Gtk.Window {
    Gtk.Settings gtk_settings = Gtk.Settings.get_default ();

    private GameGrid game_grid;
    private SystemGrid system_grid;

    public Headerbar headerbar;

    private System system;

    private View game_view_instance;

    public RetroGame.Application retro_application {get; construct;}

    public Retro.KeyJoypadMapping key_joypad_mapping = null;


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
        system_grid = new SystemGrid (this);
        headerbar = new Headerbar (this);
        set_titlebar (headerbar);
        current_grid = "system_grid";

        add (system_grid);

        try_load_controls ();

        show_all ();
    }

    ~MainWindow () {
        game_view_instance.main_loop.stop ();

    }


    private void try_load_controls () {
        var xml_file = GLib.Path.build_filename (Application.instance.data_dir + "/controls.xml");
        Xml.Doc* doc = Xml.Parser.parse_file (xml_file);

        if (doc == null) {
            return;
        }
        key_joypad_mapping = new Retro.KeyJoypadMapping ();
        var root = doc->get_root_element ();

        for (Xml.Node* node = root->children; node != null; node = node->next) {
            var retro_control = node->get_prop ("retro");
            var gamepad_control = node->get_prop ("gamepad");
            if (!(retro_control == null && gamepad_control == null)) {
                key_joypad_mapping.set_button_key (Retro.JoypadId.from_button_code ((uint16) uint64.parse (retro_control)), (uint16) uint64.parse (gamepad_control));
            }
        }
        delete doc;
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
        game_view_instance.game_view.grab_focus ();
        core.video_output.connect ( () => {
            message (core.get_frames_per_second ().to_string ());
        });

        /* Used for creating a log for an issue on retro-gtk's gitlab repo
        bool key_is_pressed = false;

        game_view_instance.game_view.key_release_event.connect ( (key) => {
            if (key.keyval == Gdk.Key.Up && key_is_pressed) {
                message ("Up arrow released");
                key_is_pressed = false;
            }
            return false;
        });
        game_view_instance.game_view.key_press_event.connect ( (key) => {
            if (key.keyval == Gdk.Key.Up && !key_is_pressed) {
                message ("Up arrow pressed");
                key_is_pressed = true;
            }
            return false;
        });
        */
    }

}
