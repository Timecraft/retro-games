// Code from GNOME-Games, modified for use in Retro-Games. License: GPL-3.0+

public class Timecraft.RetroGame.GriloMedia : GLib.Object {
    private static Grl.Registry registry;

	public signal void resolved ();

	private string title;
	private bool resolving;

	private Grl.Media? media;
	
	private Game game;
	
	private const string SOURCE_NAME = "grl-thegamesdb";
	private const string SOURCE_TAG = "games";

	public GriloMedia (string title, Game game) {
		this.title = title;
		resolving = false;
		this.game = game;
		message ("Creating GriloMedia...");
		
	}

	private static Grl.Registry get_registry () throws Error {
		if (registry != null)
			return registry;

		registry = Grl.Registry.get_default ();
		
		
		message ("Loaded default registry.");
		registry.load_all_plugins (true);
		

		var source_list = registry.get_sources (true);
		source_list.foreach ((entry) => {
			var tags = entry.get_tags ();
			if (!(SOURCE_TAG in tags))
				try {
					registry.unregister_source (entry);
				}
				catch (Error e) {
					critical (e.message);
				}
		});

		return registry;
	}

	public void try_resolve_media () {
		try {
			resolve_media ();
		}
		catch (Error e) {
			warning (e.message);
		}
	}

	internal Grl.Media? get_media () {
		return media;
	}

	private void resolve_media () throws Error {
	    message ("Resolving media...");
		
		if (resolving)
			return;

		resolving = true;

        
		var registry = get_registry ();
		
		var source = registry.lookup_source (SOURCE_NAME);
		
		if (source == null)
			return;

		var base_media = new Grl.Media ();
		var title_string = title;
		base_media.set_title (title_string);

		var keys = Grl.MetadataKey.list_new (Grl.MetadataKey.THUMBNAIL,
		                                     Grl.MetadataKey.INVALID);

		var options = new Grl.OperationOptions (null);
		options.set_resolution_flags (Grl.ResolutionFlags.FULL);

		source.do_resolve (base_media, keys, options, on_media_resolved);
	}

	private void on_media_resolved (Grl.Source source, uint operation_id, owned Grl.Media media, GLib.Error? error) {
		this.media = media;
		resolved ();
		new GriloCover (this, game);
	}
}
