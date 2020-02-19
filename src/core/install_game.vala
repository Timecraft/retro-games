public class Timecraft.RetroGame.InstallGame : Gtk.Button {
        
    private string game_path;
    private string game_name_with_extension;
    private string game_extension;
    
    private GLib.File game_file;
    private GLib.File game_file_destination;
    
    private System system = Application.instance.selected_system;
    
    public InstallGame () {
        show_window ();
    }
    
    public void show_window () {
        var game_chooser = new Gtk.FileChooserDialog ("Install game", MainWindow.instance, Gtk.FileChooserAction.OPEN, "Cancel", Gtk.ResponseType.CANCEL, "Open", Gtk.ResponseType.ACCEPT);

       
       

        game_chooser.show_all ();


        game_chooser.response.connect ( (response_type) => {
            switch (response_type) {
                case Gtk.ResponseType.CANCEL:
                    game_chooser.destroy ();
                    break;

                case Gtk.ResponseType.ACCEPT:
                    game_file = game_chooser.get_file ();
                    message (game_file.get_uri ());
                   
                    string game_name = game_file.get_parse_name ();
                    game_path = game_file.get_path ();
                   
                    game_name = game_name.substring (game_name.last_index_of ("/") + 1, -1);
                    game_extension = game_name.substring (game_name.last_index_of ("."), -1);
                    game_name = game_name.replace (game_extension, "");
                    game_name_with_extension = game_name + game_extension;
                    
                    // Install the game into the system folder
                    if (game_file.query_exists ()) {
                        game_file_destination = GLib.File.new_for_path (system.system_path + game_name_with_extension);
                        try {
                            game_file.move (game_file_destination, GLib.FileCopyFlags.OVERWRITE);
                        }
                        catch (Error e) {
                            error (e.message);
                        }
                        message ("%s installed for %s", game_name, system.name);
                    }
                    
                    // Update game_grid
                    
                    
                    MainWindow.instance.update_game_grid ();
                    
                    game_chooser.destroy ();

                   break;
           }
       
        
        InstallButton.instance.popover.hide ();
    });
    
    }

}
