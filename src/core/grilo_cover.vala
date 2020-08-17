// Code from GNOME-Games, modified for use in Retro-Games. License: GPL-3.0+
public class Timecraft.RetroGame.GriloCover : GLib.Object {
    private GriloMedia media;
	private GLib.Icon icon;
	private bool resolving;
	private string cover_path;
	
	private Game game;

	public GriloCover (GriloMedia media, Game game) {
		this.media = media;
		this.game = game;
		//media.resolved.connect (on_media_resolved);
		resolving = false;
		cover_path = game.path.substring (0, game.path.last_index_of (".")) + ".png";
		
	}

	public GLib.Icon? get_cover () {
		if (resolving)
			return icon;

		if (icon != null)
			return icon;

		try {
			load_cover ();
		}
		catch (Error e) {
			warning (e.message);

			return icon;
		}

		if (icon != null)
			return icon;

		resolving = true;

		media.try_resolve_media ();

		return icon;
	}

	private void on_media_resolved () {
		var grl_media = media.get_media ();

		if (grl_media == null)
			return;

		if (grl_media.length (Grl.MetadataKey.THUMBNAIL) == 0)
			return;

		var uri = grl_media.get_thumbnail_nth (0);
		try_fetch_cover.begin (uri);
	}


	private async void try_fetch_cover (string uri) {
		try {
			yield fetch_cover (uri);
		}
		catch (Error e) {
			warning (e.message);

			return;
		}
	}

	private async void fetch_cover (string uri) throws Error{

		message ("Fetching icon...");

		var session = new Soup.Session ();
		var message = new Soup.Message ("GET", uri);

		session.queue_message (message, (sess, mess) => {
			if (mess.status_code != Soup.Status.OK) {
				debug ("Failed to load %s: %u %s.", uri, mess.status_code, mess.reason_phrase);

				return;
			}

			try {
				FileUtils.set_data (cover_path, mess.response_body.data);
				load_cover ();
			} catch (Error e) {
				warning (e.message);
			}
		});
		
	}

	private void load_cover () throws Error {
		

		if (!FileUtils.test (cover_path, FileTest.EXISTS))
			return;

		var file = File.new_for_path (cover_path);
		icon = new FileIcon (file);
        game.image = new Gtk.Image.from_gicon (icon, Gtk.IconSize.DIALOG);
        
	}
}
