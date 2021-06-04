package vision;

import js.html.AnchorElement;
import js.Browser.document;
import js.Browser.window;
import js.html.URLSearchParams;
import js.html.VideoElement;
import Hls.Events.*;

function main() {

    var secure = true;
    var host = 'vvv.disktree.net';
    var port = secure ? 443 : 80;
    var app = 'hls';
    var url = 'http${secure?"s":""}://${host}:${port}/${app}';

    var params = new URLSearchParams(window.location.search);
    var stream = params.get("s");
    if( stream == null ) stream = params.get("stream");
    if( stream == null ) stream = 'stream';
    
    var video : VideoElement = cast document.getElementById('video');
    video.preload = "none";

    var rtmpLink : AnchorElement = cast document.getElementById('rtmp-link');
    rtmpLink.href = 'rtmp://$host/vision/$stream';

    var src = '${url}/${stream}.m3u8';
    if( Hls.isSupported() ) {
        trace("HLS supported");
        var hls = new Hls();
        hls.on( MEDIA_ATTACHED, () -> {
            trace('video and hls.js bound together');
        });
        hls.on( MANIFEST_PARSED, (event,data) -> {
            trace('manifest loaded, found ' + data.levels.length + ' quality level');
        });
        hls.loadSource(src);
        hls.attachMedia(video);
    } else if( video.canPlayType('application/vnd.apple.mpegurl') != null ) {
        trace("HLS not supported");
        video.src = src;
    }
}