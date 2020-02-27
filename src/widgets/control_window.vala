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


    private GamepadMappingBuilder gamepad_mapper;


    private int current_button = 0;

    private int total_buttons = 16;


    private const GamepadInput[] STANDARD_GAMEPAD_INPUTS = {
    		                                                { EventCode.EV_KEY, EventCode.BTN_A },              // A
                                                    		{ EventCode.EV_KEY, EventCode.BTN_B },              // B
                                                    		{ EventCode.EV_KEY, EventCode.BTN_X },              // X
                                                    		{ EventCode.EV_KEY, EventCode.BTN_Y },              // Y
                                                    		{ EventCode.EV_KEY, EventCode.BTN_DPAD_UP },        // Dpad Up
                                                    		{ EventCode.EV_KEY, EventCode.BTN_DPAD_DOWN },      // Dpad Down
                                                    		{ EventCode.EV_KEY, EventCode.BTN_DPAD_LEFT },      // Dpad Left
                                                    		{ EventCode.EV_KEY, EventCode.BTN_DPAD_RIGHT },     // Dpad Right
                                                    		{ EventCode.EV_KEY, EventCode.BTN_TL },             // Left Bumper
                                                    		{ EventCode.EV_KEY, EventCode.BTN_TL2 },            // Left Trigger
                                                    		{ EventCode.EV_KEY, EventCode.BTN_THUMBL },         // Left Stick
                                                    		{ EventCode.EV_KEY, EventCode.BTN_SELECT },         // Select
                                                    		{ EventCode.EV_KEY, EventCode.BTN_TR },             // Right Bumper
                                                    		{ EventCode.EV_KEY, EventCode.BTN_TR2 },            // Right Trigger
                                                    		{ EventCode.EV_KEY, EventCode.BTN_THUMBR },         // Right Stick
                                                    		{ EventCode.EV_KEY, EventCode.BTN_START },          // Start

                                                    		{ EventCode.EV_KEY, EventCode.BTN_MODE },           // ??

                                                    		{ EventCode.EV_ABS, EventCode.ABS_X },              // Left Analog Stick X?
                                                    		{ EventCode.EV_ABS, EventCode.ABS_Y },              // Left Analog Stick Y?
                                                    		{ EventCode.EV_ABS, EventCode.ABS_RX },             // Right Analog Stick X?
                                                    		{ EventCode.EV_ABS, EventCode.ABS_RY },             // Right Analog Stick Y?
    	};

    private string[] standard_gamepad_inputs_as_string =    {
                                                            "BTN_A",                                            // A
                                                            "BTN_B",                                            // B
                                                            "BTN_X",                                            // X
                                                            "BTN_Y",                                            // Y
                                                            "BTN_DPAD_UP",                                      // Dpad Up
                                                            "BTN_DPAD_DOWN",                                    // Dpad Down
                                                            "BTN_DPAD_LEFT",                                    // Dpad Left
                                                            "BTN_DPAD_RIGHT",                                   // Dpad Right
                                                            "BTN_TL",                                           // Left Bumper
                                                            "BTN_TL2",                                          // Left Trigger
                                                            "BTN_THUMBL",                                       // Left Stick
                                                            "BTN_SELECT",                                       // Select
                                                            "BTN_TR",                                           // Right Bumper
                                                            "BTN_TR2",                                          // Right Trigger
                                                            "BTN_THUMBR",                                       // Right Stick
                                                            "BTN_START"                                         // Start
    };


    private string[] controller_button_icons =      {
                                                        "controller-button-primary",                            // A
                                                        "controller-button-secondary",                          // B
                                                        "controller-button-tertiary",                           // X
                                                        "controller-button-quaternary",                         // Y
                                                        "controller-button-dpad-up",                            // DPad Up
                                                        "controller-button-dpad-down",                          // DPad Down
                                                        "controller-button-dpad-left",                          // DPad Left                    
                                                        "controller-button-dpad-right",                         // DPad Right                    
                                                        "controller-button-left-bumper",                        // Left Bumper                    
                                                        "controller-button-left-trigger",                       // Left Trigger
                                                        "controller-button-left-stick",                         // Left Stick
                                                        "controller-button-left-middle",                        // Select
                                                        "controller-button-right-bumper",                       // Right Bumper
                                                        "controller-button-right-trigger",                      // Right Trigger
                                                        "controller-button-right-stick",                        // Right Stick
                                                        "controller-button-right-middle",                       // Start
                                                    };

    private Retro.JoypadId[] controller_buttons =   {
                                                        Retro.JoypadId.A,                                       // A
                                                        Retro.JoypadId.B,                                       // B
                                                        Retro.JoypadId.X,                                       // X
                                                        Retro.JoypadId.Y,                                       // Y
                                                        Retro.JoypadId.UP,                                      // Dpad Up
                                                        Retro.JoypadId.DOWN,                                    // Dpad Down
                                                        Retro.JoypadId.LEFT,                                    // Dpad Left
                                                        Retro.JoypadId.RIGHT,                                   // Dpad Right
                                                        Retro.JoypadId.L,                                       // Left Bumper
                                                        Retro.JoypadId.L2,                                      // Left Trigger
                                                        Retro.JoypadId.L3,                                      // Left Stick
                                                        Retro.JoypadId.SELECT,                                  // Select
                                                        Retro.JoypadId.R,                                       // Right Bumper
                                                        Retro.JoypadId.R2,                                      // Right Trigger
                                                        Retro.JoypadId.R3,                                      // Right Stick
                                                        Retro.JoypadId.START                                    // Start
                                                    };

    bool ready = true;

    private ulong handler_id; // For disconnecting from signals

    public ControlWindow (MainWindow main_window) {
        Object (
            title: "Set up controls"
        );

        gamepad_mapper = new GamepadMappingBuilder ();

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


                handler_id = device.event.connect ( (device_event) => {
                    set_button_from_controller_event (device_event);
                });

            }
            // There is no controller connected
            else {
                message ("No device connected? Setting keyboard.");
                device_name.label = "Keyboard";

                handler_id = key_release_event.connect ( (key_event) => {
                    set_button (key_event.hardware_keycode);
                    return false;
                });
            }
        });






        add (window_grid);

        show_all ();

    }

    // Destructor
    ~ControlWindow () {
        // Save controls
        if (key_joypad_mapping != null) {
        uint16 current_key;
        var xml_file = GLib.Path.build_filename (Application.instance.data_dir + "/controls.xml");
        Xml.Doc* doc = new Xml.Doc ("1.0");
        Xml.Node* root_node = new Xml.Node (null, "controls");
        doc->set_root_element (root_node);
            
            // Controls are based on keyboard
            if (device == null) {
                foreach (Retro.JoypadId current_id in controller_buttons) {

                    Xml.Node* child = new Xml.Node (null, "control");

                    current_key = key_joypad_mapping.get_button_key (current_id);
                    child->new_prop ("retro", current_id.to_button_code ().to_string ());
                    child->new_prop ("gamepad", current_key.to_string ());

                    root_node->add_child (child);
                }
                message ("Saved retro->gamepad controls");
            }
            // Controls are based on an SDL string for controllers
            else {
                Xml.Node* child = new Xml.Node (null, "control");

                child->new_prop ("gamepad_string", gamepad_mapper.build_sdl_string ());
                root_node->add_child (child);
                message ("Saved gamepad SDL string");
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

    // Controller has been connected
    private void refresh_controller (Manette.Device device) {
        message (device.get_name ());
        device_name.label = device.get_name ();
        handler_id = device.event.connect ( (device_event) => {
            set_button_from_controller_event (device_event);
        });
    }

    // Set a button from a controller event
    private void set_button_from_controller_event (Manette.Event device_event) {
        Manette.EventType device_event_type = device_event.get_event_type ();
        
        
        // Button press
        if (device_event_type == Manette.EventType.EVENT_BUTTON_RELEASE) {
                                                                                                            // Get the current button index, then increment it
            gamepad_mapper.set_button_mapping ((uint8) device_event.get_hardware_index (), STANDARD_GAMEPAD_INPUTS [current_button ++]);
            message ("Button was released");
            message ("Button set for %s using %s", standard_gamepad_inputs_as_string [current_button - 1], device_event.get_hardware_index ().to_string ());
        }
        // Hat event
        else if (device_event_type == Manette.EventType.EVENT_HAT) {
            // Wait for hat to be released
            if (ready) {

                ready = false;
            }
            // Hat has been released
            else {
                uint16 axis;
                int8 val;
                device_event.get_hat (out axis, out val);
                gamepad_mapper.set_hat_mapping ((uint8) device_event.get_hardware_index (), (int32) val, STANDARD_GAMEPAD_INPUTS [current_button ++]);
                message ("Hat event");
                ready = true;
                message ("Button was set for %s using %s.%s", standard_gamepad_inputs_as_string [current_button - 1], device_event.get_hardware_index ().to_string (), val.to_string ());
            }
        }
        // Analog stick event. We'll deal with this later
        else if (device_event_type == Manette.EventType.EVENT_ABSOLUTE) {
            message ("Absolute event");
        }
        // All buttons have been set
        if (current_button >= total_buttons) {
            controller_image.icon_name = "controller-outline";
            device.disconnect (handler_id);
            device.save_user_mapping (gamepad_mapper.build_sdl_string ());
            message (gamepad_mapper.build_sdl_string ());
            current_button = 0;
            main_window.gamepad = new RetroGamepad (device);
            return;
        }
        controller_image.icon_name = controller_button_icons [current_button];

    }



    // Sets a button from a keyboard button press
    private void set_button (uint16? key_val) {
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
