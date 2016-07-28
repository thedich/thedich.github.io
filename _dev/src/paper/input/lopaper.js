/**
 * Created by dich on 27.07.16.
 */

console.log("__RUN_LOPAPER__");
document.addEventListener("DOMContentLoaded", function(event) {

    d3.xml("data/svgdude.xml").mimeType("image/svg+xml").get(function(error, xml) {
        if (error) throw error;
        document.body.appendChild(xml.documentElement);
        onSVGAppend();
    });

});

(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-74497033-1', 'auto');
ga('send', 'pageview');
