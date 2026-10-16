from beets.plugins import BeetsPlugin
from beets.ui import Subcommand, decargs

def should_split(val):
    if not val:
        return False
    if isinstance(val, (list, tuple)):
        if len(val) > 1:
            return False
        return len(val) == 1 and "," in str(val[0])
    return "," in str(val)

def split_comma_string(val):
    raw = val[0] if isinstance(val, (list, tuple)) else str(val)
    return [part.strip() for part in raw.split(",") if part.strip()]

def join_artists(artist_list):
    """Joins a list of artists using commas and an ampersand:
    ['A', 'B'] -> 'A & B'
    ['A', 'B', 'C'] -> 'A, B & C'
    """
    if not artist_list:
        return ""
    if len(artist_list) == 1:
        return artist_list[0]
    if len(artist_list) == 2:
        return f"{artist_list[0]} & {artist_list[1]}"
    return f"{', '.join(artist_list[:-1])} & {artist_list[-1]}"

def process_album(alb):
    changed = False
    if alb.albumartists and len(alb.albumartists) > 1:
        if alb.albumartist != alb.albumartists[0]:
            alb.albumartist = alb.albumartists[0]
            changed = True
    elif should_split(alb.albumartists):
        parts = split_comma_string(alb.albumartists)
        alb.albumartists = parts
        alb.albumartist = parts[0]
        changed = True
    elif should_split(alb.albumartist):
        parts = split_comma_string(alb.albumartist)
        alb.albumartists = parts
        alb.albumartist = parts[0]
        changed = True
    return changed

def process_item(item):
    changed = False

    # 1. Keep albumartist locked to the primary artist
    if item.albumartists and len(item.albumartists) > 1:
        if item.albumartist != item.albumartists[0]:
            item.albumartist = item.albumartists[0]
            changed = True
    elif should_split(item.albumartists):
        parts = split_comma_string(item.albumartists)
        item.albumartists = parts
        item.albumartist = parts[0]
        changed = True
    elif should_split(item.albumartist):
        parts = split_comma_string(item.albumartist)
        item.albumartists = parts
        item.albumartist = parts[0]
        changed = True

    # 2. Concatenate track artist with ',' and '&'
    if item.artists and len(item.artists) > 1:
        combined = join_artists(item.artists)
        if item.artist != combined:
            item.artist = combined
            changed = True
    elif should_split(item.artists):
        parts = split_comma_string(item.artists)
        item.artists = parts
        combined = join_artists(parts)
        if item.artist != combined:
            item.artist = combined
            changed = True
    elif should_split(item.artist):
        parts = split_comma_string(item.artist)
        item.artists = parts
        combined = join_artists(parts)
        if item.artist != combined:
            item.artist = combined
            changed = True

    return changed


class SplitArtistsPlugin(BeetsPlugin):
    def __init__(self):
        super().__init__()
        self.import_stages = [self.on_task_apply]

    def on_task_apply(self, session, task):
        if task.is_album and task.album:
            if process_album(task.album):
                task.album.store()

        for item in task.imported_items():
            if process_item(item):
                item.store()
                item.write()

    def commands(self):
        cmd = Subcommand('splitartists', help='apply artist splits to existing library')

        def func(lib, opts, args):
            query = decargs(args)

            # Process albums in library
            for alb in lib.albums(query):
                if process_album(alb):
                    alb.store()
                    print(f"Updated album: {alb.albumartist} - {alb.album}")

            # Process items in library
            for item in lib.items(query):
                if process_item(item):
                    item.store()
                    item.write()
                    print(f"Updated track: {item.artist} - {item.title}")

        cmd.func = func
        return [cmd]
