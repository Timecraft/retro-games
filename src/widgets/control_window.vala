public class Timecraft.RetroGame.ControlWindow : Gtk.Window {
    public Manette.Monitor monitor;
    public Manette.Device device;
    public Manette.MonitorIter monitor_iter;
    
    // public RetroInput controller;
    
    public Gtk.Image controller_image;
    
    public Retro.KeyJoypadMapping key_joypad_mapping;
    
    
    private Gtk.CssProvider css_provider;
    
    private Gtk.Grid window_grid;
    
    private Gtk.Button control_setup;
    
    private Gtk.Label device_name;
    
    private int current_button = 0;
    
    private int total_buttons = 17;
    
    private string[] controller_button_icons =      {   
                                                        "controller-button-primary",        // A
                                                        "controller-button-secondary",      // B
                                                        "controller-button-tertiary",       // X
                                                        "controller-button-quaternary",     // Y
                                                        "controller-button-dpad-up",        // D-Pad Up
                                                        "controller-button-dpad-down",      // D-Pad Down
                                                        "controller-button-dpad-left",      // D-Pad Left
                                                        "controller-button-dpad-right",     // D-Pad Right
                                                        "controller-button-left-bumper",    // L1
                                                        "controller-button-left-trigger",   // L2
                                                        "controller-button-left-stick",     // L3
                                                        "controller-button-left-middle",    // Select
                                                        "controller-button-right-stick",    // R1
                                                        "controller-button-right-bumper",   // R2
                                                        "controller-button-right-trigger",  // R3
                                                        "controller-button-right-middle",   // Start
                                                    };
                                            
    private Retro.JoypadId[] controller_buttons =   {
                                                        Retro.JoypadId.A,
                                                        Retro.JoypadId.B,
                                                        Retro.JoypadId.X,
                                                        Retro.JoypadId.Y,
                                                        Retro.JoypadId.UP,
                                                        Retro.JoypadId.DOWN,
                                                        Retro.JoypadId.LEFT,
                                                        Retro.JoypadId.RIGHT,
                                                        Retro.JoypadId.L,
                                                        Retro.JoypadId.L2,
                                                        Retro.JoypadId.L3,
                                                        Retro.JoypadId.SELECT,
                                                        Retro.JoypadId.R,
                                                        Retro.JoypadId.R2,
                                                        Retro.JoypadId.R3,
                                                        Retro.JoypadId.START
                                                    };
    
    public ControlWindow () {
        Object (
            title: "Set up controls"
        );
        device_name = new Gtk.Label ("");
        monitor = new Manette.Monitor ();
        monitor_iter = monitor.iterate ();
        
        key_joypad_mapping = new Retro.KeyJoypadMapping ();
        
        monitor.device_connected.connect ( (device) => {
            refresh_controller (device);
        });
        
        
        window_grid = new Gtk.Grid ();
        
        css_provider = new Gtk.CssProvider ();
        css_provider.load_from_resource ("com/github/timecraft/retro/Application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        
        controller_image = new Gtk.Image.from_icon_name ("com.github.timecraft.retro", Gtk.IconSize.DIALOG);
        controller_image.pixel_size = 512;
        
        controller_image.icon_name = "controller-outline";
        
        //controller_image.get_style_context ().add_class ("controller-button");
        
        control_setup = new Gtk.Button.with_label ("Set up controller");
        
        control_setup.margin = 20;
        
        window_grid.attach (device_name, 0, -1, 5, 3);
        
        window_grid.attach (controller_image, 0, 1, 5, 3);
        
        window_grid.attach (control_setup, 2, 4, 1, 1);
        
        control_setup.clicked.connect ( () => {
            controller_image.icon_name = controller_button_icons [0];
        });
        
        bool worked = monitor_iter.next (out device);
        if (worked) {
            message (device.get_name ());
            device_name.label = device.get_name ();
            
        }
        else {
            message ("No device connected?");
            device_name.label = "No device connected...";
            control_setup.set_sensitive (false);
        }
        
        device.button_press_event.connect ( (device_event) => {
            set_button (device_event);
        });
        
        
        add (window_grid);
        
        show_all ();
    }
    
    private void refresh_controller (Manette.Device device) {
        message (device.get_name ());
        device_name.label = device.get_name ();
        control_setup.set_sensitive (true);
    }
    
    private void set_button (Manette.Event device_event) {
        
        key_joypad_mapping.set_button_key (controller_buttons [current_button], device_event.get_hardware_code ());
        current_button ++;
        if (current_button > total_buttons) {
            device = null;
            controller_image.icon_name = "controller-outline";
            return;
        }
        controller_image.icon_name = controller_button_icons [current_button];
        
        
        
    }
    
}
