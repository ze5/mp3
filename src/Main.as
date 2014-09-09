package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.ID3Info;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.media.SoundLoaderContext;
	import flash.events.KeyboardEvent;

	/**
	 * ...
	 * @author zez
	 */
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite 
	{
		private var song:Sound = new Sound();
		private var playing:SoundChannel;
		private var track:int = 0;
		private var playlist:Array = new Array();
		private var unparsed:Array;
		private var trackname:String;
		private var artist:String;
		private var loader:URLLoader = new URLLoader();
		private var songUrl:URLRequest = new URLRequest();
		private var uselessNonsense : RegExp = /\r?\n/;
		private var context:SoundLoaderContext = new SoundLoaderContext(8000, true);
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		private function update(e:Event=null):void
		{
			if (song.id3 != null)
			{
				artist = song.id3.artist;
				trackname = song.id3.songName;
				//trace(artist + " - " + trackname);
			}
			
		}
		private function nextTrack(e:Event = null):void
		{
			playing.removeEventListener(Event.SOUND_COMPLETE, nextTrack);
			playing.stop();
			//advance track
			track++;
			if (track >= playlist.length)
			{
				track = 0;
			}
			loadSong();
		}
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			loader.addEventListener(Event.COMPLETE, playlistLoaded);
			loader.load(new URLRequest("list.m3u"));
			addEventListener(Event.ENTER_FRAME, update);
		}
		private function keyDown(e:KeyboardEvent = null):void
		{
			if (e.ctrlKey)
			nextTrack();
		}
		private function playlistLoaded(e:Event):void
		{
			unparsed = String(e.currentTarget.data).split(uselessNonsense);
			playlist.length = 0;
			for (var i:int = 0; i < unparsed.length; i++)
			{
				if ((unparsed[i] as String).charAt(0) != "#")
				{
					playlist.push(unparsed[i]);
				}
			}
			loader.removeEventListener(Event.COMPLETE, playlistLoaded);
			track = 0;
			loadSong();
		}
		private function loadSong():void
		{
			trace(playlist[track] as String);
			songUrl.url = playlist[track] as String;
			song = new Sound();
			song.load(songUrl, context);
			playing = song.play();
			playing.addEventListener(Event.SOUND_COMPLETE, nextTrack);
		}

	}

}