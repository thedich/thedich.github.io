/**
 * Created by dich on 27.07.16.
 */
console.log("__RUN_DUDE__");

document.addEventListener("DOMContentLoaded", function(event) {

 /* d3.select("body")
        .append("object")
        .attr("data", "data/svgdude.xml")
        .attr("id", "svgdata")
        .attr("width", window.innerWidth)
        .attr("height", window.innerHeight)
        .attr("type", "xml").attr("style","display:none");*/

    d3.xml("data/svgdude.xml").mimeType("image/svg+xml").get(function(error, xml) {
        if (error) throw error;
        document.body.appendChild(xml.documentElement);
        onSVGAppend();
    });

    function onSVGAppend()
    {
        var mouse = [480, 250],
            count = 0;

        var svg = d3.select("body").select("svg")
            .attr("width", window.innerWidth)
            .attr("height", window.innerHeight);

        //console.log("__F:" +  d3.select("object").html());
        //console.log("__G:" +  d3.selectAll("g"));

        var g = svg.selectAll("g");
        var colors = ["#fb000f", "#6e00fb", "#00fbec", "#8dfb00", "#fb3c00"];
        var ranges = [0, 10, 20, 30, 40];
        var hues = 0;

        svg.on("mousemove", function() {
            mouse = d3.mouse(this);
        });

        function colorize()
        {
            var colorScale = d3.scale.linear()
                .domain(ranges)
                .range(colors.reverse())
                .interpolate(d3.interpolateHsl);

            var icolor = Math.floor(Math.random() * colors.length)
            var m = -10;
            g.selectAll("path").style("fill", function (d,i) {
                console.log("M:" + m);
                if(i==0)m++;
                return colorScale(m)
            });
        };

        colorize();

        d3.timer(function() {
            count++;
            g.attr("transform", function(d, i) {
                var thissvg = d3.select(this);

                var angle = Math.sin((count + i) / 10) * 7;
                var ctmx = d3.select(this)[0][0].getScreenCTM().e;
                var ctmy = d3.select(this)[0][0].getScreenCTM().f;

                var thisx = mouse[0] - 720/2;
                var thisy = mouse[1] - 576/2;
                return "rotate(" + angle + ")";
            });
        });
    }

});




/*(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-74497033-1', 'auto');
ga('send', 'pageview');*/
