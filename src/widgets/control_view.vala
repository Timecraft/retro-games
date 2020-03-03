public class Timecraft.RetroGame.ControlView : Gtk.DrawingArea {


    private GLib.Bytes data;

    private Rsvg.Handle handle;

    private Gdk.Pixbuf main_pixbuf;

    private Cairo.Context context;
    private Cairo.Surface surface;


    private ulong gamepad_button_press_event_handler_id;
    private ulong gamepad_button_release_event_handler_id;
    private ulong gamepad_axis_event_handler_id;
    private ulong gamepad_event_handler_id;

    private int current_iter = -1;

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
        connect_to_gamepad ();

    }

    private void set_up_button_ids () {                                                         // Base GameCube controller
        HighlightId button_east             =           {"#button_east"         ,       false}; // A
        HighlightId button_south            =           {"#button_south"        ,       false}; // B
        HighlightId button_north            =           {"#button_north"        ,       false}; // X
        HighlightId button_west             =           {"#button_west"         ,       false}; // Y
        HighlightId dpad_up                 =           {"#dpad_up"             ,       false}; // DPad Up
        HighlightId dpad_down               =           {"#dpad_down"           ,       false}; // DPad Down
        HighlightId dpad_left               =           {"#dpad_left"           ,       false}; // DPad Left
        HighlightId dpad_right              =           {"#dpad_right"          ,       false}; // DPad Right
        HighlightId left_bumper             =           {"#left_bumper"         ,       false}; // Left Bumper
        HighlightId left_trigger            =           {"#left_trigger"        ,       false}; // Left Trigger
        HighlightId left_stick              =           {"#left_stick"          ,       false}; // Left Stick
        HighlightId button_middle_left      =           {"#button_middle_left"  ,       false}; // Select
        HighlightId right_bumper            =           {"#right_bumper"        ,       false}; // Right Bumper
        HighlightId right_trigger           =           {"#right_trigger"       ,       false}; // Right Trigger
        HighlightId right_stick             =           {"#right_stick"         ,       false}; // Right Stick
        HighlightId button_middle_right     =           {"#button_middle_right" ,       false}; // Select
        HighlightId button_middle           =           {"#button_middle"       ,       false}; // Home
                                                                                                // This makes no distinction between X and Y analog actions
        HighlightId stick_left_analog     =             {"#stick_left_analog"   ,       false}; // Left Analog Stick
        HighlightId stick_right_analog    =             {"#stick_right_analog"  ,       false}; // Right Analog Stick

        button_ids += button_east;
        button_ids += button_south;
        button_ids += button_north;
        button_ids += button_west;
        button_ids += dpad_up;
        button_ids += dpad_down;
        button_ids += dpad_left;
        button_ids += dpad_right;
        button_ids += left_bumper;
        button_ids += left_trigger;
        button_ids += left_stick;
        button_ids += button_middle_left;
        button_ids += right_bumper;
        button_ids += right_trigger;
        button_ids += right_stick;
        button_ids += button_middle_right;
        button_ids += button_middle;
        button_ids += stick_left_analog;
        button_ids += stick_left_analog;
        button_ids += stick_right_analog;
        button_ids += stick_right_analog;
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
            highlight ({ EventCode.EV_ABS, axis }, !(-0.8 < value < 0.8));

        }
    }

    public void stop () {
        disconnect_from_gamepad ();
    }

    private void connect_to_gamepad () {
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

    /**
    *   Reads an svg file in your gresources.xml file.
    *   Returns a string holding the contents of the svg file.
    *
    *   @param svg_resource The path to your svg file in your resources
    *
    *
    */
    /*
    private string read_svg (string svg_resource) throws Error {
        GLib.Bytes bytes = GLib.resources_lookup_data (svg_resource);
        uint8[] data = bytes.get_data ();
        string svg_file = "";
        foreach (uint8 byte in data) {
            svg_file += ((char) byte).to_string ();
        }
        return svg_file;
    }
    */

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

    public void next_button () {

        button_ids [current_iter].highlight = false;
        current_iter ++;
        button_ids [current_iter].highlight = true;
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
    }

    public void start_mapping_gamepad () {
        disconnect_from_gamepad ();
    }




}
