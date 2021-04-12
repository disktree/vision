package vvv;

import js.Browser.document;
import js.Browser.window;
import js.html.URLSearchParams;
import js.html.VideoElement;

function main() {

    var secure = true;
    var host = 'vvv.disktree.net';
    var port = 9443;
    var app = 'hls';
    var url = 'http${secure?"s":""}://${host}:${port}/${app}';

    var params = new URLSearchParams(window.location.search);
    var stream = params.get("s");
    if( stream == null ) stream = 'stream';
    
    var video : VideoElement = cast document.getElementById('video');
    var src = '${url}/${stream}.m3u8';
    if( Hls.isSupported() ) {
        trace("HLS supported");
        var hls = new Hls();
        hls.loadSource(src);
        hls.attachMedia(video);
    } else if( video.canPlayType('application/vnd.apple.mpegurl') != null ) {
        trace("HLS not supported");
        video.src = src;
    }
    
    //untyped window.customElements.define( 'vvv-player', vvv.Player );
}