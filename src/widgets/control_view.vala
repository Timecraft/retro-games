public class Timecraft.RetroGame.ControlView : Gtk.DrawingArea {

    private Rsvg.Handle handle;


    private ulong gamepad_button_press_event_handler_id;
    private ulong gamepad_button_release_event_handler_id;
    private ulong gamepad_axis_event_handler_id;


    private int current_iter = -1;

    private int total_buttons = 21;

    private double[] analog_left_pos = {0,0};
    private double[] analog_right_pos = {0,0};

	private const GamepadInputSource[] INPUT_SOURCES = {
		{ { EventCode.EV_KEY, EventCode.BTN_B }, "a" },
		{ { EventCode.EV_KEY, EventCode.BTN_A }, "b" },
		{ { EventCode.EV_KEY, EventCode.BTN_X }, "x" },
		{ { EventCode.EV_KEY, EventCode.BTN_Y }, "y" },
		{ { EventCode.EV_KEY, EventCode.BTN_DPAD_UP }, "dpup" },
		{ { EventCode.EV_KEY, EventCode.BTN_DPAD_DOWN }, "dpdown" },
		{ { EventCode.EV_KEY, EventCode.BTN_DPAD_LEFT }, "dpleft" },
		{ { EventCode.EV_KEY, EventCode.BTN_DPAD_RIGHT }, "dpright" },
		{ { EventCode.EV_KEY, EventCode.BTN_TL }, "leftshoulder" },
		{ { EventCode.EV_KEY, EventCode.BTN_TL2 }, "lefttrigger" },
		{ { EventCode.EV_KEY, EventCode.BTN_THUMBL }, "leftstick" },
		{ { EventCode.EV_KEY, EventCode.BTN_SELECT }, "back" },
		{ { EventCode.EV_KEY, EventCode.BTN_TR }, "rightshoulder" },
		{ { EventCode.EV_KEY, EventCode.BTN_TR2 }, "righttrigger" },
		{ { EventCode.EV_KEY, EventCode.BTN_THUMBR }, "rightstick" },
		{ { EventCode.EV_KEY, EventCode.BTN_START }, "start" },
		{ { EventCode.EV_KEY, EventCode.BTN_MODE }, "guide" },
		{ { EventCode.EV_ABS, EventCode.ABS_X }, "leftx" },
		{ { EventCode.EV_ABS, EventCode.ABS_Y }, "lefty" },
		{ { EventCode.EV_ABS, EventCode.ABS_RX }, "rightx" },
		{ { EventCode.EV_ABS, EventCode.ABS_RY }, "righty" },
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
                                                                "BTN_MODE",
                                                                "ABS_X",
                                                                "ABS_Y",
                                                                "ABS_RX",
                                                                "ABS_RY"
                                                                };


    private Manette.Monitor monitor;
    private Manette.Device device;
    private Manette.MonitorIter monitor_iter;



    private HighlightId[] button_ids = {};





    public ControlView () {
        set_up_button_ids ();
        set_size_request (448, 448);
        monitor = new Manette.Monitor ();
        monitor_iter = monitor.iterate ();
        monitor_iter.next (out device);
        if (device != null) {
            connect_to_gamepad ();
        }
    }

    private void set_up_button_ids () {                                                         // Base GameCube controller
        HighlightId button_east             =           {"#button_east"         ,       false, null, 0}; // A
        HighlightId button_south            =           {"#button_south"        ,       false, null, 0}; // B
        HighlightId button_north            =           {"#button_north"        ,       false, null, 0}; // X
        HighlightId button_west             =           {"#button_west"         ,       false, null, 0}; // Y
        HighlightId dpad_up                 =           {"#dpad_up"             ,       false, null, 0}; // DPad Up
        HighlightId dpad_down               =           {"#dpad_down"           ,       false, null, 0}; // DPad Down
        HighlightId dpad_left               =           {"#dpad_left"           ,       false, null, 0}; // DPad Left
        HighlightId dpad_right              =           {"#dpad_right"          ,       false, null, 0}; // DPad Right
        HighlightId left_bumper             =           {"#left_bumper"         ,       false, null, 0}; // Left Bumper
        HighlightId left_trigger            =           {"#left_trigger"        ,       false, null, 0}; // Left Trigger
        HighlightId left_stick              =           {"#left_stick"          ,       false, null, 0}; // Left Stick
        HighlightId button_middle_left      =           {"#button_middle_left"  ,       false, null, 0}; // Select
        HighlightId right_bumper            =           {"#right_bumper"        ,       false, null, 0}; // Right Bumper
        HighlightId right_trigger           =           {"#right_trigger"       ,       false, null, 0}; // Right Trigger
        HighlightId right_stick             =           {"#right_stick"         ,       false, null, 0}; // Right Stick
        HighlightId button_middle_right     =           {"#button_middle_right" ,       false, null, 0}; // Start
        HighlightId button_middle           =           {"#button_middle"       ,       false, null, 0}; // Home
                                                                                                // This makes no distinction between X and Y analog actions
        HighlightId stick_left_analog_x     =             {"#stick_left_analog"   ,       false, Direction.X, 0 }; // Left Analog Stick
        HighlightId stick_left_analog_y     =             {"#stick_left_analog"   ,       false, Direction.Y, 0}; // Left Analog Stick
        HighlightId stick_right_analog_x    =             {"#stick_right_analog"  ,       false, Direction.X, 0}; // Right Analog Stick
        HighlightId stick_right_analog_y    =             {"#stick_right_analog"  ,       false, Direction.Y, 0}; // Right Analog Stick

        button_ids += button_east;          // A
        button_ids += button_south;         // B
        button_ids += button_north;         // X
        button_ids += button_west;          // Y
        button_ids += dpad_up;              // DPad Up
        button_ids += dpad_down;            // DPad Down
        button_ids += dpad_left;            // DPad Left
        button_ids += dpad_right;           // DPad Right
        button_ids += left_bumper;          // Left Bumper
        button_ids += left_trigger;         // Left Trigger
        button_ids += left_stick;           // Left Stick
        button_ids += button_middle_left;   // Select
        button_ids += right_bumper;         // Right Bumper
        button_ids += right_trigger;        // Right Trigger
        button_ids += right_stick;          // Right Stick
        button_ids += button_middle_right;  // Start
        button_ids += button_middle;        // Home
        button_ids += stick_left_analog_x;    // Left Analog Stick
        button_ids += stick_left_analog_y;    // Left Analog Stick
        button_ids += stick_right_analog_x;   // Right Analog Stick
        button_ids += stick_right_analog_y;   // Right Analog Stick
    }


    public override bool draw (Cairo.Context context) {
        // Render SVG into DrawingArea
        highlight_button (context);
        return false;
    }



    private void on_button_press_event (Manette.Event event) {
        uint16 button;

        if (event.get_button (out button)) {
            highlight ({ EventCode.EV_KEY, button }, true);
        }
    }

    private void on_button_release_event (Manette.Event event) {
        uint16 button;

        if (event.get_button (out button)) {
            highlight ({ EventCode.EV_KEY, button }, false);
        }
    }

    private void on_absolute_axis_event (Manette.Event event) {
        uint16 axis;
        double value;

        if (event.get_absolute (out axis, out value)) {
            message ("%s\t%s", axis.to_string (), value.to_string ());
            if (axis == 1 || axis == 4) {
                highlight ({ EventCode.EV_ABS, axis }, !(-0.01 < value < 0.01));
                if (axis == 1) {
                    button_ids [18].amount = value;
                }
                else {
                    button_ids [20].amount = value;
                }

            }
            if (axis == 0 || axis == 3) {
                highlight ({ EventCode.EV_ABS, axis }, !(-0.01 < value < 0.01));
                if (axis == 0) {
                    button_ids [17].amount = value;
                }
                else {
                    button_ids [19].amount = value;
                }
            }
        }
    }

    public void stop () {
        disconnect_from_gamepad ();
    }

    public void connect_to_gamepad () {
        gamepad_button_press_event_handler_id = device.button_press_event.connect (on_button_press_event);
        gamepad_button_release_event_handler_id = device.button_release_event.connect (on_button_release_event);
        gamepad_axis_event_handler_id = device.absolute_axis_event.connect (on_absolute_axis_event);
    }

    private void disconnect_from_gamepad () {
        if (gamepad_button_press_event_handler_id != 0) {
            device.disconnect (gamepad_button_press_event_handler_id);
            gamepad_button_press_event_handler_id = 0;
        }
        if (gamepad_button_release_event_handler_id != 0) {
            device.disconnect (gamepad_button_release_event_handler_id);
            gamepad_button_release_event_handler_id = 0;
        }
        if (gamepad_axis_event_handler_id != 0) {
            device.disconnect (gamepad_axis_event_handler_id);
            gamepad_axis_event_handler_id = 0;
        }
    }


    private void highlight (GamepadInput input, bool highlight) {
        for (int i = 0; i < button_ids.length; ++i){
            if (input == INPUT_SOURCES[i].input) {
                button_ids [i].highlight = highlight;
                queue_draw ();
                message (button_ids [i].button_id + "\t" + standard_gamepad_inputs_as_string[i]);

            }
        }
    }

    private void highlight_button (Cairo.Context context) {
        try {
            GLib.Bytes bytes = GLib.resources_lookup_data ("/com/github/timecraft/retro/controller-outline.svg", GLib.ResourceLookupFlags.NONE);
            uint8[] data = bytes.get_data ();
            handle = new Rsvg.Handle.from_data (data);
        }
        catch (Error e) {
            critical (e.message);
        }

        for (int i = 0; i <= 20; ++i) {
            if (button_ids[i].highlight) {
                context.push_group ();
                if (button_ids [i].button_id.contains ("analog")) {
                    if (button_ids [i].direction == Direction.X) {

                        if (button_ids [i].button_id.contains ("left")) {
                            analog_left_pos [0] = button_ids [i].amount * 25;
                            translate_analog (context, Direction.X, button_ids [i].amount, analog_left_pos [0], analog_left_pos [1]);
                        }
                        else if (button_ids [i].button_id.contains ("right")) {
                            analog_right_pos [0] = button_ids [i].amount * 25;
                            translate_analog (context, Direction.X, button_ids [i].amount, analog_right_pos [0], analog_right_pos [1]);
                        }
                    }
                    else if (button_ids [i].direction == Direction.Y) {
                        if (button_ids [i].button_id.contains ("left")) {
                            analog_left_pos [1] = button_ids [i].amount * 25;
                            translate_analog (context, Direction.Y, button_ids [i].amount, analog_left_pos [0], analog_left_pos [1]);
                        }
                        else if (button_ids [i].button_id.contains ("right")) {
                            analog_right_pos [1] = button_ids [i].amount * 25;
                            translate_analog (context, Direction.X, button_ids [i].amount, analog_right_pos [0], analog_right_pos [1]);
                        }
                    }
                    
                }
        		handle.render_cairo_sub (context, button_ids[i].button_id);
        		var group = context.pop_group ();
        		context.set_source_rgba (1, 0, 0, 1);
        		context.mask (group);
            }
            else {
                context.push_group ();
        		handle.render_cairo_sub (context, button_ids[i].button_id);
        		var group = context.pop_group ();
        		Gdk.RGBA color;
                get_style_context ().lookup_color ("theme_fg_color", out color);
                context.set_source_rgba (color.red, color.green, color.blue, color.alpha);
        		context.mask (group);
            }
        }
    }

    private void translate_analog (Cairo.Context context, Direction direction, double amount, double x, double y) {
        message (amount.to_string ());
        if (direction == Direction.Y) {
            context.translate (x, 25 * amount);
        }
        if (direction == Direction.X) {
            context.translate (25 * amount, y);
        }

    }

    public void next_button () {

        button_ids [current_iter].highlight = false;
        current_iter ++;
        if (current_iter >= total_buttons) {
            return;
        }
        button_ids [current_iter].highlight = true;
        if (button_ids [current_iter].button_id.contains ("analog")) {
            button_ids [current_iter].amount = 1;
        }
        message ("Current Button: %s", button_ids[current_iter].button_id);
        queue_draw ();

    }

    public void reset_mapping () {
        foreach (HighlightId current_id in button_ids) {
            current_id.highlight = false;
        }
    }

    public void done_mapping () {
        connect_to_gamepad ();
        current_iter = -1;
    }

    public void start_mapping_gamepad () {
        disconnect_from_gamepad ();
    }




}
