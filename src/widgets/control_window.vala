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
    
    private MainWindow main_window;
    

    
    private int current_button = 0;
    
    private int total_buttons = 16;
    
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
                                                    
    
    
    private ulong handler_id; // For disconnecting fro signals
    
    public ControlWindow (MainWindow main_window) {
        Object (
            title: "Set up controls"
        );
        
        this.main_window = main_window;
        
        
        
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
        
        
        control_setup = new Gtk.Button.with_label ("Set up controller");
        
        control_setup.margin = 20;
        
        window_grid.attach (device_name, 0, -1, 5, 3);
        
        window_grid.attach (controller_image, 0, 1, 5, 3);
        
        window_grid.attach (control_setup, 2, 4, 1, 1);
        
        
        // Ready to set up the controller
        control_setup.clicked.connect ( () => {
            controller_image.icon_name = controller_button_icons [0];
            
            // Check to see if there is a controller connected
            bool worked = monitor_iter.next (out device);
            if (worked) {
                message (device.get_name ());
                device_name.label = device.get_name ();

                
                handler_id = device.button_release_event.connect ( (device_event) => {
                    set_button (device_event, null);
                });
            }
            // There is no controller connected
            else {
                message ("No device connected? Setting keyboard.");
                device_name.label = "Keyboard";
                
                handler_id = key_release_event.connect ( (key_event) => {
                    set_button (null, key_event.hardware_keycode);
                    return false;
                });
            }
        });
        
        
        
        
        
        
        add (window_grid);
        
        show_all ();
    }
    
    // Destructor
    ~ControlWindow () {
        if (key_joypad_mapping != null) {
        uint16 current_key;
        var xml_file = GLib.Path.build_filename (Application.instance.data_dir + "/controls.xml");
        Xml.Doc* doc = new Xml.Doc ("1.0");
        Xml.Node* root_node = new Xml.Node (null, "controls");
        doc->set_root_element (root_node);
         
            foreach (Retro.JoypadId current_id in controller_buttons) {
                Xml.Node* child = new Xml.Node (null, "control");
                
                current_key = key_joypad_mapping.get_button_key (current_id);
                child->new_prop ("retro", current_id.to_button_code ().to_string ());
                child->new_prop ("gamepad", current_key.to_string ());
                
                root_node->add_child (child);
            }
            
        doc->save_format_file (xml_file, 1);
        delete doc;
        }
    }
    
    
    public Retro.KeyJoypadMapping? get_key_joypad_mapping () {
        if (key_joypad_mapping == null) {
            critical ("There is no KeyJoypadMapping");
            return null;
        }
        else {
            return key_joypad_mapping;
        }
    }
    
    
    private void refresh_controller (Manette.Device device) {
        message (device.get_name ());
        device_name.label = device.get_name ();
        handler_id = device.button_press_event.connect ( (device_event) => {
            set_button (device_event, null);
        });
        
    }
    
    private void set_button (Manette.Event? device_event, uint16? key_val) {
        if (device_event != null) {
        key_joypad_mapping.set_button_key (controller_buttons [current_button], device_event.get_hardware_code ());
        current_button ++;
        if (current_button >= total_buttons) {
            device = null;
            controller_image.icon_name = "controller-outline";
            device.disconnect (handler_id);
            main_window.key_joypad_mapping = this.key_joypad_mapping;
            current_button = 0;
            message ((this.key_joypad_mapping == null).to_string ());
            return;
        }
        controller_image.icon_name = controller_button_icons [current_button];
        }
        
        else if (key_val != null) {
            key_joypad_mapping.set_button_key (controller_buttons [current_button], key_val);
            current_button ++;
            if (current_button >= total_buttons) {
                controller_image.icon_name = "controller-outline";
                disconnect (handler_id);
                main_window.key_joypad_mapping = this.key_joypad_mapping;
                current_button = 0;
                return;
            }
            controller_image.icon_name = controller_button_icons [current_button];
        }

    }
    
    
    
}
