function graficarArbol(jsonArbol){
    d3.select("svg").remove(); 
    var margin = {
        top: 20,
        right: 120,
        bottom: 20,
        left: 120
    },
    
    width = 960 - margin.right - margin.left,
    height = 800 - margin.top - margin.bottom;
    
    var root = jsonArbol;
    
    var i = 0,
        duration = 750,
        rectW = 150,
        rectH = 30;
    
    var tree = d3.layout.tree().nodeSize([250, 50]);
    var diagonal = d3.svg.diagonal()
        .projection(function (d) {
        return [d.x + rectW / 2, d.y + rectH / 2];
    });
    
     var line = d3.svg.line()
                .x(function(d) {
                    return d.x; 
                })
                .y(function(d) {
                    return d.y; 
                });
                
    var lineFunction = d3.svg.line()
      .x(function(d) {
        return d.x;
      })
      .y(function(d) {
        return d.y;
      })
      .interpolate("linear");
    
    var svg = d3.select("#cuerpoArbolModal").append("svg").attr("width", 1000).attr("height", 1000)
        .call(zm = d3.behavior.zoom().on("zoom", redraw)).append("g")
        .attr("transform", "translate(" + 350 + "," + 20 + ")");
    
    zm.translate([350, 20]);
    
    root.x0 = 0;
    root.y0 = height / 2;
    
    function collapse(d) {
        /*if (d.children) {
            d._children = d.children;
            d._children.forEach(collapse);
            d.children = null;
        }*/
    }
    
    update(root);
    
    d3.select("#cuerpoArbolModal").style("height", "800px");
    
    function update(source) {
    
        var nodes = tree.nodes(root).reverse(),
            links = tree.links(nodes);
    
        nodes.forEach(function (d) {
            d.y = d.depth * 180;
        });
    
        var node = svg.selectAll("g.node")
            .data(nodes, function (d) {
            return d.id || (d.id = ++i);
        });
        
    
        var nodeEnter = node.enter().append("g")
            .attr("class", "node")
            .attr("transform", function (d) {
            return "translate(" + source.x0 + "," + source.y0 + ")";
        })
            .on("click", click);
    
       
        nodeEnter.append("ellipse")
            .attr("cx", 75)
            .attr("cy", 15)
            .attr("rx", 100)
            .attr("ry", 25)
            .attr("stroke", "black")
            .attr("stroke-width", 2)
            .style("fill", function (d) {
            return d._children ? "lightsteelblue" : "#fff";
        });
    
        nodeEnter.append("text")
            .attr("x", rectW / 2)
            .attr("y", rectH / 2)
            .attr("dy", ".35em")
            .attr("text-anchor", "middle")
            .text(function (d) {
            return d.name;
        });
    
        var nodeUpdate = node.transition()
            .duration(duration)
            .attr("transform", function (d) {
            return "translate(" + d.x + "," + d.y + ")";
        });
    

        
        nodeUpdate.select("ellipse")
            .attr("cx", 75)
            .attr("cy", 15)
            .attr("rx", 100)
            .attr("ry", 25)
            .attr("stroke", "black")
            .style("fill", function (d) {
            return d._children ? "lightsteelblue" : "#fff";
        });
    
        nodeUpdate.select("text")
            .style("fill-opacity", 1);
    
        var nodeExit = node.exit().transition()
            .duration(duration)
            .attr("transform", function (d) {
            return "translate(" + source.x + "," + source.y + ")";
        })
            .remove();
    
            
             nodeExit.select("ellipse")
            .attr("cx", 75)
            .attr("cy", 15)
            .attr("rx", 100)
            .attr("ry", 25)
            .attr("stroke", "black")
            .attr("stroke-width", 2);
    
        nodeExit.select("text");
    
        var link = svg.selectAll("path.link")
            .data(links, function (d) {
            return d.target.id;
        });
    
        link.enter().insert("path", "g")
            .attr("class", "link")
            .attr("x", rectW / 2)
            .attr("y", rectH / 2)
            .attr("d", function (d) {
            var o = {
                x: source.x0,
                y: source.y0
            };
            return diagonal({
                source: o,
                target: o
            });
    
        });
        
        
        link.transition()
            .duration(duration)
            .attr("d", diagonal);
    
        link.exit().transition()
            .duration(duration)
            .attr("d", function (d) {
            var o = {
                x: source.x,
                y: source.y
            };
            return diagonal({
                source: o,
                target: o
            });
        })
            .remove();
            
    
        nodes.forEach(function (d) {
            d.x0 = d.x;
            d.y0 = d.y;
        });
    }
    
    function click(d) {
        if (d.children) {
            d._children = d.children;
            d.children = null;
        } else {
            d.children = d._children;
            d._children = null;
        }
        update(d);
    }
    
    function redraw() {
      svg.attr("transform",
          "translate(" + d3.event.translate + ")"
          + " scale(" + d3.event.scale + ")");
    }
    }