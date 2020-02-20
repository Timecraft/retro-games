public class Timecraft.RetroGame.InstallCore : Gtk.Button {

    private Gtk.Window core_info;

    private InstallCoreOptions install_core_options;

    // Allow for error toasts
    private Gtk.Overlay toast_overlay;
    private Granite.Widgets.Toast error_toast;

    private string core_path;
    private string core_name_with_extension;
    private GLib.File core_file;

    // Console exists
    private Gtk.ComboBox console_selector;
    private System[] systems_list = Application.instance.systems;

    public static InstallCore instance;


    public InstallCore () {
        install_core_options = new InstallCoreOptions ();
        show_window ();
        instance = this;
    }



    public void show_window () {
        var core_chooser = new Gtk.FileChooserDialog ("Install Core", MainWindow.instance, Gtk.FileChooserAction.OPEN, "Cancel", Gtk.ResponseType.CANCEL, "Open", Gtk.ResponseType.ACCEPT);

        var core_filter = new Gtk.FileFilter ();
        core_filter.add_mime_type ("application/x-sharedlib");
        core_filter.set_filter_name ("libretro cores");
        core_chooser.add_filter (core_filter);



        core_chooser.show_all ();


        core_chooser.response.connect ( (response_type) => {
            switch (response_type) {
                case Gtk.ResponseType.CANCEL:
                    core_chooser.destroy ();
                    break;

                case Gtk.ResponseType.ACCEPT:
                    core_file = core_chooser.get_file ();
                    message (core_file.get_uri ());

                    string core_name = core_file.get_parse_name ();
                    core_name_with_extension = core_file.get_parse_name ();
                    core_path = core_file.get_path ();

                    core_name = core_name.substring (core_name.last_index_of ("/") + 1, -1);
                    core_name = core_name.replace (".so", "");

                    core_name_with_extension = core_name_with_extension.substring   (
                                                                                        core_name_with_extension.last_index_of ("/") + 1,
                                                                                        -1
                                                                                    );

                    core_chooser.destroy ();

                    // Allows the user to determine various information on the core.
                        // e.g. What console does the core emulate?
                            // e.g. vbam_libretro emulates the gameboy advance
                        // We need to do this as many cores will not support the keyfile type that retro-gtk supports
                        // We will write this to a special XML file that will hold various information
                            //TODO: should we do this?
                            /*
                            <core>
                                <name>VisualBoy Advance</name>
                                <console>gameboy-advance</console>
                                <icon>file:///path/to/console/image.png</icon>
                            </core>
                            */
                    core_info = new Gtk.Window (Gtk.WindowType.TOPLEVEL);
                    core_info.set_size_request (300, 300);
                    install_core_options.subtitle = core_name;
                    // Add toast overlay
                    toast_overlay = new Gtk.Overlay ();
                    toast_overlay.add (install_core_options);

                    core_info.add (toast_overlay);
                    core_info.show_all ();



                    // Once we get all of the information about the emulator,
                    // we will create a folder named after the console
                    // replacing spaces with hyphens
                        // e.g. gameboy-advance, sega-genesis, famicom-disk-system



                    break;
            }
        });
    }

    public void new_console () {
        toast_overlay.remove (install_core_options);

        Gtk.Grid core_info_grid = new Gtk.Grid ();
        Gtk.Entry core_console = new Gtk.Entry ();
        error_toast = new Granite.Widgets.Toast ("You must type in a name for the console.");

        // Set the name of console the core emulates
        core_console.set_placeholder_text ("Set console name. e.g. GameCube");
        //core_console.set_text ("Set console name. e.g. GameCube");
        core_console.margin = 12;
        core_console.halign = Gtk.Align.CENTER;
        core_console.valign = Gtk.Align.CENTER;
        core_console.hexpand = true;
        core_console.width_request = 200;

        // Confirmation button
        Gtk.Button core_console_confirm = new Gtk.Button.with_label ("Set console");
        core_console_confirm.margin = 12;
        core_console_confirm.width_request = 200;
        core_console_confirm.height_request = 75;
        core_console_confirm.halign = Gtk.Align.CENTER;
        core_console_confirm.valign = Gtk.Align.CENTER;
        core_console_confirm.hexpand = true;


        // Blank space
        var whitespace = new Gtk.Label ("");
        whitespace.margin = 12;
        core_info_grid.attach (whitespace, 0, 0, 1, 1);
        //core_info_grid.attach (whitespace, 1, 1, 1, 1);
        //core_info_grid.attach (whitespace, 1, 3, 1, 1);

        core_info_grid.attach (core_console, 1, 1, 2, 1);
        core_info_grid.attach (core_console_confirm, 1, 2, 2, 1);

        toast_overlay.add (core_info_grid);
        toast_overlay.add_overlay (error_toast);
        toast_overlay.show_all ();


        // Console confirmed, let's make it now
        core_console_confirm.clicked.connect ( () => {
            if (core_console.text != "") {

            GLib.File new_console_folder = GLib.File.new_for_path (Application.instance.data_dir + "/" + core_console.text);
            GLib.File new_console_core_folder = GLib.File.new_for_path (new_console_folder.get_path () + "/" + "cores");



                if (new_console_folder.query_exists ()) {
                    warning ("%s does exist.", core_console.text);
                    // Hey, this wasn't a new console!
                    if (new_console_core_folder.query_exists ()) {
                        // There's even a core folder!
                        warning ("Core folder does exist");
                    }
                }
                else {
                    // Ok, this folder does not exist. Let's make the directories
                    message ("%s does not exist. Creating it.", core_console.text);
                    try {
                        new_console_folder.make_directory ();
                        new_console_core_folder.make_directory ();
                    }
                    catch (Error e) {
                        error ("%s", e.message);
                    }
                }
                // Move core to $console/cores folder
                install_core (core_console.text);


                Application.instance.refresh_systems ();

                //SystemGrid.instance.update_systems ();

                MainWindow.instance.update_system_grid ();
                core_info.destroy ();
            }
            // There wasn't anything in the core console text box :(
            else {
                warning (error_toast.title);
                error_toast.send_notification ();
            }
        });
    }

    public void existing_console () {
        toast_overlay.remove (install_core_options);

        // Get a list of consoles for popover
        Gtk.ListStore consoles = new Gtk.ListStore (1, typeof (string));
        Gtk.TreeIter console_iter;
        // Puts the console names in the ListStore
        foreach (System current_console in systems_list) {
            string console_name = current_console.name;
            consoles.append (out console_iter);
            consoles.set (console_iter, 0, console_name, -1);

        }
        // Makes a new ComboBox with the list of console names
        console_selector = new Gtk.ComboBox.with_model (consoles);
        // Allow for the text to be shown
        var renderer = new Gtk.CellRendererText ();
        console_selector.pack_start (renderer, true);
        console_selector.add_attribute (renderer, "text", 0);
        console_selector.set_active (0);



        Gtk.Grid console_selector_grid = new Gtk.Grid ();
        Gtk.Button console_selector_confirm = new Gtk.Button.with_label ("Install Core");


        //core_console.set_text ("Set console name. e.g. GameCube");
        console_selector.margin = 12;
        console_selector.halign = Gtk.Align.CENTER;
        console_selector.valign = Gtk.Align.CENTER;
        console_selector.hexpand = true;
        console_selector.width_request = 200;


        console_selector_confirm.margin = 12;
        console_selector_confirm.halign = Gtk.Align.CENTER;
        console_selector_confirm.valign = Gtk.Align.CENTER;
        console_selector_confirm.hexpand = true;
        console_selector_confirm.width_request = 200;
        console_selector_confirm.height_request = 75;

        // Blank space
        var whitespace = new Gtk.Label ("");
        whitespace.margin = 12;
        console_selector_grid.attach (whitespace, 0, 0, 1, 1);

        console_selector_grid.attach (console_selector, 1, 1, 2, 1);
        console_selector_grid.attach (console_selector_confirm, 1, 2, 2, 3);

        toast_overlay.add (console_selector_grid);
        toast_overlay.show_all ();
        //message (console_selector.get_model ().to_string ());

        console_selector_confirm.clicked.connect ( () => {
            Gtk.TreeIter console_iter_2;
            GLib.Value tmp_val;

            console_selector.get_active_iter (out console_iter_2);
            consoles.get_value (console_iter_2, 0, out tmp_val);
            string console_name = tmp_val.get_string ();


            // Move core to $console/cores folder
            install_core (console_name);
            core_info.destroy ();

            Application.instance.refresh_systems ();

            //SystemGrid.instance.update_systems ();

            MainWindow.instance.update_system_grid ();

        });

    }

    // Move core to $console/cores folder
    public void install_core (string console_name) {

        message (console_name);

        GLib.File new_console_folder = GLib.File.new_for_path (Application.instance.data_dir + "/" + console_name);
        GLib.File new_console_core_folder = GLib.File.new_for_path (new_console_folder.get_path () + "/" + "cores");
        GLib.File core_destination = GLib.File.new_for_path (new_console_core_folder.get_path () + "/" + core_name_with_extension);

        if (core_file.query_exists () ) {

            try {
                core_file.copy (core_destination, GLib.FileCopyFlags.OVERWRITE);
            }
            catch (Error e) {
                error ("%s", e.message);
            }
        }
        else {
            critical ("%s does not exist!", core_file.get_path ());
        }
    }

}
