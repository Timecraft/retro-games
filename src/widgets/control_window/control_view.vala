// This is the controller icon seen in the control window

public class Timecraft.RetroGame.ControlView : Gtk.DrawingArea {

    private Rsvg.Handle handle;


    private ulong gamepad_button_press_event_handler_id;
    private ulong gamepad_button_release_event_handler_id;
    private ulong gamepad_axis_event_handler_id;


    private int current_iter = -1;

    private double[] analog_x_pos = {0,0};
    private double[] analog_y_pos = {0,0};

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

    private void set_up_button_ids () {                                                         // Base GameCube controller with modern buttons
        HighlightId button_east             =           {"#button_east"         ,       false, null, 0, 0}; // A
        HighlightId button_south            =           {"#button_south"        ,       false, null, 0, 0}; // B
        HighlightId button_north            =           {"#button_north"        ,       false, null, 0, 0}; // X
        HighlightId button_west             =           {"#button_west"         ,       false, null, 0, 0}; // Y
        HighlightId dpad_up                 =           {"#dpad_up"             ,       false, null, 0, 0}; // DPad Up
        HighlightId dpad_down               =           {"#dpad_down"           ,       false, null, 0, 0}; // DPad Down
        HighlightId dpad_left               =           {"#dpad_left"           ,       false, null, 0, 0}; // DPad Left
        HighlightId dpad_right              =           {"#dpad_right"          ,       false, null, 0, 0}; // DPad Right
        HighlightId left_bumper             =           {"#left_bumper"         ,       false, null, 0, 0}; // Left Bumper
        HighlightId left_trigger            =           {"#left_trigger"        ,       false, null, 0, 0}; // Left Trigger
        HighlightId left_stick              =           {"#left_stick"          ,       false, null, 0, 0}; // Left Stick
        HighlightId button_middle_left      =           {"#button_middle_left"  ,       false, null, 0, 0}; // Select
        HighlightId right_bumper            =           {"#right_bumper"        ,       false, null, 0, 0}; // Right Bumper
        HighlightId right_trigger           =           {"#right_trigger"       ,       false, null, 0, 0}; // Right Trigger
        HighlightId right_stick             =           {"#right_stick"         ,       false, null, 0, 0}; // Right Stick
        HighlightId button_middle_right     =           {"#button_middle_right" ,       false, null, 0, 0}; // Start
        HighlightId button_middle           =           {"#button_middle"       ,       false, null, 0, 0}; // Home
                                                                                                // This makes no distinction between X and Y analog actions
        HighlightId stick_left_analog_x     =             {"#stick_left_analog"   ,       false, Direction.X, 0, 0}; // Left Analog Stick X
        HighlightId stick_left_analog_y     =             {"#stick_left_analog"   ,       false, Direction.Y, 0, 0}; // Left Analog Stick Y
        HighlightId stick_right_analog_x    =             {"#stick_right_analog"  ,       false, Direction.X, 0, 0}; // Right Analog Stick X
        HighlightId stick_right_analog_y    =             {"#stick_right_analog"  ,       false, Direction.Y, 0, 0}; // Right Analog Stick Y

/* 0 */ button_ids += button_east;          // A
/* 1 */ button_ids += button_south;         // B
/* 2 */ button_ids += button_north;         // X
/* 3 */ button_ids += button_west;          // Y
/* 4 */ button_ids += dpad_up;              // DPad Up
/* 5 */ button_ids += dpad_down;            // DPad Down
/* 6 */ button_ids += dpad_left;            // DPad Left
/* 7 */ button_ids += dpad_right;           // DPad Right
/* 8 */ button_ids += left_bumper;          // Left Bumper
/* 9 */ button_ids += left_trigger;         // Left Trigger
/* 10 */button_ids += left_stick;           // Left Stick
/* 11 */button_ids += button_middle_left;   // Select
/* 12 */button_ids += right_bumper;         // Right Bumper
/* 13 */button_ids += right_trigger;        // Right Trigger
/* 14 */button_ids += right_stick;          // Right Stick
/* 15 */button_ids += button_middle_right;  // Start
/* 16 */button_ids += button_middle;        // Home
/* 17 */button_ids += stick_left_analog_x;    // Left Analog Stick
/* 18 */button_ids += stick_left_analog_y;    // Left Analog Stick
/* 19 */button_ids += stick_right_analog_x;   // Right Analog Stick
/* 20 */button_ids += stick_right_analog_y;   // Right Analog Stick
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
            //message ("%s\t%s", axis.to_string (), value.to_string ());
            if (axis == 1 || axis == 4) { // Y axis
                highlight ({ EventCode.EV_ABS, axis }, !(-0.01 < value < 0.01));
                if (axis == 1) { // Left
                    button_ids [18].amount_y = value;
                    button_ids [17].amount_y = value;
                }
                else { // Right
                    button_ids [20].amount_y = value;
                    button_ids [19].amount_y = value;
                }

            }
            if (axis == 0 || axis == 3) { // X axis
                highlight ({ EventCode.EV_ABS, axis }, !(-0.01 < value < 0.01));
                if (axis == 0) { // Left
                    button_ids [17].amount_x = value;
                    button_ids [18].amount_x = value;
                }
                else { // Right
                    button_ids [19].amount_x = value;
                    button_ids [20].amount_x = value;
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
                        translate_analog (context, button_ids [i].amount_x, button_ids [i].amount_y);
                        context.translate (25 * button_ids [i].amount_x, 25 * button_ids [i].amount_y);
                        
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
                // The stick is dealt with in two parts. It deals with the X and Y axis of each stick. So:
                // If the stick has moved, make the other "axis" invisible
                if (button_ids [i].button_id.contains ("analog") && 
                    ((-0.01 < button_ids [i].amount_x < 0.01) || -0.01 < button_ids [i].amount_y < 0.01)) {
                    context.set_source_rgba (0,0,0,0);
                }
                
                // If the stick hasn't moved, color it white
                if (button_ids [i].direction == Direction.X) {
                    if (-0.01 < button_ids [i].amount_x < 0.01 && -0.01 < button_ids [i].amount_y < 0.01 &&         // X axis
                        -0.01 < button_ids [i + 1].amount_x < 0.01 && -0.01 < button_ids [i + 1].amount_x < 0.01) { // Y axis
                            context.set_source_rgba (color.red, color.green, color.blue, color.alpha);
                        }
                }
        		context.mask (group);
            }
        }
    }

    private void translate_analog (Cairo.Context context, double amount_x, double amount_y) {
        //message ("%s\t%s", amount_x.to_string (), amount_y.to_string ());
        context.translate (25 * amount_x, 25 * amount_y);
    }

    public void next_button () {

        button_ids [current_iter].highlight = false;
        current_iter ++;
        if (current_iter >= INPUT_SOURCES.length) {
            return;
        }
        button_ids [current_iter].highlight = true;
        if (button_ids [current_iter].button_id.contains ("analog")) {
            if (button_ids [current_iter].direction == Direction.X) {
                button_ids [current_iter].amount_y = 0;
                button_ids [current_iter].amount_x = 1;
            }
            else {
                button_ids [current_iter].amount_y = 1;
                button_ids [current_iter].amount_x = 0;
            }
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
