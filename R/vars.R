fx.japan_red_colors <-
  tribble(
    ~name, ~color,
    "kuwazome", "#64363C",
    "ebizome", "#6D2E5B",
    "ichigo", "#B5495B",
    "nakabeni", "#DB4D6D",
    "usubeni", "#E87A90",
    "momo", "#F596AA",
    "ikkonzome", "#F4A7B9",
    "taikoh", "#F8C3CD"
  )

fx.japan_beige_color <-
  tribble(
    ~name, ~color,
    "shironeri", "#FCFAF2"
  )

fx.palette <- rev(fx.japan_red_colors$color)

fx.reactable_theme <-
  reactableTheme(
    headerStyle = list(display = "none"),
    style = list(
      fontFamily = "FiraSans-Regular",
      color = "#333",
      fontSize = "14px",
      fontWeight = "bold",
      backgroundColor = fx.japan_beige_color$color
    )
  )

fx.bslib_theme <-
  bs_theme(
    base_font = "FiraSans-Regular"
    ,primary = subset(fx.japan_red_colors, name == "usubeni")$color
    ,bg = fx.japan_beige_color$color
    ,fg = "#333"
  )

fx.preloader = HTML('
  <div class="loading-container">
    <img src="img/logo.svg" class="spinner">
    <div class="loading-text">Loading...</div>
  </div>
')

fx.custom_marker_clustering_js <- JS("
function(cluster) {
  var markers = cluster.getAllChildMarkers();
  var sum = 0;

  // Sum up individual_count from all markers in the cluster
  for (var i = 0; i < markers.length; i++) {
    sum += markers[i].options.individual_count;
  }

  // Dynamically rescale log1p(sum) to match scales::rescale(log1p(x), to = c(10, 60)) in R
  var minLog = Math.log1p(0);   // Equivalent to log1p(min(x))
  var maxLog = Math.log1p(500); // Equivalent to log1p(max(x))
  var log_sum = Math.log1p(sum);
  var size = (10 + (log_sum - minLog) * (60 - 10) / (maxLog - minLog)) * 1.5; // Rescaled size with base multiplier

  var color;
  if (sum <= 10) color = '#ffafcc';
  else if (sum <= 50) color = '#f19cb7';
  else if (sum <= 200) color = '#e289a2';
  else if (sum <= 500) color = '#d3768d';
  else if (sum <= 1000) color = '#c46479';
  else if (sum <= 5000) color = '#b45264';
  else if (sum <= 10000) color = '#a44050';
  else color = '#942d3d';

  return new L.DivIcon({
    html: '<div class=\"cluster-icon\" style=\"background-color:' + color + ';width:' + size + 'px;height:' + size + 'px;\">' + sum + '</div>',
    className: 'no-background',
    iconSize: new L.Point(size, size)
  });
}")
