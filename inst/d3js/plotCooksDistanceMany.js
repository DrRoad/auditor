var minVariable = options.xmin, maxVariable = options.xmax,
    minResidual = options.ymin, maxResidual = options.ymax,
    xTitle = options.xTitle, n = options.n,
    yTitle = options.yTitle, chartTitle = options.chartTitle,
    background = options.background;

var plotHeight, plotWidth,
    margin = {top: 98, right: 30, bottom: 60, left: 60, inner: 70},
    w = width - margin.left - margin.right,
    h = height - margin.top - margin.bottom,
    labelsMargin = margin.left - 8,
    plotTop = margin.top, plotLeft = margin.left;

var m = Math.ceil(n/2);
if (n == 2) { m = 2; }

if (options.scalePlot === true) {
  plotHeight = (h-(m-1)*margin.inner)/m;
  plotWidth = 3*plotHeight/2;
} else {
  plotHeight = 280;
  plotWidth = 420;
}

var modelNames = Object.keys(data[0]);

var colors = getColors(3, "point"),
    pointColor = colors[0],
    greyColor = colors[2];

residual(data);

svg.selectAll("text")
  .style('font-family', 'Fira Sans, sans-serif');

// plot function
function residual(data){
  var pointData = data[0];
  for (var i=0; i<n; i++){
    var modelName = modelNames[i];
    singlePlot(modelName, pointData, i+1);
  }
}

function singlePlot(modelName, pointData, i) {

    var x = d3.scaleLinear()
          .range([plotLeft + 10, plotLeft + plotWidth - 10])
          .domain([minVariable, maxVariable]);

    var y = d3.scaleLinear()
          .range([plotTop + plotHeight, plotTop])
          .domain([minResidual, maxResidual]);

    // add plot things only once
    if (i==1) {
      svg.append("text")
          .attr("class", "bigTitle")
          .attr("x", plotLeft)
          .attr("y", plotTop - 60)
          .text(chartTitle);
    }

    svg.append("text")
        .attr("class","smallTitle")
        .attr("x", plotLeft)
        .attr("y", plotTop - 15)
        .text(modelName);

    // find 5 nice ticks with max and min - do better than d3
    var domain = x.domain();
    var tickValues = d3.ticks(domain[0], domain[1], 5);

    switch (tickValues.length){
      case 3:
        tickValues.unshift(domain[0]);
        tickValues.push(domain[1]);
        break;

      case 4:
        if(Math.abs(domain[0] - tickValues[0]) < Math.abs(domain[1] - tickValues[3])){
          tickValues.shift();
          tickValues.unshift(domain[0]);
          tickValues.push(domain[1]);
        } else {
          tickValues.pop();
          tickValues.push(domain[1]);
          tickValues.unshift(domain[0]);
        }
        break;

      case 5:
        tickValues.pop();
        tickValues.shift();
        tickValues.push(domain[1]);
        tickValues.unshift(domain[0]);
        break;

      case 6:
        if(Math.abs(domain[0] - tickValues[0]) < Math.abs(domain[1] - tickValues[3])){
          tickValues.pop();
          tickValues.shift();
          tickValues.shift();
          tickValues.push(domain[1]);
          tickValues.unshift(domain[0]);
        } else {
          tickValues.pop();
          tickValues.pop();
          tickValues.shift();
          tickValues.push(domain[1]);
          tickValues.unshift(domain[0]);
        }
        break;

      case 7:
        tickValues.pop();
        tickValues.pop();
        tickValues.shift();
        tickValues.shift();
        tickValues.push(domain[1]);
        tickValues.unshift(domain[0]);
    }

    // axis and grid
    var xAxis = d3.axisBottom(x)
              .tickValues(tickValues)
              .tickSizeInner(0)
              .tickPadding(15);

    xAxis = svg.append("g")
              .attr("class", "axisLabel")
              .attr("transform", "translate(0,"+ (plotTop + plotHeight) + ")")
              .call(xAxis);

    var yGrid = svg.append("g")
             .attr("class", "grid")
             .attr("transform", "translate(" + plotLeft + ",0)")
             .call(d3.axisLeft(y)
                    .ticks(10)
                    .tickSize(-plotWidth)
                    .tickFormat("")
            ).call(g => g.select(".domain").remove());

    if (i%2 === 1) {
      var yAxis = d3.axisLeft(y)
              .ticks(5)
              .tickSize(0);

      yAxis = svg.append("g")
              .attr("class", "axisLabel")
              .attr("transform","translate(" + plotLeft + ",0)")
              .call(yAxis)
              .call(g => g.select(".domain").remove());
    }

    if (background === true){
      // draw grey scatter
      for (var j=0; j<n; j++){
        if (modelNames[j] !== modelName){
          let tempName = modelNames[j];

          svg.selectAll()
                .data(pointData[tempName])
                .enter()
                .append("circle")
                .attr("class", "dot " + tempName)
                .attr("id", tempName)
                .attr("cx", d => x(d.x))
                .attr("cy", d => y(d.y))
                .attr("r", 1)
                .style("fill", greyColor)
                .style("opacity", 0.5);
        }
      }
    }

    // scatter
    svg.selectAll()
        .data(pointData[modelName])
        .enter()
        .append("circle")
        .attr("class", "dot " + modelName)
        .attr("id", modelName)
        .attr("cx", d => x(d.x))
        .attr("cy", d => y(d.y))
        .attr("r", 1)
        .style("fill", pointColor);

    svg.selectAll()
        .data(pointData[modelName].filter(function(d){return d.big === true;}))
        .enter()
        .append("text")
        .attr("class", "legendLabel")
        .text(function(d){ return d.x;})
        .attr("x", d => x(d.x))
        .attr("y", d => y(d.y)-2)
        .attr("text-anchor", "middle")

    if (i==n){
    	svg.append("text")
          .attr("class", "axisTitle")
          .attr("transform", "rotate(-90)")
          .attr("y", 15)
          .attr("x", -(margin.top + plotTop + plotHeight)/2)
          .attr("text-anchor", "middle")
          .text(yTitle);

      svg.append("text")
          .attr("class", "axisTitle")
          .attr("y", (plotTop + plotHeight + margin.bottom - 15))
          .attr("x", (margin.left + m*plotWidth + (m-1)*25 + margin.right)/2)
          .attr("text-anchor", "middle")
          .text(xTitle);
 	  }

    if (i%2 === 1){
      plotLeft += (25 + plotWidth);
    }
    if (i%2 === 0){
      plotLeft -= (25 + plotWidth);
      plotTop += (margin.inner + plotHeight);
    }
}
