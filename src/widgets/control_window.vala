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

    private int total_buttons = 21;


    private const GamepadInput[] STANDARD_GAMEPAD_INPUTS = {
                                                    		{ EventCode.EV_KEY, EventCode.BTN_B },              // A
    		                                                { EventCode.EV_KEY, EventCode.BTN_A },              // B
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



                                                    		{ EventCode.EV_ABS, EventCode.ABS_X },              // Left Analog Stick X
                                                    		{ EventCode.EV_ABS, EventCode.ABS_Y },              // Left Analog Stick Y
                                                    		{ EventCode.EV_ABS, EventCode.ABS_RX },             // Right Analog Stick X
                                                    		{ EventCode.EV_ABS, EventCode.ABS_RY },             // Right Analog Stick Y

                                                    		{ EventCode.EV_KEY, EventCode.BTN_MODE },           // Home
    	};


    private string[] standard_gamepad_inputs_as_string =   {
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
                                                            "BTN_START",                                         // Start
                                                            "ABS_X",
                                                            "ABS_Y",
                                                            "ABS_RX",
                                                            "ABS_RY",
                                                            "BTN_MODE"
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
                                                        "controller-button-middle",                             // Home
                                                        "controller-stick-left-horizontal",                     // Left Analog Stick X
                                                        "controller-stick-left-vertical",                       // Left Analog Stick Y
                                                        "controller-stick-right-horizontal",                    // Right Analog Stick X
                                                        "controller-stick-right-vertical"                       // Right Analog Stick Y
                                                    };


    private Retro.JoypadId[] controller_buttons =   {
                                                        Retro.JoypadId.B,                                       // A
                                                        Retro.JoypadId.A,                                       // B
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
    private ulong handler_id_2;

    public ControlWindow (MainWindow main_window) {
        Object (
            title: "Set up controls"
        );

        gamepad_mapper = new GamepadMappingBuilder ();

        this.main_window = main_window;





        key_joypad_mapping = new Retro.KeyJoypadMapping ();



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
            device_name = new Gtk.Label ("");
            monitor = new Manette.Monitor ();
            monitor_iter = monitor.iterate ();

            monitor.device_connected.connect ( (device) => {
                refresh_controller (device);
            });
            controller_image.icon_name = controller_button_icons [0];

            // Check to see if there is a controller connected
            bool worked = monitor_iter.next (out device);
            if (worked) {
                message (device.get_name ());
                device_name.label = device.get_name ();

                // Set current_button to event
                handler_id = device.event.connect ( (device_event) => {
                    set_button_from_controller_event (device_event);
                });

                // Skip this button
                handler_id_2 = key_press_event.connect ( (key_event) => {
                    if (key_event.keyval == Gdk.Key.Escape) {
                        current_button ++;
                        controller_image.icon_name = controller_button_icons [current_button];

                    }
                    return false;
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
            // Controls are automatically saved if the device is a controller. Libmanette is awesome :D

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
        if (device_event_type == Manette.EventType.EVENT_BUTTON_PRESS) {
                                                                                                            // Get the current button index, then increment it
            gamepad_mapper.set_button_mapping ((uint8) device_event.get_hardware_index (), STANDARD_GAMEPAD_INPUTS [current_button ++]);
            debug ("device hardware index: %s", device_event.get_hardware_index ().to_string ());
            message ("Button was pressed");
            message ("Button set for %s using %s", standard_gamepad_inputs_as_string [current_button - 1], device_event.get_hardware_index ().to_string ());
        }
        // Hat event
        else if (device_event_type == Manette.EventType.EVENT_HAT) {
            // Wait for hat to be released
            if (ready) {
                uint16 axis;
                int8 val;
                device_event.get_hat (out axis, out val);
                debug ("axis: %s, value: %s, button: %s", axis.to_string (), val.to_string (), standard_gamepad_inputs_as_string [current_button]);

                gamepad_mapper.set_hat_mapping ((uint8) device_event.get_hardware_index (), val, STANDARD_GAMEPAD_INPUTS [current_button ++]);

                message ("Button was set for %s using %s.%s", standard_gamepad_inputs_as_string [current_button - 1], device_event.get_hardware_index ().to_string (), val.to_string ());
                ready = false;
            }
            // Hat has been released
            else {

                ready = true;

            }
        }
        // Analog stick event. We'll deal with this later
        else if (device_event_type == Manette.EventType.EVENT_ABSOLUTE) {
            if (ready) {
                uint16 axis;
                double val;
                device_event.get_absolute (out axis, out val);

                debug ("axis: %s, value: %s, button: %s", axis.to_string (), val.to_string (), standard_gamepad_inputs_as_string [current_button]);
                // FIXME:
                    /*  https://github.com/Timecraft/retro-games/issues/4#issuecomment-592113102
                        Of course, because it's analog :) In Games we check whether it's larger than 0.8 (or smaller than -0.8),
                        but it's indeed not ideal right now and it's easy to accidentally map 2
                    */

                if (-0.8 < val < 0.8) {
        			return;
        		}
                int range = 0;

            	if (STANDARD_GAMEPAD_INPUTS [current_button].code == EventCode.BTN_DPAD_UP ||
            		STANDARD_GAMEPAD_INPUTS [current_button].code == EventCode.BTN_DPAD_DOWN ||
            		STANDARD_GAMEPAD_INPUTS [current_button].code == EventCode.BTN_DPAD_LEFT ||
            		STANDARD_GAMEPAD_INPUTS [current_button].code == EventCode.BTN_DPAD_RIGHT) {
            		    range = val > 0 ? 1 : -1;
            		}

                gamepad_mapper.set_axis_mapping ((uint8) device_event.get_hardware_index (), range,  STANDARD_GAMEPAD_INPUTS [current_button++]);

                ready = false;
            }
            else {
                uint16 axis;
                double val;
                device_event.get_absolute (out axis, out val);
                if (-0.1 < val < 0.1) {
                    ready = true;
                }
            }
        }
        // All buttons have been set
        if (current_button >= total_buttons) {
            controller_image.icon_name = "controller-outline";
            device.disconnect (handler_id);
            disconnect (handler_id_2);
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
